package Chart::Clicker::Drawing::Insets;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(top bottom left right));

=head1 NAME

Chart::Clicker::Drawing::Insets

=head1 DESCRIPTION

Chart::Clicker::Drawing::Insets represents the amount of space a container must leave at
it's edges.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Drawing::Insets->new({
    top     => $TOP,
    bottom  => $BOTTOM,
    left    => $LEFT,
    right   => $RIGHT
});

Creates a new Chart::Clicker::Drawing::Insets.

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->top())) {
        $self->top(0);
    }
    unless(defined($self->bottom())) {
        $self->bottom(0);
    }
    unless(defined($self->left())) {
        $self->left(0);
    }
    unless(defined($self->right())) {
        $self->right(0);
    }

    return $self;
}

=back

=head2 Class Methods

=over 4

=item $top = $i->top($TOP)

Set/Get the inset from the top.

=item $left = $i->left($LEFT)

Set/Get the inset from the left.

=item $right = $i->right($RIGHT)

Set/Get the inset from the right.

=item $bottom = $i->bottom($BOTTOM)

Set/Get the inset from the bottom.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
