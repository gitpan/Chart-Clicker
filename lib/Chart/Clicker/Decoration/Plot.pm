package Chart::Clicker::Decoration::Plot;
use Moose;

extends 'Chart::Clicker::Drawing::Component';

has 'renderers' => ( is => 'rw', isa => 'ArrayRef', default => sub { [ ] } );
has 'markers' => ( is => 'rw', isa => 'Bool', default => 1 );

use Chart::Clicker::Decoration::MarkerOverlay;
use Chart::Clicker::Drawing::Border;

sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);

    # TODO Fix this
    $self->{'DSRENDERERS'} = {};
    return $self;
}

sub set_renderer_for_dataset {
    my $self = shift();
    my $didx = shift();
    my $ridx = shift();

    $self->{'DSRENDERERS'}->{$didx} = $ridx;
    return 1;
}

sub get_renderer_for_dataset {
    my $self = shift();
    my $didx = shift();

    my $idx = $self->{'DSRENDERERS'}->{$didx};
    unless(defined($idx)) {
        $idx = 0;
    }

    return $idx;
}

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());

    my $idim = $self->inside_dimensions();

    my %dscount;
    my %rend_ds;
    my $count = 0;
    foreach my $dataset (@{ $clicker->datasets() }) {
        my $ridx = $self->get_renderer_for_dataset($count);
        $dscount{$ridx} += scalar(@{ $dataset->series() });
        push(@{ $rend_ds{$ridx} }, $dataset);
        $count++;
    }

    my $renderers = $self->renderers();
    $count = 0;
    foreach my $rend (@{ $self->renderers() }) {
        $rend->dataset_count($dscount{$count});
        $rend->prepare($clicker, $idim, $rend_ds{$count});
        $count++;
    }

    return 1;
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    my $surface = $self->SUPER::draw($clicker);
    my $cr = Cairo::Context->create($surface);

    my $rendsurface = Cairo::ImageSurface->create(
        'argb32', $self->inside_width(), $self->inside_height()
    );
    my $rcr = Cairo::Context->create($rendsurface);

    my $renderers = $self->renderers();

    my $count = 0;
    foreach my $dataset (@{ $clicker->datasets() }) {
        my $domain = $clicker->get_dataset_domain_axis($count);
        my $range = $clicker->get_dataset_range_axis($count);
        my $ridx = $self->get_renderer_for_dataset($count);
        my $rend = $renderers->[$ridx];

        foreach my $series (@{ $dataset->series() }) {
            $rcr->save();
            $rend->draw($clicker, $rcr, $series, $domain, $range);
            $rcr->restore();
        }
        $count++;
    }

    my $id = $self->inside_dimensions();
    if($self->markers()) {
        if(scalar(@{ $clicker->markers() })) {
            my $mo = new Chart::Clicker::Decoration::MarkerOverlay();
            $mo->prepare($clicker, $id);
            my $marksurf = $mo->draw($clicker);
            $rcr->set_source_surface($marksurf, 0, 0);
            $rcr->paint();
        }
    }

    my $ul = $self->upper_left_inside_point();
    $cr->set_source_surface($rendsurface, $ul->x(), $ul->y());
    $cr->paint();

    return $surface;
}

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Plot

=head1 DESCRIPTION

A Component that handles the rendering of data via Renderers.  Also
handles rendering the markers that come from the Clicker object.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Plot object.

=cut
=back

=head2 Class Methods

=over 4

=item border

Set/Get this Plot's border.

=item insets

Set/Get this Plot's insets.

=item markers

Set/Get the flag that determines if markers are drawn on this plot.

=item renderers

Set/Get this Plot's renderers. Uses an arrayref.

=item set_renderer_for_dataset

Sets the Renderer to be used for a particular DataSet.  Uses indices:

  my @renderers = ($line, $bar);
  $plot->renderers(\@renderers);
  $plot->set_renderer_for_dataset(0, 0); # dataset idx, renderer idx
  $plot->set_renderer_for_dataset(1, 1);

If no renderer is set for a dataset the zeroth one is used.  See
L<get_renderer_for_dataset>.

=item get_renderer_for_dataset

Get the index of the renderer that will be used for the DataSet at the
specified index.

=item prepare

Prepare this Plot by determining how much space it needs.

=item draw

Draw this Plot

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
