use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Stroke');
}

my $stroke = new Chart::Clicker::Drawing::Stroke();
isa_ok($stroke, 'Chart::Clicker::Drawing::Stroke');

ok($stroke->width() == 1, 'Default width');
