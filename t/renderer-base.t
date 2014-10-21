use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Renderer');
}

my $rndr = Chart::Clicker::Renderer->new;
ok(defined($rndr), 'new Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer');

done_testing;