package Chart::Clicker::Renderer::Point;
use strict;

=head1 NAME

Chart::Clicker::Renderer::Point

=head1 DESCRIPTION

Chart::Clicker::Renderer::Point renders a dataset as points.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';
__PACKAGE__->mk_accessors(qw(shape));

use Chart::Clicker::Log;
use Chart::Clicker::Shape::Arc;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Renderer::Point');

=head1 METHODS

=head2 Constructor

=over 4

new()

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);
    unless($self->shape()) {
        $self->shape(
            new Chart::Clicker::Shape::Arc({
                radius => 3,
                angle1 => 0,
                angle2 => 360
            })
        );
    }
    return $self;
}

=back

=head2 Class Methods

=over 4

=item $image = $r->render($color_allocator)

Render the series.

=cut
sub render {
    my $self = shift();
    my $cr = shift();
    my $ca = shift();
    my $dataset = shift();
    my $domain = shift();
    my $range = shift();

    my $xper = $domain->per();
    my $yper = $range->per();
    my $min = $dataset->range()->lower();
    my $height = $range->height();

    foreach my $series (@{ $dataset->series() }) {
        my $color = $ca->next();
        $cr->set_source_rgba($color->rgba());
        my @vals = @{ $series->values() };
        for(my $i = 0; $i < $series->key_count(); $i++) {
            my $x = $xper * $i;
            my $y = $height - ($yper * ($vals[$i] - $min));
            $log->debug("Plotting value $i (".$vals[$i].") at $x,$y.");

            $self->shape()->create_path($cr, $x, $y);
            $cr->fill();
        }
    }
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut

1;
