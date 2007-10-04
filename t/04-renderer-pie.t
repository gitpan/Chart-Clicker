use Test::More tests => 5;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Pie');
    use_ok('Chart::Clicker::Data::Series');
    use_ok('Chart::Clicker::Data::DataSet');
}

my $series = new Chart::Clicker::Data::Series();
my @keys = ('Mon', 'Tue', 'Wed', 'Thu', 'Fri');
my @vals = (10, 2, 3, 9, 5);
$series->keys(\@keys);
$series->values(\@vals);

my $ds = new Chart::Clicker::Data::DataSet();
$ds->series([ $series ]);

my $rndr = new Chart::Clicker::Renderer::Pie();
ok(defined($rndr), 'new Pie Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Pie');