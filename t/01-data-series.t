use Test::More tests => 19;

BEGIN { use_ok('Chart::Clicker::Data::Series'); }

my $series = new Chart::Clicker::Data::Series();
ok(defined($series), 'new Chart::Clicker::Data::Series');
isa_ok($series, 'Chart::Clicker::Data::Series', 'isa Chart::Clicker::Data::Series');

my $name = 'Foo';
$series->name($name);
ok($series->name() eq $name, 'Name');

my @values = (1, 2, 3);
$series->values(\@values);
my $svals = $series->values();
ok(defined($svals), 'Values set');
ok($values[0] == $svals->[0], 'Value 0');
ok($values[1] == $svals->[1], 'Value 1');
ok($values[2] == $svals->[2], 'Value 2');

eval {
    $series->prepare();
};
ok(defined($@), 'Fail when keycount != valuecount');

my @keys = ('Uno', 'Dos', 'Tres');
$series->keys(\@keys);
my $skeys = $series->keys();
ok(defined($skeys), 'Keys set');
ok($keys[0] eq $skeys->[0], 'Key 0');
ok($keys[1] eq $skeys->[1], 'Key 1');
ok($keys[2] eq $skeys->[2], 'Key 2');

eval {$series->prepare(); };
ok(!$@, 'Series prepare()');
ok($series->max_key_length() == length($keys[2]), 'Key Length');

ok($series->key_count() == @keys, 'Key Count');
ok($series->value_count() == @values, 'Value Count');
ok($series->range()->lower() == $values[0], 'Minimum Value');
ok($series->range()->upper() == $values[2], 'Maximum Value');
