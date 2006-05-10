package Chart::Clicker::Drawing::Font;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(face size slant weight));

our $FONT_SLANT_NORMAL = 'normal';
our $FONT_SLANT_ITALIC = 'italic';
our $FONT_SLANT_OBLIQUE = 'oblique';

our $FONT_WEIGHT_NORMAL = 'normal';
our $FONT_WEIGHT_BOLD = 'bold';

=head1 NAME

Chart::Clicker::Drawing::Font

=head1 DESCRIPTION

Chart::Clicker::Drawing::Font represents the various options that are available
when rendering text on the chart.

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

    unless(defined($self->face())) {
        $self->face('Sans');
    }
    unless(defined($self->size())) {
        $self->size(12);
    }
    unless(defined($self->slant())) {
        $self->slant($FONT_SLANT_NORMAL);
    }
    unless(defined($self->weight())) {
        $self->weight($FONT_WEIGHT_NORMAL);
    }

    return $self;
}

=back

=head2 Class Methods

=over 4

=item $size = $s->size($SIZE)

Set/Get the size of this text.

=item $slant = $s->slant($slant)

Set/Get the slant of this text.

=item $weight = $s->slant($weight)

Set/Get the weight of this text.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
