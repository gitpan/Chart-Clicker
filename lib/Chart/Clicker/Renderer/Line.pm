package Chart::Clicker::Renderer::Line;
use strict;
use warnings;

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

use Cairo;

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

    my $height = $self->height();
    my $linewidth = 1;
    my $stroke = $self->get_option('stroke');
    if($stroke) {
        $linewidth = $stroke->width();
        $cr->set_line_cap($stroke->line_cap());
        $cr->set_line_join($stroke->line_join());
    }
    $cr->set_line_width($linewidth);

    $cr->new_path();
    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };
    for(0..($series->key_count() - 1)) {
        my $x = $domain->mark($keys[$_]);
        my $y = $height - $range->mark($vals[$_]);
        if($_ == 0) {
            $cr->move_to($x, $y);
        } else {
            $cr->line_to($x, $y);
        }
    }
    my $color = $clicker->color_allocator()->next();
    $cr->set_source_rgba($color->rgba());;
    $cr->stroke();

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Line

=head1 DESCRIPTION

Chart::Clicker::Renderer::Line renders a dataset as lines.

=head1 SYNOPSIS

  my $lr = new Chart::Clicker::Renderer::Line();
  # Optionally set the stroke
  $lr->options({
    stroke => new Chart::Clicker::Drawing::Stroke({
      ...
    })
  });

=head1 OPTIONS

=over 4

=item stroke

Set a Stroke object to be used for the lines.

=back

=head1 METHODS

=head2 Class Methods

=over 4

=item render

Render the series.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
