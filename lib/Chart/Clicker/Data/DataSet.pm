package Chart::Clicker::Data::DataSet;
use strict;
use warnings;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(count domain max_key_count range));

use Chart::Clicker::Data::Range;

sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    if($self->{'series'}) {
        $self->{'SERIES'} = $self->{'series'};
        $self->count(scalar(@{ $self->{'SERIES'} }));
    } else {
        $self->{'SERIES'} = ();
    }

    return $self;
}

sub series {
    my $self = shift();

    if(@_) {
        $self->{'SERIES'} = shift();
        $self->count(scalar(@{ $self->{'SERIES'} }));
    }
    return $self->{'SERIES'};
}

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

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Data::DataSet

=head1 DESCRIPTION

Chart::Clicker::Data::DataSet is the core class 

=head1 SYNOPSIS

  use Chart::Clicker::Data::DataSet;
  use Chart::Clicker::Data::Series;

  my @vals = (12, 19, 90, 4, 44, 3, 78, 87, 19, 5);
  my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  my $series = new Chart::Clicker::Data::Series({
    keys    => \@keys,
    values  => \@values
  });

  my $ds = new Chart::Clicker::Data::DataSet({
    series => [ $series ]
  });

=head1 METHODS

=head2 Constructors

=over 4

=item new

Creates a new, empty DataSet

=back

=head2 Class Methods

=over 4

=item count

Get the number of series in this dataset.

=item domain

Get the Range for the domain values

=item max_key_count

Get the number of keys in the longest series.

=item range

Get the Range for the... range values...

=item series

Set/Get the series for this DataSet

=item prepare

Prepare this DataSet.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
