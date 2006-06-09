package Chart::Clicker::Data::Range;
use strict;
use warnings;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(lower upper));

sub span {
    my $self = shift();

    return $self->upper() - $self->lower();
}

sub combine {
    my $self = shift();
    my $range = shift();

    if(!defined($self->lower()) || ($range->lower() < $self->lower())) {
        $self->lower($range->lower());
    }

    if(!defined($self->upper()) || ($range->upper() > $self->upper())) {
        $self->upper($range->upper());
    }

    return 1;
}

sub divvy {
    my $self = shift();
    my $n = shift();

    my $per = $self->span() / $n;

    my @vals;
    for(1..($n - 1)) {
        push(@vals, $_ * $per);
    }

    return \@vals;
}

1;
__END__

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

=item combine

Combine this range with the specified so that this range encompasses the
values specified.

=item divvy

  my $values = $range->divvy(5);

Returns an arrayref of $N - 1 values equally spaced in the range so that
it may be divided into $N pieces.

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
