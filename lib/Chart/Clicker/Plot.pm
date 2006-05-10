package Chart::Clicker::Plot;
use strict;

use Chart::Clicker::Renderer::Marker;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(
        background_color border datasets domain_axes
        domain_markers draw_markers grid height image range_axes range_markers
        renderer width
    )
);

=head1 NAME

Chart::Clicker::Plot

=head1 DESCRIPTION

Chart::Clicker::Plot represents the plot of the chart.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Axis;
use Chart::Clicker::Decoration::Grid;
use Chart::Clicker::Decoration::Marker;
use Chart::Clicker::Drawing qw(:common);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::ColorAllocator;
use Chart::Clicker::Drawing::Insets;
use Chart::Clicker::Drawing::Point;
use Chart::Clicker::Renderer::Area;
use Chart::Clicker::Renderer::Bar;
use Chart::Clicker::Renderer::Line;
use Chart::Clicker::Renderer::Point;

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Plot');

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Plot->new($width, $height)

Creates a new Chart::Clicker::Plot.

=back

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);

    $self->background_color(
        new Chart::Clicker::Drawing::Color({
            red => .9, green => .9, blue => .9, alpha => 1
        })
    );
    unless($self->border()) {
        $self->border(new Chart::Clicker::Drawing::Border());
    }
    unless(defined($self->draw_markers())) {
        $self->draw_markers(1);
    }
    $self->range_axes([
        new Chart::Clicker::Axis({
            orientation => $CC_VERTICAL
        })
    ]);
    $self->domain_axes([
        new Chart::Clicker::Axis({
            orientation => $CC_HORIZONTAL
        })
    ]);
    $self->range_markers([ ]);
    $self->domain_markers([ ]);
    $self->grid(new Chart::Clicker::Decoration::Grid());

    return $self;
}

=head2 Class Methods

=over 4

=item $width = $p->width($width)

Set/Get the width of the plot.

=item $height = $p->height($height)

Set/Get the height of the plot.

=item $flag = $p->draw_markers($flag)

Set/Get the flag that determines if markers are drawn.

=item $border = $p->border($BORDER)

Set/Get the Border of the Plot.

=item $bgcolor = $p->background_color($bgcolor)

Set/Get the background color for this Plot

=item $datasets = $p->datasets(\@datasets);

Set/Get the DataSets for this Chart.

=item $c->add_range_marker($marker)

Add a marker to the range axis of this plot.

=cut
sub add_range_marker {
    my $self = shift();

    push(@{ $self->range_markers() }, shift());
}

=item $markers = $c->range_markers(\@markers)

Set/Get this plot's range markers.

=item $c->add_domain_marker($marker)

Add a marker to the domain axis of this plot.

=cut
sub add_domain_marker {
    my $self = shift();

    push(@{ $self->domain_markers() }, shift());
}

=item $markers = $c->domain_markers(\@markers)

Set/Get this plot's domain markers.

=item $raxes = $p->range_axes()

Get this plot's range axes.

=item $daxes = $p->domain_axes();

Get this plot's domain axes.

=item set_range_axis($dataset_index, $axis_index)

Set a DataSet's affinity to a certain range axis.

=cut
sub set_range_axis {
    my $self = shift();
    my $dsidx = shift();
    my $axisidx = shift();

    $self->{'DSRANGEAXIS'}->{$dsidx} = $axisidx;
}

=item set_domain_axis($dataset_index, $axis_index)

Set a DataSet's affinity to a certain domain axis.

=cut
sub set_domain_axis {
    my $self = shift();
    my $dsidx = shift();
    my $axisidx = shift();

    $self->{'DSDOMAINAXIS'}->{$dsidx} = $axisidx;
}

=item $ax = $p->get_domain_axis($ds_index)

Get the domain axis for the dataset at the specified index.

=cut
sub get_domain_axis {
    my $self = shift();
    my $idx = shift();

    if(exists($self->{'DSDOMAINAXIS'}->{$idx})) {
        return $self->domain_axes()->[ $self->{'DSDOMAINAXIS'}->{$idx} ];
     } else {
        return $self->domain_axes()->[0];
    }
}

=item $ax = $p->get_range_axis($ds_index)

