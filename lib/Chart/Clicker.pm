package Chart::Clicker;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(
        background_color border color_allocator height insets legend plot width
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

use Time::HiRes qw(time);

use Log::Log4perl;

=head1 NAME

Chart::Clicker - Graphs

=head1 DESCRIPTION

Chart::Clicker takes Elements and creates PNG chart.

=head1 SYNOPSIS

  my $c = new Chart::Clicker({ width => 500, height => 350 });

  my $dataset = new Chart::Clicker::Data::DataSet();

  my $series = new Chart::Clicker::Data::Series();
  $series->keys([1, 2, 3, 4, 5, 6]);
  $series->values([12, 9, 8, 3, 5, 1]);

  $dataset->series([$series]);

  $chart->datasets([$datasets]);

  my $renderer = new Chart::Clicker::Renderer::Line();
  $chart->plot()->renderer($renderer);

  $chart->draw();
  my $img = $chart->image();

=cut

our $VERSION = '0.9.0';

my $log = Chart::Clicker::Log->get_logger('Chart');

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker->new(

)

Creates a new Chart::Clicker object.  Sets the width to 500, the
height to 300.

=back

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

=head2 Class Methods

=over 4

=item $c->inside_width()

Get this Chart's 'inside' width.  i.e. width - insets->left() - insets->right
- border()->stroke()->width * 2.


Be aware that this isn't a constant value.  As insets are changed, this value
changes.

=cut
sub inside_width {
    my $self = shift();

    return $self->width() - $self->insets()->left() - $self->insets()->right()
        - $self->border()->stroke()->width() * 2;
}

=item $c->inside_height()

Get this Chart's 'inside' height.  i.e. height - insets->top()
- insets->bottom() - border->stroke()->width * 2.

Be aware that this isn't a constant value.  As insets are changed, this value
changes.

=cut
sub inside_height {
    my $self = shift();

    return $self->height() - $self->insets()->bottom() - $self->insets()->top()
        - $self->border()->stroke()->width() * 2;
}


=item $c->draw()

Draw this chart

=cut
sub draw {
    my $self = shift();

    my $s = time();

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

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
