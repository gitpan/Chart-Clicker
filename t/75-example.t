use Test::More tests => 3;

use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::Series::Size;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Renderer::Point;

BEGIN {
    use_ok('Chart::Clicker');
}

my $cc = Chart::Clicker->new;
isa_ok($cc, 'Chart::Clicker');

my $series = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 42, 25, 86, 23, 2, 19, 103, 12, 54, 9 ],
);

my $series2 = Chart::Clicker::Data::Series->new(
    keys    => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ],
    values  => [ 67, 15, 6, 90, 11, 45, 83, 11, 9, 101 ],
);

my $ds = Chart::Clicker::Data::DataSet->new(series => [ $series, $series2 ]);

$cc->add_to_datasets($ds);

$cc->prepare();
$cc->do_layout($cc);
$cc->draw();
$cc->write('/Users/gphat/foo.png');
# my $data = $cc->data();
# ok(defined($data), 'data');

