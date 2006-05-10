use Test::More tests => 21;

BEGIN {
    use_ok('Chart::Clicker::Plot');
    use_ok('Chart::Clicker::Data::Series');
    use_ok('Chart::Clicker::Data::DataSet');
    use_ok('Chart::Clicker::Decoration::Marker');
    use_ok('Chart::Clicker::Renderer::Area');
}

my $plot = new Chart::Clicker::Plot();

$plot->width(120);
ok($plot->width() == 120, 'width()');

$plot->height(50);
ok($plot->height() == 50, 'height()');

ok(defined($plot->range_axes()), 'Range Axes');
ok(defined($plot->domain_axes()), 'Domain Axes');

my $series = new Chart::Clicker::Data::Series();
my $name = 'Series';
$series->name($name);
my @keys = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
my @vals = (42, 25, 86, 23, 2, 19, 103, 12, 54, 9);
$series->keys(\@keys);
$series->values(\@vals);

my $dataset = new Chart::Clicker::Data::DataSet();
$dataset->series([ $series ]);

$plot->datasets([ $dataset ]);

my $rdr = new Chart::Clicker::Renderer::Area();
$plot->renderer($rdr);
ok(defined($rdr), 'Renderer');

$plot->prepare();
ok($plot->datasets()->[0]->count() == 1, 'Prepare looks ok');

ok(defined($plot->range_axes()), 'Range Axes set');
ok(defined($plot->domain_axes()), 'Domain Axes set');

my $rmark = new Chart::Clicker::Decoration::Marker();
$plot->add_range_marker($rmark);
ok(defined($plot->range_markers()->[0]), 'Range Marker');

my $dmark = new Chart::Clicker::Decoration::Marker();
$plot->add_domain_marker($dmark);
ok(defined($plot->domain_markers()->[0]), 'Domain Marker');


ok(defined($plot->get_range_axis(0)), 'Dataset 0 Range Axis');
ok($plot->get_range_axis(0)->range()->lower() == 2, 'Range Axis Lower');
ok($plot->get_range_axis(0)->range()->upper() == 103, 'Range Axis Upper');
ok(defined($plot->get_domain_axis(0)), 'Dataset 0 Domain Axis');
ok($plot->get_domain_axis(0)->range()->lower() == 1, 'Domain Axis Lower');
ok($plot->get_domain_axis(0)->range()->upper() == 10, 'Domain Axis Upper');
