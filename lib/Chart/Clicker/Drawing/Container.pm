package Chart::Clicker::Drawing::Container;
use strict;
use warnings;

use base 'Chart::Clicker::Drawing::Component';

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Dimension;
use Chart::Clicker::Drawing::Insets;
use Chart::Clicker::Drawing::Point;

use Cairo;

sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);

    $self->{'AXISLEFT'} = 0;
    $self->{'AXISRIGHT'} = 0;
    $self->{'AXISBOTTOM'} = 0;
    $self->{'AXISTOP'} = 0;

    return $self;
}

sub add {
    my $self = shift();
    my $comp = shift();
    my $pos = shift() || $CC_TOP;
    my $disturb = shift();

    unless(defined($disturb)) {
        $disturb = 1;
    }

    push(@{ $self->{'COMPONENTS'} }, {
        component   => $comp,
        position    => $pos,
        disturb     => $disturb
    });

    # Make not of all the axis so we can find them when we need
    # to resize them.
    if(($pos == $CC_AXIS_LEFT) || ($pos == $CC_AXIS_RIGHT)
        || ($pos == $CC_AXIS_TOP) || ($pos == $CC_AXIS_BOTTOM)) {
        $self->{'AXES'}->{$#{ $self->{'COMPONENTS'} }} = $pos;
    }

    return 1;
}

sub components {
    my $self = shift();

    return $self->{'COMPONENTS'};
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $surface = $self->SUPER::draw($clicker, $self->inside_dimensions());
    my $context = Cairo::Context->create($surface);

    my $x = ($self->width() - $self->inside_width()) / 2;
    my $y = ($self->height() - $self->inside_height()) / 2;

    foreach my $child (@{ $self->{'COMPONENTS'} }) {
        my $comp = $child->{'component'};
        my $pos = $child->{'position'};
        my $surf = $comp->draw($clicker);
        # XXX this is wrong.
        unless(defined($comp->location())) {
            $comp->location(new Chart::Clicker::Drawing::Point({
                x => 0,
                y => 0
            }))
        }
        $context->set_source_surface(
            $surf, $comp->location()->x(), $comp->location->y()
        );
        $context->paint();
    }

    return $surface;
}

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());

    # These variables accrue values throughout the loop and are used
    # to size components.
    my ($top, $left, $right, $bottom) = (0, 0, 0, 0);

    my $count = 0;
    foreach my $child (@{ $self->{'COMPONENTS'} }) {
        my $comp = $child->{'component'};
        my $dim = new Chart::Clicker::Drawing::Dimension({
            width => $self->inside_width() - $left - $right,
            height => $self->inside_height() - $top - $bottom
        });

        my $pos = $child->{'position'};
        $comp->prepare($clicker, $dim);

        my $disturb = $child->{'disturb'};

        my $loc;
        if(($pos == $CC_TOP) || ($pos == $CC_AXIS_TOP)) {
            $loc = $self->upper_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $top += $comp->height();
            }
            if($pos == $CC_AXIS_TOP) {
                $self->{'AXISTOP'} += $comp->height();
                $self->pack_axes($count, $comp->height(), $pos);
            }
        } elsif(($pos == $CC_LEFT) || ($pos == $CC_AXIS_LEFT)) {
            $loc = $self->upper_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $left += $comp->width();
            }
            if($pos == $CC_AXIS_LEFT) {
                $self->{'AXISLEFT'} += $comp->width();
                $self->pack_axes($count, $comp->width(), $pos);
            }
        } elsif(($pos == $CC_RIGHT) || ($pos == $CC_AXIS_RIGHT)) {
            $loc = $self->upper_right_inside_point();
            $loc->x($loc->x() - $comp->width() - $right);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $right += $comp->width();
            }
            if($pos == $CC_AXIS_RIGHT) {
                $self->{'AXISRIGHT'} += $comp->width();
                $self->pack_axes($count, $comp->width(), $pos);
            }
        } elsif(($pos == $CC_BOTTOM) || ($pos == $CC_AXIS_BOTTOM)) {
            $loc = $self->lower_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() - $bottom - $comp->height());
            if($disturb) {
                $bottom += $comp->height();
            }
            if($pos == $CC_AXIS_BOTTOM) {
                $self->{'AXISBOTTOM'} += $comp->height();
                $self->pack_axes($count, $comp->height(), $pos);
            }
        } else {
            $loc = $self->upper_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $left += $comp->width();
                $top += $comp->height();
            }
        }

        $comp->location($loc);
        $count++;
    }

    return 1;
}

