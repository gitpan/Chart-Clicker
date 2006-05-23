package Chart::Clicker::Decoration::Grid;
use strict;

use base 'Chart::Clicker::Decoration::Base';

__PACKAGE__->mk_accessors(qw(background_color color domain_values range_values stroke));

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Decoration::Grid');

use Chart::Clicker::Decoration::Marker;
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

use Cairo;

=head1 NAME

Chart::Clicker::Decoration::Grid

=head1 DESCRIPTION

Generates a collection of Markers for use as a background.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->background_color())) {
        $self->background_color(
            new Chart::Clicker::Drawing::Color({
                red => 0.9, green => 0.9, blue => 0.9, alpha => 1
            })
        );
    }

    unless(defined($self->color())) {
        $self->color(
            new Chart::Clicker::Drawing::Color({
                red => 0, green => 0, blue => 0, alpha => .30
            })
        );
    }

    unless(defined($self->stroke())) {
        $self->stroke(
            new Chart::Clicker::Drawing::Stroke()
        );
    }

    return $self;
}

=item prepare

Prepare this Grid for drawing

=cut
sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());
}

=back

=head2 Class Methods

=over 4

=item color

Set/Get the color for this Grid.

=item domain_ticks

Set/Get the domain ticks for this Grid.

=item range_ticks

Set/Get the range ticks for this Grid.

=item stroke

Set/Get the Stroke for this Grid.

=item draw

Draw this Grid.

=cut

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $surface = $self->SUPER::draw($clicker);
    my $cr = Cairo::Context->create($surface);

    $cr->set_source_rgba($self->background_color()->rgba());
    $cr->paint();

    my $daxis = $clicker->domain_axes()->[0];
    my $raxis = $clicker->range_axes()->[0];

    # Make the grid

    my $per = $daxis->per();
    my $height = $self->height();
    foreach my $val (@{ $daxis->tick_values() }) {
        $cr->move_to($val * $per, 0);
        $cr->rel_line_to(0, $height);
    }

    $per = $raxis->per();
    my $width = $self->width();
    foreach my $val (@{ $raxis->tick_values() }) {
        $cr->move_to(0, $height - $val * $per);
        $cr->rel_line_to($width, 0);
    }

    $cr->set_source_rgba($self->color()->rgba());
    my $stroke = $self->stroke();
    $cr->set_line_width($stroke->width());
    $cr->set_line_cap($stroke->line_cap());
    $cr->set_line_join($stroke->line_join());
    $cr->stroke();

    return $surface;
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