Get the range axis for the dataset at the specified index.

=cut
sub get_range_axis {
    my $self = shift();
    my $idx = shift();

    if(exists($self->{'DSRANGEAXIS'}->{$idx})) {
        return $self->range_axes()->[ $self->{'DSRANGEAXIS'}->{$idx} ];
     } else {
        return $self->range_axes()->[0];
    }
}

=item $grid = $p->grid($grid)

Set/Get this plot's Grid.

=item $rdr = $p->renderer($rdr)

Set/Get this plot's Renderer.

=item $c->prepare()

Prepare the chart for drawing.

=cut
sub prepare {
    my $self = shift();

    unless(defined($self->renderer())) {
        die('No renderer set.');
    }

    $self->{'SURFACE'}
        = Cairo::ImageSurface->create('argb32', $self->width, $self->height);
    $self->{'CAIRO'} = Cairo::Context->create($self->{'SURFACE'});

    # Setup the domain axis mapping, even if there
    # isn't one.
    unless(defined($self->{'DSDOMAINAXIS'})) {
        $self->{'DSDOMAINAXIS'} = {};
    }

    # Setup the range axis mapping, even if there
    # isn't one.
    unless(defined($self->{'DSRANGEAXIS'})) {
        $self->{'DSRANGEAXIS'} = {};
    }

    unless(ref($self->datasets())) {
        die('Need an arrayref for a dataset.');
    }

    my $count = 0;
    foreach my $ds (@{ $self->datasets() }) {

        unless($ds->count() > 0) {
            die('A dataset is empty.');
        }
        $ds->prepare();

        my $daxis = $self->get_domain_axis($count);
        $daxis->range()->combine($ds->domain());

        my $raxis = $self->get_range_axis($count);
        $raxis->range()->combine($ds->range());

        $count++;
    }

    foreach my $axis (@{ $self->range_axes() }) {
        $axis->tick_values($axis->range()->divvy(5));
        $axis->prepare($self->{'CAIRO'});
    }
    foreach my $axis (@{ $self->domain_axes() }) {
        $axis->tick_values($axis->range()->divvy(5));
        $axis->prepare($self->{'CAIRO'});
    }
}

=item draw()

