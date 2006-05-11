package Chart::Clicker::Shape::Arc;
use strict;

use base 'Chart::Clicker::Shape';
__PACKAGE__->mk_accessors(qw(angle1 angle2 radius));

use constant TO_RAD => (4 * atan2(1, 1)) / 180;

=head1 NAME

Chart::Clicker::Shape::Arc

=head1 DESCRIPTION

Chart::Clicker::Shape::Arc represents an arc.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

new()

Creates a new Chart::Clicker::Arc.

=back

=head2 Class Methods

=over 4

=item angle1()

Set/Get the starting angle for this arc.

=item angle2()

Set/Get the ending angle for this arc.

=item radius()

Set/Get the radius for this arc.

=item create_path($cairo, $x, $y)

Creates a path using this arcs attributes.

=cut
sub create_path {
    my $self = shift();
    my ($cairo, $x, $y) = @_;

    $cairo->arc(
        $x, $y, $self->radius(),
        $self->angle1() * TO_RAD,
        $self->angle2() * TO_RAD
    );
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
