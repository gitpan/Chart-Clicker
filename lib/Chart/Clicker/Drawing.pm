package Chart::Clicker::Drawing;
use strict;

use base 'Exporter';

@Chart::Clicker::Drawing::EXPORT_OK = qw();
@Chart::Clicker::Drawing::EXPORT_OK = qw(
    $CC_HORIZONTAL $CC_VERTICAL $CC_TOP $CC_BOTTOM $CC_LEFT $CC_RIGHT $CC_CENTER
);
%Chart::Clicker::Drawing::EXPORT_TAGS = (
    common => \@Chart::Clicker::Drawing::EXPORT_OK
);

our $CC_HORIZONTAL = 0;
our $CC_VERTICAL = 1;
our $CC_TOP = 2;
our $CC_BOTTOM = 3;
our $CC_LEFT = 4;
our $CC_RIGHT = 5;
our $CC_CENTER = 6;

=head1 NAME

Chart::Clicker::Drawing

=head1 DESCRIPTION

Chart::Clicker::Drawing holds some common items used in Drawing.

=head1 EXPORTS

$CC_HORIZONTAL;
$CC_VERTICAL;
$CC_TOP;
$CC_BOTTOM;
$CC_LEFT;
$CC_RIGHT;

=head1 METHODS

=over 4

=back

=head2 Class Methods

=over 4

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
