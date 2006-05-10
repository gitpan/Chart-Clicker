use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Drawing::Insets');
}

my @insets = (25, 25, 25, 25);
my $insets = new Chart::Clicker::Drawing::Insets({
    top     => $insets[0],
    bottom  => $insets[1],
    left    => $insets[3],
    right   => $insets[4]
});
isa_ok($insets, 'Chart::Clicker::Drawing::Insets');
