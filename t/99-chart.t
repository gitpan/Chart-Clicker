use Test::More tests => 9;

BEGIN {
    use_ok('Chart::Clicker');
    use_ok('Chart::Clicker::Drawing::Color');
    use_ok('Chart::Clicker::Drawing::Stroke');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Data::Series');
}

my $w = 600;
my $h = 500;
my $chart = new Chart::Clicker({ width => $w, height => $h });
$chart->background_color(
    new Chart::Clicker::Drawing::Color({ red => 1, green => 1, blue => 1, alpha => 1 })
);
$chart->border()->stroke()->line_join($Chart::Clicker::Drawing::Stroke::LINE_JOIN_BEVEL);

eval { $chart->draw(); };
ok($@, 'Failed on empty datasets');

ok($chart->width() == $w, 'width()');

ok($chart->height() == $h, 'height()');

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

my $renderer = new Chart::Clicker::Renderer::Point();
$renderer->options({ opacity => .25 });
$chart->plot()->border()->stroke()->line_join(
    $Chart::Clicker::Drawing::Stroke::LINE_JOIN_BEVEL
);
$chart->plot()->renderer($renderer);

my $dataset = new Chart::Clicker::Data::DataSet();
$dataset->series([ $series, $series2 ]);

$chart->plot->datasets([ $dataset ]);

$chart->plot()->grid()->color(
    new Chart::Clicker::Drawing::Color({
        red => .78, green => .78, blue => .78, alpha => 1
    })
);

$chart->draw();


# Test that the plot is properly computed.
my $plot = $chart->plot();
ok(defined($plot), 'Plot exists');

$chart->write('/users/gphat/test.png');
