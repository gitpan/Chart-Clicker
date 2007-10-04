package Chart::Clicker::Renderer::Area;
use Moose;

extends 'Chart::Clicker::Renderer::Base';

use Cairo;

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

    my $height = $self->height();
    my $width = $self->width();

    my $linewidth = 1;
    my $stroke = $self->get_option('stroke');
    if($stroke) {
        $linewidth = $stroke->width();
        $cr->set_line_cap($stroke->line_cap());
        $cr->set_line_join($stroke->line_join());
    }
    $cr->set_line_width($linewidth);

    $cr->new_path();

    my $lastx; # used for completing the path
    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };

    my $startx;

    for(0..($series->key_count() - 1)) {

        my $x = $domain->mark($keys[$_]);

        my $y = $height - $range->mark($vals[$_]);
        if($_ == 0) {
            $startx = $x;
            $cr->move_to($x, $y);
        } else {
            $cr->line_to($x, $y);
        }
        $lastx = $x;
    }
    my $color = $clicker->color_allocator->next();
    $cr->set_source_rgba($color->rgba());

    my $path = $cr->copy_path();
    $cr->stroke();

    $cr->append_path($path);
    $cr->line_to($lastx, $height);
    $cr->line_to($startx, $height);
    $cr->close_path();

    my $opac = $self->get_option('opacity');
    if($opac) {

        my $clone = $color->clone();
        $clone->alpha($opac);
        $cr->set_source_rgba($clone->rgba());
    } elsif($self->get_option('fade')) {

        my $patt = Cairo::LinearGradient->create(0.0, 0.0, 1.0, $height);
        $patt->add_color_stop_rgba(
            1.0, $color->red(), $color->green(), $color->blue(),
            $color->alpha()
        );
        $patt->add_color_stop_rgba(
            0.0, $color->red(), $color->green(), $color->blue(), 0
        );
        $cr->set_source($patt);
    } else {

        $cr->set_source_rgba($color->rgba());
    }

    $cr->fill();

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Area

=head1 DESCRIPTION

Chart::Clicker::Renderer::Area renders a dataset as lines.

=head1 SYNOPSIS

  my $ar = new Chart::Clicker::Renderer::Area();
  # Optionally set some options
  $ar->options({
    fade => 1,
    stroke => new Chart::Clicker::Drawing::Stroke({
        width => 2
    })
  });

=head1 OPTIONS

=over 4

=item fade

If true, the color of the fill will be faded from opaque at the top to
transparent at the bottom.

=item opacity

If true this value will be used when setting the opacity of the fill.  This
setting may not be used with the 'fade' option.

=item stroke

Allows a Stroke object to be passed that will define the Stroke used on the
series' line.

=back

=head1 METHODS

=head2 Class Methods

=over 4

=item draw

Draw the data.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

L<Chart::Clicker::Renderer>, perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
