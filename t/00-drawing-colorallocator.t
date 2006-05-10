use Test::More tests => 7;

BEGIN {
    use_ok('Chart::Clicker::Drawing::ColorAllocator');
}

my $ca = new Chart::Clicker::Drawing::ColorAllocator({
});
isa_ok($ca, 'Chart::Clicker::Drawing::ColorAllocator');

my $red = $ca->next();
ok(defined($red), 'First Color');
ok($red->name() eq 'red', 'First is red');
ok($red->red() == 1.0, 'Red value');
my $green = $ca->next();
ok(defined($green), 'Second Color');
ok($green->name() eq 'green', 'Second is green');
