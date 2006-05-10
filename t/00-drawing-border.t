use Test::More tests => 3;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Border');
}

my $border = new Chart::Clicker::Drawing::Border();
isa_ok($border, 'Chart::Clicker::Drawing::Border');

ok(defined($border->stroke()), 'Default stroke');
