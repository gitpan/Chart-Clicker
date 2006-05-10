use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Marker');
}

my $dec = new Chart::Clicker::Decoration::Marker();
my $value = 12;

$dec->value($value);
ok($dec->value() eq $value, 'Value');
