package Chart::Clicker::Renderer::Line;
use strict;

=head1 NAME

Chart::Clicker::Renderer::Line

=head1 DESCRIPTION

Chart::Clicker::Renderer::Line renders a dataset as lines.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Renderer::Line');

=head1 METHODS

=head2 Class Methods

=over 4

=item render

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

    foreach my $series (@{ $dataset->series() }) {
        $cr->new_path();
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
        }
        my $color = $ca->next();
        $cr->set_source_rgba($color->rgba());;
        $cr->stroke();
    }
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut

1;
