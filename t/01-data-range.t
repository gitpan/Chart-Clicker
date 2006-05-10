use Test::More tests => 7;

BEGIN { use_ok('Chart::Clicker::Data::Range'); }

my $range = new Chart::Clicker::Data::Range({ lower => 1, upper => 10 });
ok(defined($range), 'new Chart::Clicker::Data::Range');
isa_ok($range, 'Chart::Clicker::Data::Range', 'isa Chart::Clicker::Data::Range');

$range->combine(new Chart::Clicker::Data::Range({ lower => 3, upper => 15 }));
ok($range->lower() == 1, 'Combine 1: Lower stays');
ok($range->upper() == 15, 'Combine 1: Upper moves');

$range->combine(new Chart::Clicker::Data::Range({ lower => -1, upper => 5 }));
ok($range->lower() == -1, 'Combine 2: Lower moves');
ok($range->upper() == 15, 'Combine 2: Upper stays');
