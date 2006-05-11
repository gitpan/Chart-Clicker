package Chart::Clicker;
use strict;

use base 'Chart::Clicker::Drawing::Container';
__PACKAGE__->mk_accessors(
    qw(
        color_allocator legend plot
    )
);

use Chart::Clicker::Log;
use Chart::Clicker::Plot;

use Chart::Clicker::Decoration::Legend;

use Chart::Clicker::Drawing qw(:common);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::ColorAllocator;
use Chart::Clicker::Drawing::Insets;
use Chart::Clicker::Drawing::Point;

use Cairo;

use Log::Log4perl;

=head1 NAME

Chart::Clicker - Powerful, extensible charting.

=head1 DESCRIPTION

Chart::Clicker aims to be a powerful, extensible charting package that creates
really pretty output.

Clicker leverages the power of Cairo to create snazzy 2D graphics easily and
quickly.

=head1 SYNOPSIS

  use Chart::Clicker;
  use Chart::Clicker::Drawing::Color;

  my $c = new Chart::Clicker({ width => 500, height => 350 });
  $chart->background_color(
    new Chart::Clicker::Drawing::Color({
        red => 1, green => 1, blue => 1, alpha => 1
    })
 }

  my $series = new Chart::Clicker::Data::Series();
  $series->keys([1, 2, 3, 4, 5, 6]);
  $series->values([12, 9, 8, 3, 5, 1]);

  my $dataset = new Chart::Clicker::Data::DataSet();
  $dataset->series([$series]);

  $chart->plot()->datasets([$datasets]);

  my $renderer = new Chart::Clicker::Renderer::Line();
  $chart->plot()->renderer($renderer);

  $chart->draw();
  $chart->write('/path/to/chart.png');

=cut

our $VERSION = '0.9.1';

my $log = Chart::Clicker::Log->get_logger('Chart');

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker object. If no width and height are specified then
defaults of 500 and 300 are chosen, respectively.

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);
    unless($self->width()) {
        $self->width(500);
    }
    unless($self->height()) {
        $self->height(300);
    }
    unless($self->insets()) {
        $self->insets(
            new Chart::Clicker::Drawing::Insets(
                { top => 5, bottom => 5, left => 5, right => 5 }
            )
        );
    }
    unless(defined($self->legend())) {
        $self->legend(new Chart::Clicker::Decoration::Legend());
    }
    unless($self->plot()) {
        $self->plot(new Chart::Clicker::Plot());
    }
    unless($self->background_color()) {
        $self->background_color(
            new Chart::Clicker::Drawing::Color(
                { red => 1, green => 1, blue => 1, alpha => 1 }
            )
        );
    }
    unless(defined($self->color_allocator())) {
        $self->color_allocator(new Chart::Clicker::Drawing::ColorAllocator());
    }
    unless($self->border()) {
        $self->border(new Chart::Clicker::Drawing::Border());
    }

    return $self;
}
=back

=head2 Class Methods

=over 4

=item $c->draw()

Draw this chart

=cut
sub draw {
    my $self = shift();

    my $plot = $self->plot();

    my $legend = $self->legend();

    my $insets = $self->insets();
    my $width = $self->width();
    my $height = $self->height();

    my $surface = Cairo::ImageSurface->create('argb32', $width, $height);
    my $cr = Cairo::Context->create($surface);

    # Background fill
    $cr->set_source_rgba($self->background_color()->rgba());
    $cr->rectangle(0, 0, $width, $height);
    $cr->fill();

    # This lil' guy will hold the 'bump' from the edge that would occur
    # if we render the legend.
    my $bump;
    if(defined($legend)) {
        my $llength;
        if($legend->orientation() == $CC_HORIZONTAL) {
            $llength = $self->inside_width();
        } else {
            $llength = $self->inside_height();
        }
        my $ollength = $legend->prepare(
           $cr, $llength, $self->color_allocator(), $plot->datasets()
        );

        $bump = $ollength;
        my $lsurface = $legend->draw($llength, $ollength, $plot->datasets());
        $cr->set_source_surface(
            $lsurface, $insets->left() + 1, $insets->top() + 1
        );
        $cr->paint();

        # The legend used the color allocator.  Reset it so that the next
        # user gets the same colors.
        $self->color_allocator()->reset();
    }

    # XXX This is wrong...
    $bump += 3;

    $insets->top($insets->top() + $bump);

    $plot->width($self->inside_width());
    $plot->height($self->inside_height());

    $plot->prepare();

    my $plotxy = new Chart::Clicker::Drawing::Point({
        x => $insets->left() + $self->border()->stroke()->width(), y => $insets->top() + $self->border()->stroke()->width()
    });

    my $psurf = $plot->draw($self->color_allocator());

    # Border
    $cr->set_source_rgba($self->border()->color()->rgba());
    # Strokes _outline_ a shape, so we need to take half the stroke, so we
    # know how much to adjust our coordinates by.
    $cr->set_line_width($self->border()->stroke()->width());
    $cr->set_line_cap($self->border()->stroke()->line_cap());
    $cr->set_line_join($self->border()->stroke()->line_join());
    my $swhalf = $self->border()->stroke()->width() / 2;
    $cr->new_path();
    # UL
    $cr->move_to($swhalf, $swhalf);
    # UR
    $cr->line_to($width - $swhalf, $swhalf);
    # LR
    $cr->line_to($width - $swhalf, $height - $swhalf);
    # LL
    $cr->line_to($swhalf, $height - $swhalf);
    $cr->close_path();
    $cr->stroke();

    $cr->set_source_surface($psurf, $plotxy->x(), $plotxy->y());
    $cr->paint();
    $self->{'SURFACE'} = $surface;
}

sub write {
    my $self = shift();
    my $file = shift();

    $self->{'SURFACE'}->write_to_png($file);
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
