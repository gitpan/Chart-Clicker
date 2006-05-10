use Test::More tests => 2;

BEGIN { use_ok('Chart::Clicker::Log'); }

my $log = Chart::Clicker::Log->get_logger('Test::Foo');
ok(defined($log), 'get_logger');
