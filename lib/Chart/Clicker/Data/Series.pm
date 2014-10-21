package Chart::Clicker::Data::Series;
{
  $Chart::Clicker::Data::Series::VERSION = '2.83';
}
use Moose;

# ABSTRACT: A series of key, value pairs representing chart data

use List::Util qw(max min);
use Chart::Clicker::Data::Range;


has 'keys' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub { [] },
    handles => {
        'add_to_keys' => 'push',
        'key_count' => 'count'
    }
);


has 'name' => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_name'
);


has 'range' => (
    is => 'rw',
    isa => 'Chart::Clicker::Data::Range',
    lazy_build => 1
);


has 'values' => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub { [] },
    handles => {
        'add_to_values' => 'push',
        'value_count' => 'count'
    }
);

sub _build_range {
    my ($self) = @_;

    my $values = $self->values;

    confess('A series must have values before it can be charted')
        unless scalar(@{ $values });

    return Chart::Clicker::Data::Range->new(
        lower => min(@{ $values }), upper => max(@{ $values})
    );
}

sub BUILDARGS {
    my ($class, @args) = @_;

    if(@args == 1 && (ref($args[0]) eq 'HASH') && !exists($args[0]->{keys})) {
        my @keys = sort { $a <=> $b } keys %{ $args[0] };
        my @values = ();
        foreach my $k (@keys) {
            push(@values, $args[0]->{$k})
        }
        return { keys => \@keys, values => \@values }
    } elsif(@args % 2 == 0) {
        return { @args };
    }

    return $args[0];
}


sub add_pair {
    my ($self, $key, $value) = @_;

    $self->add_to_keys($key);
    $self->add_to_values($value);
}


sub get_value_for_key {
    my ($self, $key) = @_;

    for(0..$self->key_count) {
        my $ikey = $self->keys->[$_];
        return $self->values->[$_] if defined($ikey) && $ikey == $key;
    }

    # We found nothing, return undef
    return undef;
}

sub prepare {
    my ($self) = @_;

    if($self->key_count != $self->value_count) {
        die('Series key/value counts dont match: '.$self->key_count.' != '.$self->value_count.'.');
    }

    return 1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__
=pod

=head1 NAME

Chart::Clicker::Data::Series - A series of key, value pairs representing chart data

=head1 VERSION

version 2.83

=head1 SYNOPSIS

  use Chart::Clicker::Data::Series;

  my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  my @values = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);

  my $series = Chart::Clicker::Data::Series->new({
    keys    => \@keys,
    value   => \@values
  });

  # Alternately, if you prefer

  my $series2 = Chart::Clicker::Data::Series->new({
    1  => 42,
    2  => 25,
    3  => 85,
    4  => 23,
    5  => 2,
    6  => 19,
    7  => 102,
    8  => 12,
    9  => 54,
    10 => 9
  });

=head1 DESCRIPTION

Chart::Clicker::Data::Series represents a series of values to be charted.

Despite the name (keys and values) it is expected that all keys and values
will be numeric.  Values is pretty obvious, but it is important that keys
also be numeric, as otherwise we'd have no idea how to order the data.

If you want to use text labels for your domain's see L<Chart::Clicker::Axis>'s
L<tick_labels> method.

=head1 ATTRIBUTES

=head2 keys

Set/Get the keys for this series.

=head2 add_to_keys

Adds a key to this series.

=head2 name

Set/Get the name for this Series

=head2 range

Returns the L<range|Chart::Clicker::Data::Range> for this series.

=head2 values

Set/Get the values for this series.

=head1 METHODS

=head2 key_count

Get the count of keys in this series.

=head2 add_to_values

Add a value to this series.

=head2 value_count

Get the count of values in this series.

=head2 add_pair ($key, $value)

Convenience method to add a single key and a single value to the series.

=head2 get_value_for_key ($key)

Returns the value associated with the specified key.  This is necessary
because not all series will have values for every key.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Cold Hard Code, LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

