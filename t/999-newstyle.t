use Test::More tests => 14;

BEGIN {
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Axis');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Data::Series');
    use_ok('Chart::Clicker::Decoration::Grid');
    use_ok('Chart::Clicker::Decoration::Label');
    use_ok('Chart::Clicker::Decoration::Legend');
    use_ok('Chart::Clicker::Drawing');
    use_ok('Chart::Clicker::Drawing::Container');
    use_ok('Chart::Clicker::Renderer::Area');
}

use Chart::Clicker::Drawing qw(:positions);

my $chart = new Chart::Clicker({ width => 300, height => 250 });
ok(defined($chart), 'new Chart::Clicker');

my $series = new Chart::Clicker::Data::Series();
my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);
$series->keys(\@keys);
$series->values(\@vals);

my $series2 = new Chart::Clicker::Data::Series();
my @keys2 = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals2 = (67, 15, 6, 90, 11, 45, 83, 11, 9, 101);
$series2->keys(\@keys2);
$series2->values(\@vals2);

my $dataset = new Chart::Clicker::Data::DataSet();
$dataset->series([ $series, $series2 ]);

$chart->datasets([ $dataset ]);

my $legend = new Chart::Clicker::Decoration::Legend();
ok(defined($legend), 'new Legend');

$chart->add($legend, $CC_BOTTOM);

my $daxis = new Chart::Clicker::Axis({
    orientation => $CC_HORIZONTAL,
    position => $CC_TOP
});
my $tlabel = new Chart::Clicker::Decoration::Label({ text => 'Danes', orientation => $CC_HORIZONTAL});
$chart->add($tlabel, $CC_TOP);

my $label = new Chart::Clicker::Decoration::Label({text => 'Footballs', orientation => $CC_VERTICAL});
$chart->add($label, $CC_RIGHT);

my $raxis = new Chart::Clicker::Axis({
    orientation => $CC_VERTICAL,
    position => $CC_RIGHT
});
ok(defined($raxis), 'new Axis');

$chart->add($raxis, $CC_AXIS_RIGHT);
$chart->add($daxis, $CC_AXIS_TOP);

$chart->range_axes([ $raxis ]);
$chart->domain_axes([ $daxis ]);

my $grid = new Chart::Clicker::Decoration::Grid();
$chart->add($grid, $CC_CENTER, 0);

my $renderer = new Chart::Clicker::Renderer::Area();
ok(defined($renderer), 'new Renderer');
$renderer->border(
    new Chart::Clicker::Drawing::Border()
);
$renderer->insets(new Chart::Clicker::Drawing::Insets({ top => 5, bottom => 5, right => 5, left => 5 }));
$renderer->options({
    fade => 1,
    stroke => new Chart::Clicker::Drawing::Stroke({
        width => 2
    })
});


$chart->add($renderer, $CC_CENTER);

$chart->prepare();
my $surf = $chart->draw();
