package Chart::Clicker::Drawing::Container;
use strict;

use base 'Chart::Clicker::Drawing::Component';
__PACKAGE__->mk_accessors(
    qw(
        background_color border insets
    )
);

use Chart::Clicker::Drawing qw(:common);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Insets;

=head1 NAME

Chart::Clicker::Container

=head1 DESCRIPTION

A Base 'container' for all components that want to hold other components.

=head1 SYNOPSIS

  my $c = new Chart::Clicker::Container({
    width => 500, height => 350
    background_color => new Chart::Clicker::Drawing::Color(),
    border => new Chart::Clicker::Drawing::Border(),
    insets => new Chart::Clicker::Drawing::Insets(),
  });

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $c = new Chart::Clicker::Container({
    width => 500, height => 350
    background_color => new Chart::Clicker::Drawing::Color(),
    border => new Chart::Clicker::Drawing::Border(),
    insets => new Chart::Clicker::Drawing::Insets(),
  });

Creates a new Container.  Width and height must be specified.  Border,
background_color and insets are all optional and will default to undef

=back

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);

    unless($self->width() > 0) {
        die('Container must have a width');
    }
    unless($self->height() > 0) {
        die('Container must have a height');
    }

    return $self;
}

=head2 Class Methods

=over 4

=item add

Add a component to this container.

  $cont1->add($foo);
  $cont2->add($cont1, $CC_TOP);

The first argument must be some other entity that is renderable by
Chart::Clicker.  The second argument is an optional position.  The positioning
of elements is very rudimentary.  Only a single component is allowed at
any position ($CC_TOP and it's ilk) and...

=cut
sub add {
    my $self = shift();
    my $comp = shift();
    my $pos = shift();
}

=item background_color

Set/Get this Container's background color.

=item border

Set/Get this Container's border

=item height

Set/Get this Container's height

=item insets

Set/Get this Container's insets.

=item inside_width

Get the width available in this container after taking away space for
insets and borders.

=cut
sub inside_width {
    my $self = shift();

    my $w = $self->width();

    if(defined($self->insets())) {
        $w -= $self->insets()->left() + $self->insets()->right()
    }
    if(defined($self->border())) {
        $w -= $self->border()->stroke()->width() * 2;
    }

    return $w;
}

=item $c->inside_height()

Get the height available in this container after taking away space for
insets and borders.

=cut
sub inside_height {
    my $self = shift();

    my $h = $self->height();
    if(defined($self->insets())) {
        $h -= $self->insets()->bottom() + $self->insets()->top();
    }
    if(defined($self->border())) {
        $h -= $self->border()->stroke()->width() * 2;
    }

    return $h;
}

=item width

Set/Get this Container's height

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
