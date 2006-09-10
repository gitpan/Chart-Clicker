package Chart::Clicker;
use strict;
use warnings;

use base 'Chart::Clicker::Drawing::Container';
__PACKAGE__->mk_accessors(
    qw(
        color_allocator context datasets domain_axes domain_markers
        range_axes range_markers plot surface
    )
);

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::ColorAllocator;
use Chart::Clicker::Drawing::Insets;
use Chart::Clicker::Drawing::Point;

use Cairo;

our $VERSION = '1.0.6';

sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);
    unless($self->width()) {
        $self->width(500);
    }
    unless($self->height()) {
        $self->height(300);
    }
    unless($self->insets()) {
        $self->insets(
            new Chart::Clicker::Drawing::Insets(
                { top => 5, bottom => 5, left => 5, right => 5 }
            )
        );
    }
    unless($self->background_color()) {
        $self->background_color(
            new Chart::Clicker::Drawing::Color(
                { red => 1, green => 1, blue => 1, alpha => 1 }
            )
        );
    }
    unless(defined($self->color_allocator())) {
        $self->color_allocator(new Chart::Clicker::Drawing::ColorAllocator());
    }
    unless($self->border()) {
        $self->border(new Chart::Clicker::Drawing::Border());
    }

    $self->range_markers([ ]);
    $self->domain_markers([ ]);

    $self->{'DSDOMAINAXIS'} = {};
    $self->{'DSRANGEAXIS'} = {};

    return $self;
}
sub inside_width {
    my $self = shift();

    my $w = $self->width();

    if(defined($self->insets())) {
        $w -= $self->insets->left() + $self->insets->right()
    }
    if(defined($self->border())) {
        $w -= $self->border->stroke->width() * 2;
    }

    return $w;
}

sub inside_height {
    my $self = shift();

    my $h = $self->height();
    if(defined($self->insets())) {
        $h -= $self->insets->bottom() + $self->insets->top();
    }
    if(defined($self->border())) {
        $h -= $self->border->stroke->width() * 2;
    }

    return $h;
}

sub draw {
    my $self = shift();

    $self->surface($self->SUPER::draw($self));
    return $self->surface();
}

sub prepare {
    my $self = shift();

    # Prepare the datasets and establish ranges for the axes.
    my $count = 0;
    foreach my $ds (@{ $self->datasets() }) {
        unless($ds->count() > 0) {
            die("Dataset $count is empty.");
        }
        $ds->prepare();

        my $daxis = $self->get_dataset_domain_axis($count);
        if(defined($daxis)) {
            $daxis->range->combine($ds->domain());
        }

        my $raxis = $self->get_dataset_range_axis($count);
        if(defined($raxis)) {
            $raxis->range->combine($ds->range());
        }

        $count++;
    }

    $self->surface(Cairo::ImageSurface->create(
        'argb32', $self->width(), $self->height())
    );
    $self->context(Cairo::Context->create($self->surface()));

    $self->SUPER::prepare($self, $self->dimensions());
    return 1;
}

sub set_dataset_domain_axis {
    my $self = shift();
    my $dsidx = shift();
    my $axis = shift();

    $self->{'DSDOMAINAXIS'}->{$dsidx} = $axis;
    return 1;
}

sub get_dataset_domain_axis {
    my $self = shift();
    my $idx = shift();

    unless(defined($self->domain_axes())) {
        return;
    }

    my $aidx = $self->{'DSDOMAINAXIS'}->{$idx};
    if(defined($aidx)) {
        return $self->domain_axes->[$aidx];
    } else {
        return $self->domain_axes->[0];
    }
}

sub set_dataset_range_axis {
    my $self = shift();
    my $dsidx = shift();
    my $axisidx = shift();

    $self->{'DSRANGEAXIS'}->{$dsidx} = $axisidx;
    return 1;
}

sub get_dataset_range_axis {
    my $self = shift();
    my $idx = shift();

    unless(defined($self->range_axes())) {
        return;
    }

    my $aidx = $self->{'DSRANGEAXIS'}->{$idx};
    if(defined($aidx)) {
        return $self->range_axes->[$aidx];
    } else {
        return $self->range_axes->[0];
    }
}

sub write {
    my $self = shift();
    my $file = shift();

    $self->surface->write_to_png($file);
    return 1;
}

