package Chart::Clicker::Data::Range;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(lower upper));

=head1 NAME

Chart::Clicker::Data::Range

=head1 DESCRIPTION

Chart::Clicker::Data::Range implements a range of values.

=head1 SYNOPSIS

  use Chart::Clicker::Data::Range;

  my $range = new Chart::Clicker::Data::Range({
    lower => 1,
    upper => 10
  });

=head1 METHODS

=head2 Constructors

=over 4

=item new

Creates a new, empty Series

=item lower

Set/Get the lower bound for this Range

=item upper

Set/Get the upper bound for this Range

=item span

Returns the span of this range, or UPPER - LOWER.

=cut
sub span {
    my $self = shift();

    return $self->upper() - $self->lower();
}

=item combine

Combine this range with the specified so that this range encompasses the
values specified.

=cut
sub combine {
    my $self = shift();
    my $range = shift();

    if(!defined($self->lower()) or ($range->lower() < $self->lower())) {
        $self->lower($range->lower());
    }

    if(!defined($self->upper()) or ($range->upper() > $self->upper())) {
        $self->upper($range->upper());
    }
}

=item divvy

  my $values = $range->divvy(5);

Returns an arrayref of $N - 1 values equally spaced in the range so that
it may be divided into $N pieces.

=cut
sub divvy {
    my $self = shift();
    my $n = shift();

    my $per = $self->span() / $n;

    my @vals;
    for(my $i = 1; $i < $n; $i++) {
        push(@vals, $i * $per);
    }

    return \@vals;
}

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@cpan.org>

=head1 SEE ALSO

=cut
1;
