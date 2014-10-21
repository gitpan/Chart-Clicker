use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Bar');
}

my $rndr = Chart::Clicker::Renderer::Bar->new;
ok(defined($rndr), 'new Bar Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Bar');

done_testing;