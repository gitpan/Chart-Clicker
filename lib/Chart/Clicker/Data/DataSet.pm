package Chart::Clicker::Data::DataSet;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(count domain max_key_count range));

use Chart::Clicker::Data::Range;

=head1 NAME

Chart::Clicker::Data::DataSet

=head1 DESCRIPTION

Chart::Clicker::Data::DataSet is the core class 

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 Constructors

=over 4

=item new()

Creates a new, empty DataSet

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    $self->{'SERIES'} = ();

    return $self;
}

=item $count = $ds->count()

Get the number of series in this dataset.

=item $series = $ds->series(\@series)

Set/Get the series for this DataSet

=cut
sub series {
    my $self = shift();

    if(@_) {
        $self->{'SERIES'} = shift();
        $self->count(scalar(@{ $self->{'SERIES'} }));
    }
    return $self->{'SERIES'};
}

=item $ds->prepare()

Prepare this DataSet.

=cut
sub prepare {
    my $self = shift();

    unless($self->count() and $self->count() > 0) {
        die('Dataset has no series.');
    }

    my $stotal;
    foreach my $series (@{ $self->series() }) {
        $series->prepare();

        # If RANGE is defined, combine it.
        if(defined($self->range())) {
            $self->range()->combine($series->range());

            my @keys = @{ $series->keys() };

            $self->domain()->combine(
                new Chart::Clicker::Data::Range({
                    lower => $keys[0], upper => $keys[ $#keys ]
                })
            );

            if($series->key_count() > $self->max_key_count()) {
                $self->max_key_count($series->key_count());
            }
        } else {
            # ...or if it's not defined then set it to the values of
            # this first series.
            $self->range($series->range());
            $self->domain(
                new Chart::Clicker::Data::Range({
                    lower => $series->keys()->[0],
                    upper => $series->keys()->[ $#{ $series->keys() } ]
                })
            );
            $self->max_key_count($series->key_count());
        }
    }
}

=item $rr = $ds->range()

Get the Range for the... range values...

=item $dr = $ds->domain()

Get the Range for the domain values

=item $kc = $ds->max_key_count()

Get the number of keys in the longest series.

=back

=head1 AUTHOR

Cory 'G' Watson <jheephat@gmail.com>

=head1 SEE ALSO

=cut
1;
