package Chart::Clicker::Decoration::Legend;
use strict;

use base 'Chart::Clicker::Drawing::Component';
__PACKAGE__->mk_accessors(
    qw(font item_insets legend_items orientation tallest widest)
);

use Chart::Clicker::Log;

use Chart::Clicker::Decoration::LegendItem;

use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Border;
use Chart::Clicker::Drawing::Font;
use Chart::Clicker::Drawing::Insets;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Decoration::Legend');

=head1 NAME

Chart::Clicker::Decoration::Legend

=head1 DESCRIPTION

Chart::Clicker::Decoration::Legend draws a legend on a Chart.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Legend object.

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

=back

=head2 Class Methods

=over 4

=item border

Set/Get this Legend's border.

=item insets

Set/Get this Legend's insets.

=item prepare

Prepare this Legend by creating the LegendItems based on the datasets
provided and testing the lengths of the series names.

=cut
sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    my $font = $self->font();

    my $cr = $clicker->context();
    $cr->save();

    $cr->select_font_face($font->face(), $font->slant(), $font->weight());
    $cr->set_font_size($font->size());

    my $ii = $self->item_insets();

    my $count = 0;
    my $long = 0;
    my $tall = 0;
    my @items;
    foreach my $ds (@{ $clicker->datasets() }) {
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
                color   => $clicker->color_allocator()->next(),
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
        $per = int($dimension->width() / ($long + $ii->left() + $ii->right()));
    } else {
        $biggest = $self->tallest();
        # Calculate the maximum height needed for a 'cell'
        $per = int($dimension->height() / ($tall + $ii->top() + $ii->bottom()));
    }
    if($per < 1) {
        $per = 1;
    }
    my $rows = $count / $per;
    if($rows != int($rows)) {
        $rows = int($rows) + 1;
    }

    $cr->restore();

    if($self->orientation() == $CC_HORIZONTAL) {
        $self->width($dimension->width());
        $self->height(
            # The number of rows we need
            $rows
            # The 'biggest' row (longest or tallest, depending on orientation)
            * ($self->tallest() + $ii->top() + $ii->bottom())
            # and finally our insets
            + $self->insets()->top() + $self->insets()->bottom()
        );
    } else {
        $self->height($dimension->height());
        $self->width(
            # The number of rows we need
            $rows
            # The 'biggest' row (longest or tallest, depending on orientation)
            * ($self->widest() + $ii->left() + $ii->right())
            # and finally our insets
            + $self->insets()->right() + $self->insets()->left()
        );
    }

    $log->debug('Dimension: '.$self->width().','.$self->height());
}

=item draw

Draw this Legend

=cut
sub draw {
    my $self = shift();
    my $clicker = shift();

    my $width = $self->width();
    my $height = $self->height();

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
        + $self->legend_items()->[0]->insets()->top();
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
        if(($x + $self->widest()) < ($width - $self->insets()->right())) {
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

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
