package Chart::Clicker::Drawing::ColorAllocator;
use strict;

use Chart::Clicker::Drawing::Color;

use Chart::Clicker::Log;

my @defaults = (qw(red green blue lime yellow maroon teal fuchsia));;

my $log = Chart::Clicker::Log->get_logger(
    'Chart::Clicker::Drawing::ColorAllocator'
);

=head1 NAME

Chart::Clicker::Drawing::ColorAllocator

=head1 DESCRIPTION

Allocates colors for use in the chart.  The position in the color allocator
corresponds to the series that will be colored.

=head1 SYNOPSIS

    use Chart::Clicker::Drawing::ColorAllocator;

    my $ca = new Chart::Clicker::Drawing::ColorAllocator({
        colors => (
            new Chart::Clicker::Drawing::Color(1.0, 0, 0, 1.0),
            ...
        )
    });

    my $red = $ca->get(0);

=head1 METHODS

=head2 Constructor

=over 4

=item new

Create a new ColorAllocator.  You can optionally pass an arrayref of colors
to 'seed' the allocator.

=cut
sub new {
    my $proto = shift();
    my $class = ref($proto) || $proto;

    my $self = {};
    bless($self, $class);

    $self->{'POSITION'} = -1;

    if(defined($self->{'colors'}) and ref($self->{'colors'}) eq 'ARRAY') {
        foreach my $color (@{ $self->{'colors'} }) {
            push(@{ $self->{'COLORS'} }, $color);
        }
    }

    return $self;
}

=back

=head2 Class Methods

=over 4

=item position

Gets the current position.

=cut
sub position {
    my $self = shift();

    return $self->{'POSITION'};
}

=item next

Returns the next color.  Each call to next increments the position, so
subsequent calls will return different colors.

=cut
sub next {
    my $self = shift();

    if(defined($self->{'COLORS'}->[$self->position() + 1])) {
        $self->{'POSITION'}++;
        $log->debug('Color already allocated: '.$self->position());
        return $self->{'COLORS'}->[$self->position()];
    }

    $self->{'POSITION'}++;
    if($self->position() <= scalar(@defaults)) {
        $log->debug('Allocating color '.$defaults[$self->position()]
            .': '.$self->position());
        $self->{'COLORS'}->[$self->position()] =
            new Chart::Clicker::Drawing::Color({
                name => $defaults[$self->position()]
            });
        return $self->{'COLORS'}->[$self->position()];
    }

    $log->debug('Color randomly selected: '.$self->position());
    $self->{'COLORS'}->[$self->position()] = new Chart::Clicker::Drawing::Color({
        red     => rand(1),
        green   => rand(1),
        blue    => rand(1),
        alpha   => 1
    });
    return $self->{'COLORS'}->[$self->position()];
}

=item reset

Resets this allocator back to the beginning.

=cut
sub reset {
    my $self = shift();

    $log->debug('Resetting position.');

    $self->{'POSITION'} = -1;
}

=item get

Gets the color at the specified index.  Returns undef if that position has no
color.

=cut
sub get {
    my $self = shift();
    my $index = shift();

    return $self->{'COLORS'}->[$index];
}

=back

=cut

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
