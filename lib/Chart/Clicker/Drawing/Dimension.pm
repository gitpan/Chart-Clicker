package Chart::Clicker::Drawing::Dimension;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(height width));

=head1 NAME

Chart::Clicker::Drawing::Dimension

=head1 DESCRIPTION

Chart::Clicker::Drawing::Dimension represents the width and height of an area.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $dim = new Chart::Clicker::Drawing::Dimension({
    width => 300,
    height => 200
  });

Creates a new Chart::Clicker::Drawing::Dimension.

=back

=head2 Class Methods

=over 4

=item height

Set/Get the height of this Dimension

=item width

Set/Get the width of this Dimension

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org

=head1 SEE ALSO

perl(1)

=cut
1;
