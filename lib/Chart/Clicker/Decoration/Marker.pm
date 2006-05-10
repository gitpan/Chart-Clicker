package Chart::Clicker::Decoration::Marker;
use strict;

use base 'Chart::Clicker::Decoration::Base';
__PACKAGE__->mk_accessors(qw(above color stroke value));

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

=head1 NAME

Chart::Clicker::Decoration::Marker

=head1 DESCRIPTION

Used to highlight a particular value.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->above())) {
        $self->above(0);
    }
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

=head2 Class Methods

=over 4

=item $above = $m->above($above)

Set/Get the 'above' flag that determines if a marker is drawn above or below
the rendered values.

=item $color = $m->color($color)

Set/Get the color for this marker.

=item $stroke = $m->stroke($stroke)

Set/Get the stroke for this Marker.

=item $value = $m->value($value)

Set/Get the value for this marker.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
