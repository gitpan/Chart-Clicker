package Chart::Clicker::Renderer::Bar;
use strict;

=head1 NAME

Chart::Clicker::Renderer::Bar

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bar renders a dataset as points.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Renderer::Bar');

=head1 METHODS

=head2 Class Methods

=over 4

=item $image = $r->render($color_allocator)

Render the series.

=cut
sub render {
    my $self = shift();
    my $cr = shift();
    my $ca = shift();
    my $dataset = shift();
    my $domain = shift();
    my $range = shift();

    my $xper = $domain->per();
    my $yper = $range->per();
    my $min = $dataset->range()->lower();
    my $height = $range->height();

    # Calculate the width bar we can use to fit all the datasets.
    my $width = $xper / $dataset->count();

    my $scount = 0;
    foreach my $series (@{ $dataset->series() }) {
        my @vals = @{ $series->values() };
        my $color = $ca->next();
        for(my $i = 0; $i < $series->key_count(); $i++) {
            # Add the series_count times the width to so that each bar
            # gets rendered with it's partner in the other series.
            my $x = ($xper * $i) + ($scount * $width);
            my $y = $height - ($yper * ($vals[$i] - $min));
            $log->debug("Plotting value $i (".$vals[$i].") at $x,$y.");
            $cr->rectangle(
                $x, $y,
                $width, $height,
            );
            my $path = $cr->copy_path();
            $cr->set_source_rgba($color->rgba());
            $cr->stroke();
            $cr->append_path($path);
            $cr->set_source_rgba($color->rgba());
            $cr->fill();
        }
        $scount++;
    }
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut

1;