sub png {
    my $self = shift();

    my $buff;
    $self->surface->write_to_png_stream(sub {
        my ($closure, $data) = @_;
        $buff .= $data;
    });

    return $buff;
}

1;

__END__

=head1 NAME

Chart::Clicker - Powerful, extensible charting.

=head1 DESCRIPTION

Chart::Clicker aims to be a powerful, extensible charting package that creates
really pretty output.

Clicker leverages the power of Cairo to create snazzy 2D graphics easily and
quickly.

At it's core Clicker is more of a toolkit for creating charts.  It's interface
is a bit more complex because making pretty charts requires attention and care.
Some fine defaults are established to make getting started easier, but to really
unleash the potential of Clicker you must roll up your sleeves and build
things by hand.

=head1 WARNING

Clicker is in heavy development.  The interface is not optimal, there are
features missing, and pieces of it flat out do not work.  Good software is
not Athena and therefore doesn't spring fully formed from the mind.  It will
take some time to nail down the interface.  You can find more information at
L<http://www.onemogin.com/clicker>.  Feel free to send your criticisms,
advice, patches or money to me as a way of helping.

=head1 SYNOPSIS

  use Chart::Clicker;
  use Chart::Clicker::Axis;
  use Chart::Clicker::Data::DataSet;
  use Chart::Clicker::Data::Series;
  use Chart::Clicker::Decoration::Grid
  use Chart::Clicker::Decoration::Legend
  use Chart::Clicker::Decoration::Plot
  use Chart::Clicker::Drawing qw(:positions);
  use Chart::Clicker::Drawing::Insets;
  use Chart::Clicker::Renderer::Area

  my $c = new Chart::Clicker({ width => 500, height => 350 });

  my $series = new Chart::Clicker::Data::Series({
    keys    => [1, 2, 3, 4, 5, 6],
    values  => [12, 9, 8, 3, 5, 1]
  });

  my $dataset = new Chart::Clicker::Data::DataSet({
    series => [ $series ]
  });

  my $legend = new Chart::Clicker::Decoration::Legend({
    margins => new Chart::Clicker::Drawing::Insets({
        top => 3
    })
  });
  $chart->add($legend, $CC_BOTTOM);

  my $daxis = new Chart::Clicker::Axis({
    orientation => $CC_HORIZONTAL,
    position    => $CC_BOTTOM,
    format      => '%0.2f'
  });
  $chart->add($daxis, $CC_AXIS_BOTTOM);

  my $raxis = new Chart::Clicker::Axis({
    orientation => $CC_VERTICAL,
    position    => $CC_LEFT,
    format      => '%0.2f'
  });
  $chart->add($raxis, $CC_AXIS_LEFT);

  $chart->range_axes([ $raxis ]);
  $chart->domain_axes([ $daxis ]);

  my $grid = new Chart::Clicker::Decoration::Grid();
  $chart->add($grid, $CC_CENTER, 0);

  my $renderer = new Chart::Clicker::Renderer::Area();
  $renderer->options({
    fade => 1
  });

  my $plot = new Chart::Clicker::Decoration::Plot();
  $plot->renderers([$renderer]);

  $chart->add($plot, $CC_CENTER);

  $chart->prepare();
  $chart->draw();
  $chart->write('/path/to/chart.png');

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker object. If no width and height are specified then
defaults of 500 and 300 are chosen, respectively.

=back

=head2 Class Methods

=over 4

=item inside_width

Get the width available in this container after taking away space for
insets and borders.

=item $c->inside_height()

Get the height available in this container after taking away space for
insets and borders.

=item draw

Draw this chart

=item prepare

Prepare this chart for rendering.

=item set_dataset_domain_axis

  $chart->set_dataset_domain_axis($dataset_index, $axis_index)

Affines the dataset at the specified index to the domain axis at the second
index.

=item get_dataset_domain_axis

  my $axis = $chart->get_dataset_domain_axis($index)

Returns the domain axis to which the specified dataset is affined.

=item set_dataset_range_axis

  $chart->set_dataset_range_axis($dataset_index, $axis_index)

Affines the dataset at the specified index to the range axis at the second
index.

=item get_dataset_range_axis

  my $axis = $chart->get_dataset_range_axis($index)

Returns the range axis to which the specified dataset is affined.

=item write

Write the resulting png file to the specified location.

  $c->write('/path/to/the.png');

=item png

Returns the PNG data as a scalar.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
