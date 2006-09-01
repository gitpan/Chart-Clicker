package Chart::Clicker::Renderer::Bar;
use strict;
use warnings;

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

sub prepare {
    my $self = shift();

    $self->SUPER::prepare(@_);

    $self->{'COUNT'}++;
    $self->{'SCOUNT'} = 0;

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();
    my $min = shift();

    my $height = $self->height();
    my $width = $self->width();

    my $xper = $domain->per();
    my $yper = $range->per();

    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };

    my $color = $clicker->color_allocator->next();

    my $padding = $self->get_option('padding');
    unless($padding) {
        $padding = 4;
    }

    # Calculate the width bar we can use to fit all the datasets.
    my $bwidth = $xper / $self->{'COUNT'} - $padding;

    for(0..($series->key_count() - 1)) {
        # Add the series_count times the width to so that each bar
        # gets rendered with it's partner in the other series.
        my $x = ($xper * ($keys[$_] - $keys[0]))
            + ($self->{'SCOUNT'} * $bwidth);
        my $y = $height - ($yper * ($vals[$_] - $min));
        $cr->rectangle(
            $x + $padding / 2, $y,
            $bwidth, $height,
        );
    }

    my $opac = $self->get_option('opacity');
    my $fillcolor;
    if($opac) {
        $fillcolor = $color->clone();
        $fillcolor->alpha($opac);
    } else {
        $fillcolor = $color;
    }


    my $path = $cr->copy_path();
    $cr->set_source_rgba($color->rgba());
    $cr->stroke();
    $cr->append_path($path);
    $cr->set_source_rgba($fillcolor->rgba());
    $cr->fill();
    $self->{'SCOUNT'}++;

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Bar

=head1 DESCRIPTION

Chart::Clicker::Renderer::Bar renders a dataset as points.

=head1 SYNOPSIS

  my $br = new Chart::Clicker::Renderer::Bar({});

=head1 OPTIONS

=over 4

=item opacity

If true this value will be used when setting the opacity of the bar's fill.

=item padding

How much padding to put around a bar.  A padding of 4 will result in 2 pixels
on each side.

=back

=head1 METHODS

=head2 Class Methods

=over 4

=item prepare

Prepare the renderer

=item draw

Draw the data!

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
