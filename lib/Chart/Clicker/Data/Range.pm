package Chart::Clicker::Data::Range;
use strict;
use warnings;


use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(lower upper min max));

sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    if(defined($self->min())) {
        $self->lower($self->min());
    }

    if(defined($self->max())) {
        $self->upper($self->max());
    }

    return $self;
}

sub lower {
    my $self = shift();

    if(@_) {
        unless(defined($self->min())) {
            $self->_lower_accessor(@_);
        }
    }
    return $self->_lower_accessor();
}

sub min {
    my $self = shift();

    if(@_) {
        $self->_min_accessor(@_);
        $self->_lower_accessor($self->_min_accessor());
    }
    return $self->_min_accessor();
}

sub upper {
    my $self = shift();

    if(@_) {
        unless(defined($self->max())) {
            $self->_upper_accessor(@_);
        }
    }
    return $self->_upper_accessor();
}

sub max {
    my $self = shift();

    if(@_) {
        $self->_max_accessor(@_);
        $self->_upper_accessor($self->_max_accessor());
    }
    return $self->_max_accessor();
}

sub span {
    my $self = shift();

    return ($self->upper() - $self->lower()) || 1;
}

sub combine {
    my $self = shift();
    my $range = shift();

    unless($self->min()) {
        if(!defined($self->lower()) || ($range->lower() < $self->lower())) {
            $self->lower($range->lower());
        }
    }

    unless($self->max()) {
        if(!defined($self->upper()) || ($range->upper() > $self->upper())) {
            $self->upper($range->upper());
        }
    }

    return 1;
}

sub divvy {
    my $self = shift();
    my $n = shift();

    my $per = $self->span() / $n;

    my @vals;
    for(1..($n - 1)) {
        push(@vals, $self->lower() + ($_ * $per));
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

=item

Set/Get the minimum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the lower value.

=item upper

Set/Get the upper bound for this Range

=item max

Set/Get the maximum value allowed for this Range.  This value should only be
set if you want to EXPLICITLY set the upper value.

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
