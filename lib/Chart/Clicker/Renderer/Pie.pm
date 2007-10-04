package Chart::Clicker::Renderer::Pie;
use Moose;

extends 'Chart::Clicker::Renderer::Base';

use Cairo;

use Chart::Clicker::Shape::Arc;

my $TO_RAD = (4 * atan2(1, 1)) / 180;

sub prepare {
    my $self = shift();
    my $clicker = shift();

    $self->SUPER::prepare($clicker, @_);

    foreach my $ds (@{ $clicker->datasets() }) {
        foreach my $series (@{ $ds->series() }) {
            foreach my $val (@{ $series->values() }) {
                $self->{'ACCUM'}->{$series->name()} += $val;
                $self->{'TOTAL'} += $val;
            }
        }
    }

    $self->{'RADIUS'} = $self->height();
    if($self->width() < $self->height()) {
        $self->{'RADIUS'} = $self->width();
    }
    $self->{'RADIUS'} = $self->{'RADIUS'} / 2;

    $self->{'MIDX'} = $self->width() / 2;
    $self->{'MIDY'} = $self->height() / 2;
    $self->{'POS'} = 0;
}

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

    my $bcolor = $self->get_option('border_color');# = $clicker->color_allocator->next();
    if(!$bcolor) {
        $bcolor = new Chart::Clicker::Drawing::Color({ name => 'black' });
    }

    #my @vals = @{ $series->values() };
    #my @keys = @{ $series->keys() };

    # my $kcount = $series->key_count() - 1;
    # 
    # my %accum;
    # my $total;
    # for(0..$kcount) {
    #     #my $x = $domain->mark($keys[$_]);
    #     #my $y = $height - $range->mark($vals[$_]);
    #     $accum{$keys[$_]} += $vals[$_];
    #     $total += $vals[$_];
    # }

    my $midx = $self->{'MIDX'};
    my $midy = $self->{'MIDY'};

    # my $pos = 0;
    #foreach my $key (keys(%accum)) {
        my $avg = $self->{'ACCUM'}->{$series->name()} / $self->{'TOTAL'};
        my $degs = ($avg * 360) + $self->{'POS'};
        # my $arc = new Chart::Clicker::Shape::Arc({
        #     angle1  => $self->{'POS'},
        #     angle2  => $degs,
        #     radius  => $self->{'RADIUS'}
        # });
        # $arc->create_path($cr, $midx, $midy);

        $cr->line_to($midx, $midy);
        #$arc->angle1($degs);
        #$arc->angle2($self->{'POS'});

        $cr->arc_negative($midx, $midy, $self->{'RADIUS'}, $degs * $TO_RAD, $self->{'POS'} * $TO_RAD);
        $cr->line_to($midx, $midy);
        $cr->close_path();

        my $color = $clicker->color_allocator->next();

        $cr->set_source_rgba($color->rgba());
        $cr->fill_preserve();

        $cr->set_source_rgba($bcolor->rgba());
        $cr->stroke();

        $self->{'POS'} = $degs;
    #}

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Pie

=head1 DESCRIPTION

Chart::Clicker::Renderer::Pie renders a dataset as slices of a pie.  The keys
of like-named Series are totaled and keys are ignored.

=head1 SYNOPSIS

  my $lr = new Chart::Clicker::Renderer::Pie();
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
