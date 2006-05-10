package Chart::Clicker::Data::Range;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(lower upper));

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Data::Range');

=head1 NAME

Chart::Clicker::Data::Range

=head1 DESCRIPTION

Chart::Clicker::Data::Range implements a range of values.

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 Constructors

=over 4

=item new({ lower => $LOWER, upper => $UPPER })

Creates a new, empty Series

=item $lower = $range->lower($lower)

Set/Get the lower bound for this Range

=item $upper = $range->upper($upper)

Set/Get the upper bound for this Range

=item $span = $range->span()

Returns the span of this range, or UPPER - LOWER.

=cut
sub span {
    my $self = shift();

    return $self->upper() - $self->lower();
}

=item $arrayref = $range->combine($lower, $upper)

Combine this range with the specified so that this range encompasses the
the values specified.

=cut
sub combine {
    my $self = shift();
    my $range = shift();

    if(!defined($self->lower()) or ($range->lower() < $self->lower())) {
        $log->debug('Adjusting Lower');
        $self->lower($range->lower());
    }

    if(!defined($self->upper()) or ($range->upper() > $self->upper())) {
        $log->debug('Adjusting Upper');
        $self->upper($range->upper());
    }
}

=item divvy($N)

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

Cory 'G' Watson <jheephat@gmail.com>

=head1 SEE ALSO

=cut
1;
