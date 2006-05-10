package Chart::Clicker::Renderer::Marker;
use strict;

=head1 NAME

Chart::Clicker::Renderer::Marker

=head1 DESCRIPTION

Chart::Clicker::Renderer::Marker renders markers, not data.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

__PACKAGE__->mk_accessors(qw(domain_markers range_markers));

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Renderer::Marker');

=head1 METHODS

=head2 Class Methods

=over 4

=item $image = $r->render()

Render the series.

=cut
sub render {
    my $self = shift();
    my $cr = shift();
    my $ca = shift();
    my $ds = shift();
    my $domain = shift();
    my $range = shift();

    my $xper = $domain->per();
    my $yper = $range->per();
    my $width = $domain->width();
    my $height = $range->height();

    my ($x1, $y1, $x2, $y2);
    foreach my $mark (@{ $self->domain_markers() }) {
        $x1 = int($mark->value() * $xper);
        $y1 = 0;
        $x2 = $x1;
        $y2 = $height;

        $cr->set_source_rgba($mark->color()->rgba());
        $cr->set_line_width($mark->stroke()->width());
        $cr->new_path();
        $cr->move_to($x1, $y1);
        $cr->line_to($x2, $y2);
        $cr->stroke();
    }
    foreach my $mark (@{ $self->range_markers() }) {
        $x1 = 0;
        $y1 = int($mark->value() * $yper);
        $x2 = $width;
        $y2 = $y1;

        $cr->set_source_rgba($mark->color()->rgba());
        $cr->set_line_width($mark->stroke()->width());
        $cr->new_path();
        $cr->move_to($x1, $y1);
        $cr->line_to($x2, $y2);
        $cr->stroke();
    }
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut

1;
