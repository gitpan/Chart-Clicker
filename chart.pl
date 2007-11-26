use strict;

use Chart::Clicker::Simple;
use Chart::Clicker::Renderer::Line;
use Chart::Clicker::Shape::Arc;
use Chart::Clicker::Drawing::Stroke qw(:line_caps :line_joins);

my @keys;
my (@vals1, @vals2, @vals3, @vals4);

for(1..4) {
    push(@keys, $_);
    push(@vals1, (rand(100) - rand(100)));
    push(@vals2, (rand(100) - rand(100)));
    push(@vals3, (rand(100) - rand(100)));
    push(@vals4, (rand(100) - rand(100)));
}

my $simple = new Chart::Clicker::Simple({
    data => [
        {
            keys    => \@keys,
            values  => \@vals1
        },
        {
             keys    => \@keys,
             values  => \@vals2
        },
        {
             keys    => \@keys,
             values  => \@vals3
        },
        {
             keys    => \@keys,
             values  => \@vals4
        }
    ],
    height          => 300,
    width           => 500,
    #hide_grid       => 1,
    #hide_axes       => 1,
    format          => 'png',
    domain_label    => 'Danes',
    # domain_tick_values    => [ 0, 1.5, 1.7, 3 ],
    # domain_tick_labels   => [ 'Q1', 'Q2', 'Q3', 'Q4' ],
    range_tick_format => '%0.2f',
    range_label     => 'Footballs & gq',
    range_baseline  => 0,
    renderer        => new Chart::Clicker::Renderer::Line({
        'border_color' => new Chart::Clicker::Drawing::Color({ name => 'white' }),
        'stroke' => new Chart::Clicker::Drawing::Stroke({
          # line_cap  => $CC_LINE_CAP_ROUND,
          # line_join => $CC_LINE_JOIN_ROUND,
          width     => 1
        }),
        'shape_stroke' => new Chart::Clicker::Drawing::Stroke({
          # line_cap  => $CC_LINE_CAP_ROUND,
          # line_join => $CC_LINE_JOIN_ROUND,
          width     => 3
        }),
        #opacity => .50,
        'shape' => new Chart::Clicker::Shape::Arc({
          radius => 5,
          angle1 => 0,
          angle2 => 360
        })
    }),
});

$simple->draw();
$simple->write('/Users/gphat/test.png');
