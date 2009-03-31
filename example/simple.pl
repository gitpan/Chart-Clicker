#!/usr/bin/perl
use strict;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;

my $cc = Chart::Clicker->new(width => 500, height => 400);

my @hours = qw(
    1 2 3 4 5 6 7 8 9 10 11 12
);
my @bw1 = qw(
    5.8 5.0 4.9 4.8 4.5 4.25 3.5 2.9 2.5 1.8 .9 .8
);
my @bw2 = qw(
    .7 1.1 1.7 2.5 3.0 4.5 5.0 4.9 4.7 4.8 4.2 4.4
);
my @bw3 = qw(
    .3 1.4 1.2 1.5 4.0 3.5 2.0 1.9 2.7 4.2 3.2 1.1
);

my $series1 = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw1,
);
my $series2 = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw2,
);
my $series3 = Chart::Clicker::Data::Series->new(
    keys    => \@hours,
    values  => \@bw3,
);


my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series1, $series2, $series3 ]);

$cc->add_to_datasets($ds);

my $defctx = $cc->get_context('default');

my $grey = Graphics::Color::RGB->new(
    red => .36, green => .36, blue => .36, alpha => 1
);
my $green = Graphics::Color::RGB->new(
    red => 0, green => .36, blue => 0, alpha => 1
);
my $blue = Graphics::Color::RGB->new(
    red => 0, green => 0, blue => .76, alpha => 1
);

$cc->color_allocator->colors([ $grey, $green, $blue ]);

$defctx->range_axis->label('Lorem');
$defctx->domain_axis->label('Ipsum');
$defctx->domain_axis->tick_label_angle(0.785398163);
$defctx->renderer->brush->width(1);

$cc->draw;
$cc->write('foo.png');
