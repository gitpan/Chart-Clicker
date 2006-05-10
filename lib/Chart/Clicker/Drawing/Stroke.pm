package Chart::Clicker::Drawing::Stroke;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(width line_cap line_join));

our $LINE_CAP_BUTT = 'butt';
our $LINE_CAP_ROUND = 'round';
our $LINE_CAP_SQUARE = 'square';

our $LINE_JOIN_MITER = 'miter';
our $LINE_JOIN_ROUND = 'round';
our $LINE_JOIN_BEVEL = 'bevel';

=head1 NAME

Chart::Clicker::Drawing::Stroke

=head1 DESCRIPTION

Chart::Clicker::Drawing::Stroke represents the decorative outline around a component.
Since a line is infinitely small, we need some sort of outline to be able to
see it!

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Decoration::Stroke->new({ width => $WIDTH })

Creates a new Chart::Clicker::Decoration::Stroke.

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->width())) {
        $self->width(1);
    }
    unless(defined($self->line_cap())) {
        $self->line_cap($LINE_CAP_BUTT);
    }
    unless(defined($self->line_join())) {
        $self->line_join($LINE_JOIN_MITER);
    }

    return $self;
}

=back

=head2 Class Methods

=over 4

=item $width = $s->width($WIDTH)

Set/Get the width of this stroke.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