=cut
sub draw {
    my $self = shift();
    my $color_allocator = shift();

    my $width = $self->width();
    my $height = $self->height();

    my $surface = $self->{'SURFACE'};
    my $cr = $self->{'CAIRO'};

    # Insets used to keep track of remaining size.
    my $insets = new Chart::Clicker::Drawing::Insets();

    # Calculate how much vertical space we will lose due to the axes and
    # set their position.
    my $i = 0;
    foreach my $daxis (@{ $self->domain_axes() }) {
        if(defined($daxis->position())) {
            if($daxis->position() == $CC_TOP) {
                $insets->top($insets->top() + $daxis->height());
            } else {
                $insets->bottom($insets->bottom() + $daxis->height());
            }
        } else {
            if($i % 2) {
                $insets->top($insets->top() + $daxis->height());
                $daxis->position($CC_TOP);
            } else {
                $insets->bottom($insets->bottom() + $daxis->height());
                $daxis->position($CC_BOTTOM);
            }
            $i++;
        }
    }

    $i = 0;
    foreach my $raxis (@{ $self->range_axes() }) {
        if(defined($raxis->position())) {
            if($raxis->position() == $CC_LEFT) {
                $insets->left($insets->left() + $raxis->width());
            } else {
                $insets->right($insets->right() + $raxis->width());
            }
        } else {
            unless($i % 2) {
                $insets->left($insets->left() + $raxis->width());
                $raxis->position($CC_LEFT);
            } else {
                $insets->right($insets->right() + $raxis->width());
                $raxis->position($CC_RIGHT);
            }
            $i++;
        }
    }

    # Border
    $cr->set_source_rgba($self->border()->color()->rgba());
    $cr->set_line_width($self->border()->stroke()->width());
    $cr->set_line_cap($self->border()->stroke()->line_cap());
    $cr->set_line_join($self->border()->stroke()->line_join());

    my $sw = $self->border()->stroke()->width();
    my $swhalf = $sw / 2;

    # We need the Upper Left and Lower Left drawable points for use later,
    # so we'll save them here.
    my $uldp = new Chart::Clicker::Drawing::Point({
        x => $swhalf + $insets->left(),
        y => $swhalf + $insets->top()
    });
    my $lldp = new Chart::Clicker::Drawing::Point({
        x => $swhalf + $insets->left(),
        y => $height - $swhalf - $insets->bottom()
    });

    # Inner surface.
    my $iwidth = $width - $sw * 2
        - $insets->left() - $insets->right();
    my $iheight = $height - $sw * 2
        - $insets->top() - $insets->bottom();
    my $urdp = new Chart::Clicker::Drawing::Point({
        x => $uldp->x() + $iwidth + $sw,
        y => $uldp->y()
    });

    $cr->new_path();
    $cr->rectangle($uldp->x(), $uldp->y(), $iwidth + $sw, $iheight + $sw);
    $cr->stroke();

    # Find the point where we will be placing the inner surface.
    my $innerpoint = new Chart::Clicker::Drawing::Point({
        x => $sw + $insets->left(),
        y => $sw + $insets->top()
    });

    # Set the missing values on each axis. So we can compute the 'per' value
    # Note the adding of $sw to the width, this is because axes overlap
    # the border!
    my ($tybump, $bybump);
    foreach my $daxis (@{ $self->domain_axes() }) {
        $daxis->width($iwidth + $sw);
        $daxis->per(($iwidth + $sw) / $daxis->range()->span());
        if($daxis->position() == $CC_BOTTOM) {
            $daxis->render($cr, $uldp->x(), $lldp->y() + $bybump);
            $tybump += $daxis->height();
        } else {
            $daxis->render($cr, $uldp->x(), $uldp->y() - $tybump);
            $bybump += $daxis->height();
        }
    }

    my ($lxbump, $rxbump);
    foreach my $raxis (@{ $self->range_axes() }) {
        $raxis->height($iheight + $swhalf);
        $raxis->per(($iheight + $sw) / $raxis->range()->span());
        if($raxis->position() == $CC_LEFT) {
            $raxis->render($cr, $uldp->x() - $lxbump, $uldp->y());
            $lxbump += $raxis->width();
        } else {
            $raxis->render($cr, $urdp->x() + $rxbump, $uldp->y());
            $rxbump += $raxis->width();
        }
    }

    my $innersurf = Cairo::ImageSurface->create('argb32',
        $iwidth, $iheight
    );
    my $icr = Cairo::Context->create($innersurf);

    # Background fill
    $icr->set_source_rgba($self->background_color()->rgba());
    $icr->paint();

    # Prepare the grid and other markers.
    my (@odmarks, @ormarks);
    if($self->draw_markers()) {
        my (@dmarks, @rmarks);
        if($self->grid()) {
            my ($dgs, $rgs) = $self->grid()->prepare(
                $self->domain_axes()->[0],
                $self->range_axes()->[0]
            );
            if($dgs) {
                @dmarks = @{ $dgs };
            }
            if($rgs) {
                @rmarks = @{ $rgs };
            }
        }
        foreach my $dm (@{ $self->domain_markers() }) {
            if($self->above()) {
                push(@odmarks, $dm);
            } else {
                push(@dmarks, $dm);
            }
        }
        foreach my $rm (@{ $self->range_markers() }) {
            if($self->above()) {
                push(@ormarks, $rm);
            } else {
                push(@rmarks, $rm);
            }
        }

        my $mr = new Chart::Clicker::Renderer::Marker();
        $mr->domain_markers(\@dmarks);
        $mr->range_markers(\@rmarks);
        $log->debug('Rendering Markers');
        $mr->render($icr, undef, undef,
            $self->get_domain_axis(0),
            $self->get_range_axis(0)
        );
    }

    # Render!
    my $rndr = $self->renderer();

    my $count = 0;
    foreach my $ds (@{ $self->datasets }) {

        $rndr->render(
            $icr,
            $color_allocator,
            $ds,
            $self->get_domain_axis($count),
            $self->get_range_axis($count)
        );
        $count++;
    }

    $cr->set_source_surface($innersurf,
        $innerpoint->x(),
        $innerpoint->y()
    );
    $cr->paint();
    return $surface;
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
