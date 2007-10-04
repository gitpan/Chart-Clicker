package Chart::Clicker::Renderer::StackedBar;
use Moose;

extends 'Chart::Clicker::Renderer::Base';

sub prepare {
    my $self = shift();

    $self->SUPER::prepare(@_);

    my $clicker = shift();
    my $idim = shift();
    my $datasets = shift();

    my $range = new Chart::Clicker::Data::Range();
    foreach my $ds (@{ $datasets }) {
        $range->add($ds->combined_range());
        if(!defined($self->{'KEYCOUNT'})) {
            $self->{'KEYCOUNT'} = $ds->max_key_count();
        } else {
            if($self->{'KEYCOUNT'} < $ds->max_key_count()) {
                $self->{'KEYCOUNT'} = $ds->max_key_count();
            }
        }
    }


    # foreach my $ds (@{ $datasets }) {
    #     $self->{'SCOUNT'} += scalar(@{ $ds->series() });
    # }

    $self->{'COMBINED_RANGE'} = $range;
    $self->{'INDEX_HEIGHT'};

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

    my $height = $self->height();
    my $width = $self->width();

    # my $xper = $domain->per();
    # my $yper = $range->per();

    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };

    my $color = $clicker->color_allocator->next();

    my $padding = $self->get_option('padding');
    unless($padding) {
        $padding = 1;
    }

    my $xper = $self->width() / ($self->{'KEYCOUNT'});
    print "$xper\n";
    print $domain->per()."\n";

    my $stroke = $self->get_option('stroke');

    # Calculate the bar width we can use to fit all the datasets.
    # my $bwidth = int(($width / scalar(@vals)) / $self->dataset_count());
    my $bwidth = int(($width / scalar(@vals)));

    # If there's a stroke we need to trim some space off for it.
    if(defined($stroke)) {
        $bwidth -= $stroke->width();
    }

    #$range->range($self->{'COMBINED_RANGE'});
    #$range->per($self->height() / $self->{'COMBINED_RANGE'}->span());
    # $self->per($self->height() / $self->range->span());

    my $sksent = $series->key_count() - 1;
    for(0..$sksent) {
        # Add the series_count times the width to so that each bar
        # gets rendered with it's partner in the other series.
        # my $x = $domain->mark($keys[$_]) + ($self->{'SCOUNT'} * $bwidth);
        #my $x = $domain->mark($keys[$_]) + $bwidth;
        print $vals[$_]."\n";
        my $x = ($xper * ($keys[$_] - $domain->range->lower())) + ($bwidth);

        my $y;
        #print $vals[$_].", ";
        # if(defined($self->{'INDEX_HEIGHT'}->{$_})) {
        #     $y = int($height - $range->mark($vals[$_]) - $self->{'INDEX_HEIGHT'}->{$_});
        # } else {
            $y = int($height - $range->mark($vals[$_]));
#        }
        # $cr->rectangle(
        #     $x + $padding / 2, $y,
        #     - $bwidth, $height,
        # );

        $cr->rectangle(
            $x, $y,
            - $bwidth, $height,
        );


        #$self->{'INDEX_HEIGHT'}->{$_} += $y;
    }

    my $opac = $self->get_option('opacity');
    my $fillcolor;
    if($opac) {
        $fillcolor = $color->clone();
        $fillcolor->alpha($opac);
    } else {
        $fillcolor = $color;
    }

    $cr->set_source_rgba($fillcolor->rgba());
    $cr->fill_preserve();

    # my $stroke = $self->get_option('stroke');
    if(defined($stroke)) {
        $cr->set_line_width($stroke->width());
        $cr->set_line_cap($stroke->line_cap());
        $cr->set_line_join($stroke->line_join());

        $cr->set_source_rgba($color->rgba());
        $cr->stroke();
    }

    $self->{'SCOUNT'}++;

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::StackedBar

=head1 DESCRIPTION

Chart::Clicker::Renderer::StackedBar renders nothing, because it doesn't
work yet.

=head1 SYNOPSIS

  my $br = new Chart::Clicker::Renderer::Bar({});

=head1 OPTIONS

=over 4

=item stroke

A stroke to use on each bar.

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
