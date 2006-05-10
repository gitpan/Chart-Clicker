package Chart::Clicker::Decoration::Grid;
use strict;

use base 'Chart::Clicker::Decoration::Base';

__PACKAGE__->mk_accessors(qw(color domain_values range_values stroke));

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Decoration::Grid');

use Chart::Clicker::Decoration::Marker;
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

=head1 NAME

Chart::Clicker::Decoration::Marker

=head1 DESCRIPTION

Used to highlight a particular value.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->color())) {
        $self->color(
            new Chart::Clicker::Drawing::Color({
                red => 0, green => 0, blue => 0, alpha => 1
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

=back

=head2 Class Methods

=over 4

=item $color = $g->color($color)

Set/Get the color for this Grid.

=item $ticks = $g->domain_ticks($ticks)

Set/Get the domain ticks for this Grid.

=item $ticks = $g->range_ticks($ticks)

Set/Get the range ticks for this Grid.

=item $stroke = $g->stroke($stroke)

Set/Get the Stroke for this Grid.

=item $g->prepare($plot)

Prepare this Grid by creating the various markers and adding them to the Plot.

=cut

sub prepare {
    my $self = shift();
    my $fdaxis = shift();
    my $fraxis = shift();

    # Make the grid

    my @dmarks;
    my @rmarks;

    foreach my $val (@{ $fdaxis->tick_values() }) {
        my $m = new Chart::Clicker::Decoration::Marker({
            value => $val
        });
        if($self->color()) {
            $m->color($self->color());
        }
        push(@dmarks, $m);
    }

    foreach my $val (@{ $fraxis->tick_values() }) {
        my $m = new Chart::Clicker::Decoration::Marker({
            value => $val
        });
        if($self->color()) {
            $m->color($self->color());
        }
        push(@rmarks, $m);
    }

    return (\@dmarks, \@rmarks);
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
