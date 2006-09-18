package Chart::Clicker::Axis::DateTime;
use strict;
use warnings;

use Chart::Clicker::Data::Marker;
use Chart::Clicker::Drawing::Color;

use DateTime;
use DateTime::Set;

use base 'Chart::Clicker::Axis';

__PACKAGE__->mk_accessors(qw(formatter));

sub prepare {
    my $self = shift();

    my $dstart = DateTime->from_epoch(epoch => $self->range->lower());
    my $dend = DateTime->from_epoch(epoch => $self->range->upper());
    my $dur = $dend - $dstart;

    if($dur->years()) {
        $self->format('%b %Y');
    } elsif($dur->months()) {
        $self->format('i%d %b');
    } elsif($dur->weeks()) {
        $self->format('%d %b');
    } elsif($dur->days()) {
        $self->format('%m/%d %H:%M');
    } else {
        $self->format('%H:%M');
    }

    $self->SUPER::prepare(@_);

    my $clicker = shift();

    my @markers = @{ $clicker->markers() };

    my $set = DateTime::Span->from_datetimes(
        start => $dstart, end => $dend
    );

    my $linecolor = new Chart::Clicker::Drawing::Color({
        red => 0, green => 0, blue => 0, alpha => .35
    });
    my $fillcolor = new Chart::Clicker::Drawing::Color({
        red => 0, green => 0, blue => 0, alpha => .10
    });

    my @dmarkers;
    my $day = $set->start()->truncate(to => 'day');

    my $dayval;
    while($day < $set->end()) {
        if($set->contains($day)) {
            if(defined($dayval)) {
                push(@dmarkers,
                    new Chart::Clicker::Data::Marker({
                        key         => $dayval,
                        key2        => $day->epoch(),
                        color       => $linecolor,
                        inside_color=> $fillcolor,
                    })
                );
                $dayval = undef;
            } else {
                $dayval = $day->epoch();
            }
        }
        $day = $day->add(days => 1);
    }
    if($dayval) {
        push(@dmarkers,
            new Chart::Clicker::Data::Marker({
                key         => $dayval,
                key2        => $day->epoch(),
                color       => $linecolor,
                inside_color=> $fillcolor,
            })
        );
    }

    push(@dmarkers, @markers);
    $clicker->markers(\@dmarkers);

    return 1;
}

sub format_value {
    my $self = shift();
    my $value = shift();

    if($self->format()) {
        my $dt = DateTime->from_epoch(epoch => int($value));

        return $dt->strftime($self->format());
    }

    return $value;
}

1;
__END__

=head1 NAME

Chart::Clicker::Axis::DateTime

=head1 DESCRIPTION

A temporal Axis.  Requires DateTime and DateTime::Set.

=head1 SYNOPSIS

  my $axis = new Chart::Clicker::Axis::DateTime();

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Axis::DateTime->new()

Creates a new DateTime Axis.

=back

=head2 Class Methods

=over 4

=item formatter

Set/Get the formatting string used to format the DateTime.  See DateTime's
strftime.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
