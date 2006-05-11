package Chart::Clicker::Drawing::Component;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(
        height location width
    )
);

=head1 NAME

Chart::Clicker::Component

=head1 DESCRIPTION

A Component is an entity with a graphical representation.

=head1 SYNOPSIS

  my $c = new Chart::Clicker::Component({
    location => new Chart::Clicker::Drawing::Point({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $c = new Chart::Clicker::Component({
    location => new Chart::Clicker::Drawing::Point({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

Creates a new Component.

=back

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);

    return $self;
}

=head2 Class Methods

=over 4

=item height

Set/Get this Component's height

=item location

Set/Get this Component's location

=item width

Set/Get this Component's height

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
