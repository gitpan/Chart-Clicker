use Test::More;

BEGIN {
    use_ok('Chart::Clicker::Renderer::Line');
}

my $rndr = Chart::Clicker::Renderer::Line->new;
ok(defined($rndr), 'new Line Renderer');
isa_ok($rndr, 'Chart::Clicker::Renderer::Line');

done_testing;