# Man, this thing is crazy.  See, each time an Axis is placed we need to
# resize all the other axes to accommodate it.  This code is pretty straight
# forward in this iteration but I'm certain there's some better way I can do it.
sub pack_axes {
    my $self = shift();
    my $count = shift();
    my $amt = shift();
    my $apos = shift();

    my @indices = sort(keys(%{ $self->{'AXES'} }));
    my $item = shift(@indices);
    while($item < $count) {

        my $child = $self->{'COMPONENTS'}->[$item];
        my $comp = $child->{'component'};
        my $pos = $child->{'position'};
        if(($pos == $CC_AXIS_BOTTOM) || ($pos == $CC_AXIS_TOP)) {
            if($apos == $CC_AXIS_LEFT) {
                $comp->location()->x($comp->location->x() + $amt);
            }
            if(($apos == $CC_AXIS_LEFT) || ($apos == $CC_AXIS_RIGHT)) {
                $comp->width($comp->width() - $amt);
            }
            $comp->per($comp->width() / $comp->range()->span());
        } elsif(($pos == $CC_AXIS_LEFT) || ($pos == $CC_AXIS_RIGHT)) {
            if($apos == $CC_AXIS_TOP) {
                $comp->location()->y($comp->location->y() + $amt);
            }
            if(($apos == $CC_AXIS_TOP) || ($apos == $CC_AXIS_BOTTOM)) {
                $comp->height($comp->height() - $amt);
            }
            $comp->per($comp->height() / $comp->range()->span());
        }

        $item = shift(@indices);
    }

    return 1;
}

1;
__END__
=head1 NAME

Chart::Clicker::Drawing::Container

=head1 DESCRIPTION

A Base 'container' for all components that want to hold other components.

=head1 SYNOPSIS

  my $c = new Chart::Clicker::Drawing::Container({
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

  my $c = new Chart::Clicker::Drawing::Container({
    width => 500, height => 350
    background_color => new Chart::Clicker::Drawing::Color(),
    border => new Chart::Clicker::Drawing::Border(),
    insets => new Chart::Clicker::Drawing::Insets(),
  });

Creates a new Container.  Width and height must be specified.  Border,
background_color and insets are all optional and will default to undef

=back

=head2 Class Methods

=over 4

=item background_color

Set/Get this Container's background color.

=item border

Set/Get this Container's border

=item components

Get the components in this container. The return value is an arrayref of
hashrefs.  Each hashref has a 'component' and 'position' key.

=item draw

Draw this container and all of it's children.

=item height

Set/Get this Container's height

=item insets

Set/Get this Container's insets.

=item prepare

Prepare this container for rendering.  All of it's child components will be
prepared as well.

=item add

Add a component to this container.

  $cont1->add($foo);
  $cont2->add($cont1, $CC_TOP);
  $cont2->add($cont1, $CC_TOP, 1);

The first argument must be some other entity that is renderable by
Chart::Clicker.  The second argument is an optional position.  The positioning
of elements is very rudimentary.  If you do not specify a position then
$CC_CENTER is used.  The third argument is a flag that controls whether this
component will actually affect the layout of items after it.  This is used
to make renderers render 'over' each other.  A normal use of this would be
to stack the Grid and Renderer.

=cut

=item width

Set/Get this Container's height

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
