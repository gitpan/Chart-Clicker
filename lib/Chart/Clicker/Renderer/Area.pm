package Chart::Clicker::Renderer::Area;
use strict;

=head1 NAME

Chart::Clicker::Renderer::Area

=head1 DESCRIPTION

Chart::Clicker::Renderer::Area renders a dataset as lines.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

use Chart::Clicker::Log;

use Cairo;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Renderer::Area');

=head1 METHODS

=head2 Class Methods

=over 4

=item render

Render the series.

=cut
sub draw {
    my $self = shift();
    my $clicker = shift();

    $clicker->color_allocator()->reset();

    my $surface = $self->SUPER::draw($clicker);
    my $cr = Cairo::Context->create($surface);

    my $count = 0;
    foreach my $dataset (@{ $clicker->datasets() }) {

        my $domain = $clicker->get_domain_axis($count);
        my $range  = $clicker->get_range_axis($count);

        my $min = $dataset->range()->lower();

        my $height = $self->height();

        my $xper = $domain->per();
        my $yper = $range->per();

        $cr->new_path();
        foreach my $series (@{ $dataset->series() }) {
            my $lastx; # used for completing the path
            my @vals = @{ $series->values() };
            for(my $i = 0; $i < $series->key_count(); $i++) {
                my $x = $xper * $i;
                my $y = $height - ($yper * ($vals[$i] - $min));
                $log->debug("Plotting value $i (".$vals[$i].") at $x,$y.");
                if($i == 0) {
                    $cr->move_to($x, $y);
                } else {
                    $cr->line_to($x, $y);
                }
                $lastx = $x;
            }
            my $color = $clicker->color_allocator->next();
            $cr->set_source_rgba($color->rgba());
            $cr->line_to($lastx, $height);
            $cr->line_to(0, $height);
            $cr->close_path();

            if($self->get_option('stroke')) {
                my $stroke = $self->get_option('stroke');
                $cr->set_line_width($stroke->width());
                $cr->set_line_cap($stroke->line_cap());
                $cr->set_line_join($stroke->line_join());
            }

            my $path = $cr->copy_path();
            $cr->stroke();

            $cr->append_path($path);

            if($self->get_option('opacity')) {

                my $clone = $color->clone();
                $clone->alpha($self->get_option('opacity'));
                $cr->set_source_rgba($clone->rgba());
            } elsif($self->get_option('fade')) {

                my $patt = Cairo::LinearGradient->create(0.0, 0.0, 1.0, $height);
                $patt->add_color_stop_rgba(
                    0.0, $color->red(), $color->green(), $color->blue(),
                    $color->alpha()
                );
                $patt->add_color_stop_rgba(
                    1.0, $color->red(), $color->green(), $color->blue(),
                    0
                );
                $cr->set_source($patt);
            } else {

                $cr->set_source_rgba($color->rgba());
            }

            $cr->fill();
        }
    }
    return $surface;
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut

1;
