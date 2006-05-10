package Chart::Clicker::Drawing::Color;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw(red green blue alpha name));

my %colors = (
    'aqua'      => [   0,   1,   1,  1 ],
    'black'     => [   0,   0,   0,  1 ],
    'blue'      => [   0,   0,   1,  1 ],
    'fuchsia'   => [   1,   0,   0,  1 ],
    'gray'      => [ .31, .31, .31,  1 ],
    'green'     => [   0, .31,   0,  1 ],
    'lime'      => [   0,   1,   0,  1 ],
    'maroon'    => [ .31,   0,   0,  1 ],
    'navy'      => [   0,   0, .31,  1 ],
    'olive'     => [ .31, .31,   0,  1 ],
    'purple'    => [ .31,   0, .31,  1 ],
    'red'       => [   1,   0,   0,  1 ],
    'silver'    => [ .75, .75, .75,  1 ],
    'teal'      => [   0, .31, .31,  1 ],
    'white'     => [   1,   1,   1,  1 ],
    'yellow'    => [   1,   1,   0,  1 ]
);

=head1 NAME

Chart::Clicker::Drawing::Color

=head1 DESCRIPTION

Chart::Clicker::Drawing::Color represents a Color in the sRGB color space.  Used to
make charts pertier.

The 16 colors defined by the W3C CSS specification are supported via
the 'name' parameter of the constructor.  The colors are aqua, black, blue,
fuchsia, gray, green, lime, maroon, navy, olive, purple, red, silver, teal,
white and yellow.  Any case is fine, navy, NAVY or Navy.

=head1 SYNOPSIS

    use Chart::Clicker::Drawing::Color;

    my $color = new Chart::Clicker::Drawing::Color({
        red     => 1,
        blue    => .31,
        green   => .25,
        alpha   => 1
    });

    my $aqua = new Chart::Clicker::Drawing::Color({ name => 'aqua' });

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Drawing::Color->new({
    red     => $RED,
    green   => $GREEN,
    blue    => $BLUE,
    alpha   => $ALPHA
)

Creates a new Chart::Clicker::Drawing::Color.

=back

=head2 Class Methods

=over 4

=item new( )

=cut
sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->red())) {
        if($self->name()) {
            if(exists($colors{lc($self->name())})) {
                $self->red($colors{lc($self->name())}->[0]);
                $self->green($colors{lc($self->name())}->[1]);
                $self->blue($colors{lc($self->name())}->[2]);
                $self->alpha($colors{lc($self->name())}->[3]);
            }
        }
    }

    return $self;
}

=item $red = $c->red($red)

Set/Get the red component of this Color.

=item $green = $c->green($green)

Set/Get the green component of this Color.

=item $blue = $c->blue($blue)

Set/Get the blue component of this Color.

=item $alpha = $c->alpha($alpha)

Set/Get the alpha component of this Color.

=item $name = $c->name()

Get the name of this color.  Only valid if the color was created by name.

=item @names = $c->names()

Gets the list of predefined color names.

=cut
sub names {
    my $self = shift();

    return keys(%colors);
}

=item as_string()

Get a string version of this Color in the form of RED, GREEN, BLUE, ALPHA

=cut
sub as_string {
    my $self = shift();

    return join(',',
        sprintf('%0.2f', $self->red()),
        sprintf('%0.2f', $self->green()),
        sprintf('%0.2f', $self->blue()),
        sprintf('%0.2f', $self->alpha())
    );
}

=item $newcolor = $color->clone()

Clone this color

=cut
sub clone {
    my $self = shift();

    return new Chart::Clicker::Drawing::Color({
        red => $self->red(), green => $self->green(),
        blue => $self->blue(), alpha => $self->alpha()
    });
}

=item @colors = rgb()

Get the RGB parts as an array

=cut
sub rgb {
    my $self = shift();

    return ($self->red(), $self->green(), $self->blue());
}

=item @colors = rgba()

Get the RGBA parts as an array

=cut
sub rgba {
    my $self = shift();

    return ($self->red(), $self->green(), $self->blue(), $self->alpha());
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
