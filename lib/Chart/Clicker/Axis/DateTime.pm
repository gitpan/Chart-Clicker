package Chart::Clicker::Axis::DateTime;
use strict;
use warnings;

use DateTime;
use DateTime::Format::Strptime;

use base 'Chart::Clicker::Axis';

__PACKAGE__->mk_accessors(qw(formatter));

sub format_value {
    my $self = shift();
    my $value = shift();

    if($self->format()) {
        my $dt = DateTime->from_epoch(epoch => int($value));

        return $dt->strftime($self->format());
    }
}

1;
