package Chart::Clicker::Decoration::Legend;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(border font insets item_insets legend_items orientation tallest widest)
);

use Chart::Clicker::Log;

use Chart::Clicker::Decoration::LegendItem;

use Chart::Clicker::Drawing qw(:common);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Font;
use Chart::Clicker::Drawing::Insets;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Legend');

=head1 NAME

Chart::Clicker::Decoration::Legend

=head1 DESCRIPTION

Chart::Clicker::Decoration::Legend draws a legend on a Chart.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new()

Creates a new Legend object.

=back

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);
    unless(defined($self->border())) {
        $self->border(new Chart::Clicker::Drawing::Border());
    }
    unless(defined($self->font())) {
        $self->font(new Chart::Clicker::Drawing::Font());
    }
    unless(defined($self->insets())) {
        $self->insets(new Chart::Clicker::Drawing::Insets({
            top => 0, left => 0, bottom => 3, right => 3
        }));
    }
    unless(defined($self->item_insets())) {
        $self->item_insets(
            new Chart::Clicker::Drawing::Insets({
                top => 3, left => 3, bottom => 0, right => 0
            })
        );
    }
    unless(defined($self->orientation())) {
        $self->orientation($CC_HORIZONTAL)
    }

    return $self;
}

=head2 Class Methods

=over 4

=item $border = $l->border($border)

Set/Get this Legend's border.

=item $insets = $l->insets($insets)

Set/Get this Legend's insets.

=item $l->prepare($cairo, $color_allocator, \@datasets)

Prepare this Legend by creating the LegendItems based on the datasets
provided and testing the lengths of the series names.

=cut
sub prepare {
    my $self = shift();
    my $cr = shift();
    my $length = shift();
    my $coloralloc = shift();
    my $datasets = shift();

    unless(ref($datasets) eq 'ARRAY') {
        return;
    }

    my $font = $self->font();

    $cr->select_font_face($font->face(), $font->slant(), $font->weight());
    $cr->set_font_size($font->size());

    my $ii = $self->item_insets();

    my $count = 0;
    my $long = 0;
    my $tall = 0;
    my @items;
    foreach my $ds (@{ $datasets }) {
        foreach my $s (@{ $ds->series() }) {

            my $label = $s->name();
            unless(defined($label)) {
                $label = "Series $count";
            }
            my $extents = $cr->text_extents($label);
            if($long < $extents->{'width'}) {
                $long = $extents->{'width'};
            }
            if($tall < $extents->{'height'}) {
                $tall = $extents->{'height'};
            }
            push(@items, new Chart::Clicker::Decoration::LegendItem({
                color   => $coloralloc->next(),
                font    => $font,
                insets  => $ii,
                label   => $label
            }));
            $count++;
        }
    }

    $self->widest($long);
    $self->tallest($tall);

    $self->legend_items(\@items);

    my $per;
    my $insets;
    my $biggest;
    if($self->orientation() == $CC_HORIZONTAL) {
        $biggest = $self->widest();
        # Calculate the maximum width needed for a 'cell'
        $per = int($length / ($long + $ii->left() + $ii->right()));
        $insets = $self->insets()->top() + $self->insets()->bottom();
    } else {
        $biggest = $self->tallest();
        # Calculate the maximum height needed for a 'cell'
        $per = int($length / ($tall + $ii->top() + $ii->bottom()));
        $insets = $self->insets()->right() + $self->insets()->left();
    }
    if($per < 1) {
        $per = 1;
    }
    my $rows = $count / $per;
    if($rows != int($rows)) {
        $rows = int($rows) + 1;
    }

    return (
        # The number of rows we need
        $rows
        # The 'biggest' row (longest or tallest, depending on orientation)
        * ($tall + $ii->top() + $ii->bottom())
        # and finally our inse
        + $insets
    );
}

sub draw {
    my $self = shift();
    my $width = shift();
    my $height = shift();

    my $surface = Cairo::ImageSurface->create('argb32', $width, $height);
    my $cr = Cairo::Context->create($surface);

    $cr->set_source_rgba(0, 0, 0, 1);
    $cr->rectangle(.5, .5, $width - 1, $height - 1);
    $cr->set_line_width(1);
    $cr->stroke();

    $cr->select_font_face($self->font->face(), $self->font->slant(), $self->font->weight());
    $cr->set_font_size($self->font->size());

    $log->debug('Tallest is '.$self->tallest());

    my $x = 0 + $self->insets->left();
    # This will break if there are no items...
    # Start at the top + insets...
    my $y = 0 + $self->insets->top()
        + $self->legend_items()->[0]->insets()->top();;
    foreach my $item (@{ $self->legend_items() }) {
        $x += $item->insets()->left();

        my $extents = $cr->text_extents($item->label());

        # This item's label might not be as tall as the tallest one we will
        # draw, so we must center this item in the available space.
        my $center = ($self->tallest() - $extents->{'height'}) / 2;
        $cr->move_to($x, $y + $extents->{'height'} + $center);
        $cr->text_path($item->label());
        $cr->set_source_rgba(0, 0, 0, 1);
        $cr->fill();
        if(($x + $self->widest()) < $width) {
            # No need to wrap.
            $x += $self->widest() + $item->insets()->right();
        } else {
            # Wrap!  Honor insets...
            $x = $self->insets()->left();
            $y += $self->tallest() + $item->insets()->bottom()
                + $item->insets()->top();
        }
    }

    return $surface;
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
