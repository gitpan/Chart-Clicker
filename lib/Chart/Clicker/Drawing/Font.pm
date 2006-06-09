package Chart::Clicker::Drawing::Font;
use strict;
use warnings;

use base qw(Class::Accessor Exporter);
__PACKAGE__->mk_accessors(qw(face size slant weight));

@Chart::Clicker::Drawing::Font::EXPORT_OK = qw(
    $CC_FONT_SLANT_NORMAL $CC_FONT_SLANT_ITALIC $CC_FONT_SLANT_OBLIQUE
    $CC_FONT_WEIGHT_NORMAL $CC_FONT_WEIGHT_BOLD
);
%Chart::Clicker::Drawing::Font::EXPORT_TAGS = (
    slants => [ qw(
        $CC_FONT_SLANT_NORMAL $CC_FONT_SLANT_ITALIC $CC_FONT_SLANT_OBLIQUE
    ) ],
    weights => [ qw(
        $CC_FONT_WEIGHT_NORMAL $CC_FONT_WEIGHT_BOLD
    ) ]
);

our $CC_FONT_SLANT_NORMAL = 'normal';
our $CC_FONT_SLANT_ITALIC = 'italic';
our $CC_FONT_SLANT_OBLIQUE = 'oblique';

our $CC_FONT_WEIGHT_NORMAL = 'normal';
our $CC_FONT_WEIGHT_BOLD = 'bold';

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
        $self->slant($CC_FONT_SLANT_NORMAL);
    }
    unless(defined($self->weight())) {
        $self->weight($CC_FONT_WEIGHT_NORMAL);
    }

    return $self;
}

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Font

=head1 DESCRIPTION

Chart::Clicker::Drawing::Font represents the various options that are available
when rendering text on the chart.

=head1 EXPORTS

$CC_FONT_SLANT_NORMAL
$CC_FONT_SLANT_ITALIC
$CC_FONT_SLANT_OBLIQUE

$CC_FONT_WEIGHT_NORMAL
$CC_FONT_WEIGHT_BOLD

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Font;

  my $font = new Chart::Clicker::Drawing::Font({
    face => 'Sans',
    size => 12,
    slant => $Chart::Clicker::Drawing::FONT_SLANT_NORMAL
  });

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Decoration::Font.

=back

=head2 Class Methods

=over 4

=item size

Set/Get the size of this text.

=item slant

Set/Get the slant of this text.

=item weight

Set/Get the weight of this text.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
