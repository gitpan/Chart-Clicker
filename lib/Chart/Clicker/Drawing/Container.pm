package Chart::Clicker::Drawing::Container;
use strict;

use base 'Chart::Clicker::Drawing::Component';

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Dimension;
use Chart::Clicker::Drawing::Insets;
use Chart::Clicker::Drawing::Point;
use Chart::Clicker::Log;

use Cairo;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Drawing::Container');

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

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);


    return $self;
}

=head2 Class Methods

=over 4

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
    if(($pos == $CC_AXIS_LEFT) or ($pos == $CC_AXIS_RIGHT)
        or ($pos == $CC_AXIS_TOP) or ($pos == $CC_AXIS_BOTTOM)) {
        $self->{'AXES'}->{$#{ $self->{'COMPONENTS'} }} = $pos;
    }
}

=item background_color

Set/Get this Container's background color.

=item border

Set/Get this Container's border

=item components

Get the components in this container. The return value is an arrayref of
hashrefs.  Each hashref has a 'component' and 'position' key.

=cut
sub components {
    my $self = shift();

    return $self->{'COMPONENTS'};
}

=item draw

Draw this container and all of it's children.

=cut
sub draw {
    my $self = shift();
    my $clicker = shift();

    my $surface = $self->SUPER::draw($clicker, $self->inside_dimension());
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

=item height

Set/Get this Container's height

=item insets

Set/Get this Container's insets.

=item prepare

Prepare this container for rendering.  All of it's child components will be
prepared as well.

=cut
sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());

    # These variables accrue values throughout the loop and are used
    # to size components.
    my ($top, $left, $right, $bottom) = (0, 0, 0, 0);

    $log->debug('Size is '.$self->width().'x'.$self->height());

    my $count = 0;
    foreach my $child (@{ $self->{'COMPONENTS'} }) {
        my $comp = $child->{'component'};
        $log->debug("Preparing ".ref($comp));
        my $dim = new Chart::Clicker::Drawing::Dimension({
            width => $self->inside_width() - $left - $right,
            height => $self->inside_height() - $top - $bottom
        });

        my $pos = $child->{'position'};
        $comp->prepare($clicker, $dim);

        my $disturb = $child->{'disturb'};

        my $loc;
        if(($pos == $CC_TOP) or ($pos == $CC_AXIS_TOP)) {
            $loc = $self->upper_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $top += $comp->height();
            }
            if($pos == $CC_AXIS_TOP) {
                $self->{'AXISTOP'} += $comp->height();
                $self->pack_axes($count);
            }
        } elsif(($pos == $CC_LEFT) or ($pos == $CC_AXIS_LEFT)) {
            $loc = $self->upper_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $left += $comp->width();
            }
            if($pos == $CC_AXIS_LEFT) {
                $self->{'AXISLEFT'} += $comp->width();
                $self->pack_axes($count);
            }
        } elsif(($pos == $CC_RIGHT) or ($pos == $CC_AXIS_RIGHT)) {
            $loc = $self->upper_right_inside_point();
            $loc->x($loc->x() - $comp->width() - $right);
            $loc->y($loc->y() + $top);
            if($disturb) {
                $right += $comp->width();
            }
            if($pos == $CC_AXIS_RIGHT) {
                $self->{'AXISRIGHT'} += $comp->width();
                $self->pack_axes($count);
            }
        } elsif(($pos == $CC_BOTTOM) or ($pos == $CC_AXIS_BOTTOM)) {
            $loc = $self->lower_left_inside_point();
            $loc->x($loc->x() + $left);
            $loc->y($loc->y() - $bottom - $comp->height());
            if($disturb) {
                $bottom += $comp->height();
            }
            if($pos == $CC_AXIS_BOTTOM) {
                $self->{'AXISBOTTOM'} += $comp->height();
                $self->pack_axes($count);
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
        $log->debug("Offered ".$dim->width()."x".$dim->height());
        $log->debug("Took ".$comp->width()."x".$comp->height());
        $log->debug("Component Location is ".$loc->x().",".$loc->y());
        $count++;
    }
}

sub pack_axes {
    my $self = shift();
    my $count = shift();
    return;

    my @indices = sort(keys(%{ $self->{'AXES'} }));
    my $item = shift(@indices);
    while($item < $count) {
        $log->debug("Need to resize axis @ $item");

        my $child = $self->{'COMPONENTS'}->[$item];
        my $comp = $child->{'component'};
        my $pos = $child->{'position'};
        if($pos == $CC_AXIS_BOTTOM) {
            $comp->location()->x($comp->location->x() + $self->{'AXISLEFT'});
            $comp->width(
                $comp->width() - $self->{'AXISLEFT'} - $self->{'AXISRIGHT'}
            );
            $comp->per($comp->width() / $comp->range()->span());
        } elsif($pos == $CC_AXIS_LEFT) {
            $comp->location()->y($comp->location->y() + $self->{'AXISTOP'});
            $comp->height(
                $comp->height() - $self->{'AXISTOP'} - $self->{'AXISBOTTOM'}
            );
            $comp->per($comp->height() / $comp->range()->span());
        } elsif($pos == $CC_AXIS_RIGHT) {
            $comp->location()->y($comp->location->y() + $self->{'AXISTOP'});
            $comp->height(
                $comp->height() - $self->{'AXISTOP'} - $self->{'AXISBOTTOM'}
            );
            $comp->per($comp->height() / $comp->range()->span());
        }

        $item = shift(@indices);
    }
    $log->debug('Leaving pack_axes');
}

=item upper_left_inside_point

Get the Point for this container's upper left inside.

=cut
sub upper_left_inside_point {
    my $self = shift();

    my $point = new Chart::Clicker::Drawing::Point({ x => 0, y => 0 });

    if(defined($self->insets())) {
        $point->x($self->insets()->left());
        $point->y($self->insets()->top());
    }
    if(defined($self->border())) {
        $point->x($point->x() + $self->border()->stroke()->width());
        $point->y($point->y() + $self->border()->stroke()->width());
    }

    return $point;
}

=item upper_right_inside_point

Get the Point for this container's upper right inside.

=cut
sub upper_right_inside_point {
    my $self = shift();

    my $point = $self->upper_left_inside_point();
    $point->x($point->x() + $self->inside_width());

    return $point;
}

sub lower_left_inside_point {
    my $self = shift();

    my $point = $self->upper_left_inside_point();
    $point->y($point->y() + $self->inside_height());

    return $point;
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
