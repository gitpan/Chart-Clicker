package Chart::Clicker::Data::Series;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(key_count keys max_key_length name range value_count values)
);

use Chart::Clicker::Data::Range;

=head1 NAME

Chart::Clicker::Data::Series

=head1 DESCRIPTION

Chart::Clicker::Data::Series is the core class 

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 Constructors

=over 4

=item new()

Creates a new, empty Series

=cut
sub new {
    my $proto = shift();
    my $class = ref($proto) || $proto;
    my $self = {};

    $self->{'OPTIONS'} = {};

    bless($self, $class);
    return $self;
}

=item $name = $series->name($name)

Set/Get the name for this Series

=item $keys = $series->keys(\@keys)

Set/Get the keys for this series.

=item $values = $series->values(\@values)

Set/Get the values for this series.

=item $series->prepare()

Prepare this series.  Performs various checks and calculates
various things.

=cut
sub prepare {
    my $self = shift();

    my @values = @{ $self->values() };
    my @keys = @{ $self->keys() };

    $self->key_count(scalar(@keys));
    $self->value_count(scalar(@values));

    if($self->key_count() != $self->value_count()) {
        die("Series key/value counts don't match.");
    }

    my ($long, $max, $min);
    $long = 0;
    $max = $values[0];
    $min = $values[0];
    my $count = 0;
    foreach my $key (@keys) {

        my $val = $values[$count];

        # Length!
        my $l = length($key);
        if($l > $long) {
            $long = $l;
        }

        # Max
        if($val > $max) {
            $max = $val;
        }

        # Min
        if($val < $min) {
            $min = $val;
        }
        $count++;
    }
    $self->max_key_length($long);
    $self->range(new Chart::Clicker::Data::Range({ lower => $min, upper => $max }));
}

=item $range = $self->range();

Returns the range for this series.

=item $length = $self->max_key_length()

Returns the length of the longest key in this series.

=item $count = $self->key_count()

Return a count of the number of keys in this series.  Only available
after the series has been prepared.

=item $count = $self->value_count()

Return a count of the number of values in this series.  Only available
after the series has been prepared.

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@gmail.com>

=head1 SEE ALSO

=cut
1;
