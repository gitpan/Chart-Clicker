package Chart::Clicker::Decoration::Marker;
use strict;
use warnings;

use base 'Chart::Clicker::Decoration::Base';
__PACKAGE__->mk_accessors(qw(above color stroke value));

use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Stroke;

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

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Marker

=head1 DESCRIPTION

Used to highlight a particular value.

=head1 SYNOPSIS

 use Chart::Clicker::Decoration::Marker;
 use Chart::Clicker::Drawing::Color;
 use Chart::Clicker::Drawing::Stroke;

 my $mark = Chart::Clicker::Decoration::Marker({
    color => new Chart::Clicker::Drawing::Color({ name => 'red' }),
    stroke => new CHart::Clicker::Drawing::Stroke(),
    value => 123
 });

=head1 METHODS

=head2 Constructor

=over 4

=item new

=back

=head2 Class Methods

=over 4

=item above

Set/Get the 'above' flag that determines if a marker is drawn above or below
the rendered values.

=item color

Set/Get the color for this marker.

=item stroke

Set/Get the stroke for this Marker.

=item value

Set/Get the value for this marker.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
