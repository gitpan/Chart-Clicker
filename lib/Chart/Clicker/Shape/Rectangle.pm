package Chart::Clicker::Shape::Rectangle;
use strict;

use base 'Chart::Clicker::Shape';
__PACKAGE__->mk_accessors(qw(width height));

=head1 NAME

Chart::Clicker::Rectangle

=head1 DESCRIPTION

Chart::Clicker::Rectangle represents an rectangle.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

new()

Creates a new Chart::Clicker::Rectangle.

=back

=head2 Class Methods

=over 4

=item width()

Set/Get the width of this rectangle.

=item height()

Set/Get the height of this rectangle.

=item create_path($cairo, $x, $y)

Creates a path using this arcs attributes.

=cut
sub create_path {
    my $self = shift();
    my ($cairo, $x, $y) = @_;

    $cairo->rectangle(
        $x - ($self->width() / 2),
        $y - ($self->height() / 2),
        $self->width(),
        $self->height()
    );
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
