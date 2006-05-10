use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Font');
}

my $font = new Chart::Clicker::Drawing::Font();
isa_ok($font, 'Chart::Clicker::Drawing::Font');
