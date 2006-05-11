package Chart::Clicker::Drawing::Border;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(color stroke));

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

=head1 NAME

Chart::Clicker::Drawing::Border

=head1 DESCRIPTION

Chart::Clicker::Drawing::Border describes the border to be rendered around a
component.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Border->new({ color => $COLOR, stroke => $STROKE});

Creates a new Chart::Clicker::Border.

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
    unless($self->stroke()) {
        $self->stroke(new Chart::Clicker::Drawing::Stroke());
    }

    return $self;
}

=back

=head2 Class Methods

=over 4

=item $color = $p->color($COLOR)

Set/Get the Color.

=item $stroke = $p->stroke($stroke)

Set/Get the Stroke.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
