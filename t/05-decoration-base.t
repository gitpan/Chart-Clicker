use Test::More tests => 2;

BEGIN {
    use_ok('Chart::Clicker::Decoration::Base');
}

my $dec = new Chart::Clicker::Decoration::Base();
isa_ok($dec, 'Chart::Clicker::Decoration::Base');
