package Chart::Clicker::Drawing::Point;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(x y));

=head1 NAME

Chart::Clicker::Drawing::Point

=head1 DESCRIPTION

Chart::Clicker::Drawing::Point represents a location in (x, y) coordinate space.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Drawing::Point->new({ x => $X, y => $Y});

Creates a new Chart::Clicker::Drawing::Point.

=back

=head2 Class Methods

=over 4

=item $x = $p->x($X)

Set/Get the X coordinate.

=item $y = $p->y($Y)

Set/Get the Y coordinate.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
