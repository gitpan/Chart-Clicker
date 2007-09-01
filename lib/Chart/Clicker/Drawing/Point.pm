package Chart::Clicker::Drawing::Point;
use strict;
use warnings;

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw(x y));

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Point

=head1 DESCRIPTION

Chart::Clicker::Drawing::Point represents a location in (x, y) coordinate space.

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Point;

  my $point = Chart::Clicker::Drawing::Point->new({ x => 2, y => 0 });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Drawing::Point.

=back

=head2 Class Methods

=over 4

=item x

Set/Get the X coordinate.

=item y

Set/Get the Y coordinate.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
