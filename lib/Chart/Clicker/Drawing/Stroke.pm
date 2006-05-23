package Chart::Clicker::Drawing::Stroke;
use strict;

use base qw(Class::Accessor Exporter);
__PACKAGE__->mk_accessors(qw(width line_cap line_join));

@Chart::Clicker::Drawing::Stroke::EXPORT_OK = qw(
  $CC_LINE_CAP_BUTT $CC_LINE_CAP_ROUND $CC_LINE_CAP_SQUARE
  $CC_LINE_JOIN_MITER $CC_LINE_JOIN_ROUND $CC_LINE_JOIN_BEVEL
);
%Chart::Clicker::Drawing::Stroke::EXPORT_TAGS = (
    line_caps => [ qw(
        $CC_LINE_CAP_BUTT $CC_LINE_CAP_ROUND $CC_LINE_CAP_SQUARE
    ) ],
    line_joins => [ qw(
        $CC_LINE_JOIN_MITER $CC_LINE_JOIN_ROUND $CC_LINE_JOIN_BEVEL
    ) ],
);

our $CC_LINE_CAP_BUTT = 'butt';
our $CC_LINE_CAP_ROUND = 'round';
our $CC_LINE_CAP_SQUARE = 'square';

our $CC_LINE_JOIN_MITER = 'miter';
our $CC_LINE_JOIN_ROUND = 'round';
our $CC_LINE_JOIN_BEVEL = 'bevel';

=head1 NAME

Chart::Clicker::Drawing::Stroke

=head1 DESCRIPTION

Chart::Clicker::Drawing::Stroke represents the decorative outline around a component.
Since a line is infinitely small, we need some sort of outline to be able to
see it!

=head1 SYNOPSIS

  use Chart::Clicker::Drawing::Stroke qw(:line_caps :line_joins);

  my $stroke = new Chart::Clicker::Drawing::Stroke({
    line_cap => $CC_LINE_CAP_ROUND,
    line_join => $CC_LINE_JOIN_MITER,
    width => 2
  });

=head1 EXPORTS

$CC_LINE_CAP_BUTT
$CC_LINE_CAP_ROUND
$CC_LINE_CAP_SQUARE

$CC_LINE_JOIN_MITER
$CC_LINE_JOIN_ROUND
$CC_LINE_JOIN_BEVEL

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Decoration::Stroke.  If no options are provided
the width defaults to 1, the line_cap defaults to $CC_LINE_CAP_BUTT and the
line_join defaults to $CC_LINE_JOIN_MITER.

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->width())) {
        $self->width(1);
    }
    unless(defined($self->line_cap())) {
        $self->line_cap($CC_LINE_CAP_BUTT);
    }
    unless(defined($self->line_join())) {
        $self->line_join($CC_LINE_JOIN_MITER);
    }

    return $self;
}

=back

=head2 Class Methods

=over 4

=item line_cap

Set/Get the line_cap of this stroke.

=item line_join

Set/Get the line_join of this stroke.

=item width

Set/Get the width of this stroke.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
