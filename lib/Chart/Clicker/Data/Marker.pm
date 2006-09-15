package Chart::Clicker::Data::Marker;
use strict;
use warnings;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(inside_color color stroke key value key2 value2));

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

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
    unless(defined($self->inside_color())) {
        $self->inside_color(
            new Chart::Clicker::Drawing::Color({
                red => 0, green => 0, blue => 0, alpha => .60
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

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Marker

=head1 DESCRIPTION

Used to highlight a particular key, value or range of either.

=head1 SYNOPSIS

 use Chart::Clicker::Decoration::Marker;
 use Chart::Clicker::Drawing::Color;
 use Chart::Clicker::Drawing::Stroke;

 my $mark = new Chart::Clicker::Decoration::Marker({
    color=  > new Chart::Clicker::Drawing::Color({ name => 'red' }),
    stroke  => new CHart::Clicker::Drawing::Stroke(),
    key     => 12,
    value   => 123,
    # Optionally
    key2    => 13,
    value   => 146
 });

=head1 METHODS

=head2 Constructor

=over 4

=item new

=back

=head2 Class Methods

=over 4

=item color

Set/Get the color for this marker.

=item stroke

Set/Get the stroke for this Marker.

=item key

Set/Get the key for this marker.  This represents a point on the domain.

=item key2

Set/Get the key2 for this marker.  This represents a second point on the domain
and is used to specify a range.

=item value

Set/Get the value for this marker.  This represents a point on the range.

=item value2

Set/Get the value2 for this marker.  This represents a second point on the
range and is used to specify a range.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
