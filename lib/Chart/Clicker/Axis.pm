package Chart::Clicker::Axis;
use strict;
use warnings;

use base 'Chart::Clicker::Drawing::Component';
__PACKAGE__->mk_accessors(
    qw(
        font format label orientation per position range show_ticks stroke
        tick_length tick_stroke tick_values ticks visible
    )
);

use constant PI => 4 * atan2 1, 1;

use Chart::Clicker::Data::Range;
use Chart::Clicker::Drawing qw(:positions);
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Font;
use Chart::Clicker::Drawing::Stroke;

sub new {
    my $proto = shift();
    my $self = $proto->SUPER::new(@_);

    unless(defined($self->show_ticks())) {
        $self->show_ticks(1);
    }
    unless(defined($self->font())) {
        $self->font(
            new Chart::Clicker::Drawing::Font()
        );
    }
    unless(defined($self->tick_length())) {
        $self->tick_length(3);
    }
    unless(defined($self->ticks())) {
        $self->ticks(5);
    }
    unless(defined($self->visible())) {
        $self->visible(1);
    }
    unless(defined($self->color())) {
        $self->color(
            new Chart::Clicker::Drawing::Color({
                red => 0, green => 0, blue => 0, alpha => 1
            })
        );
    }
    unless(defined($self->stroke())) {
        $self->stroke(
            new Chart::Clicker::Drawing::Stroke()
        );
    }
    unless(defined($self->tick_stroke())) {
        $self->tick_stroke(
            new Chart::Clicker::Drawing::Stroke()
        );
    }
    unless(defined($self->range())) {
        $self->range(new Chart::Clicker::Data::Range());
    }

    return $self;
}

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    if($self->range->span() == 0) {
        die('This axis has a span of 0, that\'s fatal!');
    }

    unless(defined($self->tick_values())) {
        $self->tick_values($self->range->divvy($self->ticks() + 1));
    }

    my $cairo = $clicker->context();

    my $font = $self->font();

    $cairo->set_font_size($font->size());
    $cairo->select_font_face(
        $font->face(), $font->slant(), $font->weight()
    );

    # Determine all this once... much faster.
    my $biggest = 0;
    my $key;
    if($self->visible()) {
        if($self->orientation() == $CC_HORIZONTAL) {
            $key = 'height';
        } else {
            $key = 'width';
        }
        my @values = @{ $self->tick_values() };
        for(0..scalar(@values) - 1) {
            my $val = $self->format_value($values[$_]);
            my $ext = $cairo->text_extents($val);
            $self->{'ticks_extents_cache'}->[$_] = $ext;
            if($ext->{$key} > $biggest) {
                $biggest = $ext->{$key};
            }
        }

        if($self->show_ticks()) {
            $biggest += $self->tick_length();
        }
    }

    if ($self->label()) {
        my $ext = $cairo->text_extents($self->label());
        $self->{'label_extents_cache'} = $ext;
      }

    if($self->orientation() == $CC_HORIZONTAL) {
        my $label_height = $self->label()
            ? $self->{'label_extents_cache'}->{'height'} + 3
            : 0;
        $self->height($biggest + $label_height + 4);
        $self->width($dimension->width());
        $self->per($self->width() / $self->range->span());
    } else {
        # The label will be rotated, so use height here too.
        my $label_width = $self->label()
            ? $self->{'label_extents_cache'}->{'height'} + 3
            : 0;
        $self->width($biggest + $label_width + 4);
        $self->height($dimension->height());
        $self->per($self->height() / $self->range->span());
    }

    return 1;
}

sub mark {
    my $self = shift();
    my $value = shift();

    # 'caching' this here speeds things up.  Calling after changing the
    # range would result in a messed up chart anyway...
    if(!defined($self->{'LOWER'})) {
        $self->{'LOWER'} = $self->range->lower();
    }
    # This is rounded and .5'ed to get the lines nice and sharp for Cairo.
    return int($self->per() * ($value - $self->{'LOWER'})) + .5;
}

sub draw {
    my $self = shift();
    my $clicker = shift();

    unless($self->visible()) {
        return;
    }
    my $x = 0;
    my $y = 0;

    my $orient = $self->orientation();
    my $pos = $self->position();
    my $width = $self->width();
    my $height = $self->height();

    if($pos == $CC_LEFT) {
        $x += $width - .5;
    } elsif($pos == $CC_RIGHT) {
        $x += .5;
    } elsif($pos == $CC_TOP) {
        $y += $height - .5;
    } else {
        $y += .5;
    }

    my $surf = $self->SUPER::draw($clicker);
    my $cr = Cairo::Context->create($surf);

    my $stroke = $self->stroke();
    $cr->set_line_width($stroke->width());
    $cr->set_line_cap($stroke->line_cap());
    $cr->set_line_join($stroke->line_join());

    my $font = $self->font();
    $cr->set_font_size($font->size());
    $cr->select_font_face(
        $font->face(), $font->slant(), $font->weight()
    );

    my $tick_length = $self->tick_length();
    my $per = $self->per();

    my $lower = $self->range->lower();

    $cr->move_to($x, $y);
    if($orient == $CC_HORIZONTAL) {
        # Draw a line for our axis
        $cr->line_to($x + $width, $y);

        my @values = @{ $self->tick_values() };
        # Draw a tick for each value.
        for(0..scalar(@values) - 1) {
            my $val = $values[$_];
            # Grab the extent from the cache.
            my $ext = $self->{'ticks_extents_cache'}->[$_];
            my $ix = int($x + ($val - $lower) * $per) + .5;
            $cr->move_to($ix, $y);
            if($pos == $CC_TOP) {
                $cr->line_to($ix, $y - $tick_length);
                $cr->rel_move_to(-($ext->{'width'} / 1.8), -2);
            } else {
                $cr->line_to($ix, $y + $tick_length);
                $cr->rel_move_to(-($ext->{'width'} / 2), $ext->{'height'} + 2);
            }
            $cr->show_text($self->format_value($val));
        }

        # Draw the label
        if($self->label()) {
            my $ext = $self->{'label_extents_cache'};
            if ($pos == $CC_BOTTOM) {
                $cr->move_to(($width - $ext->{'width'}) / 2, $height);
            } else {
                $cr->move_to(($width - $ext->{'width'}) / 2, $ext->{'height'} + 2);
            }
            $cr->show_text($self->label());
        }

    } else {
        $cr->line_to($x, $y + $height);

        my @values = @{ $self->tick_values() };
        for(0..scalar(@values) - 1) {
            my $val = $values[$_];
            my $iy = int($y + $height - (($val - $lower) * $per)) + .5;
            my $ext = $self->{'ticks_extents_cache'}->[$_];
            $cr->move_to($x, $iy);
            if($self->position() == $CC_LEFT) {
                $cr->line_to($x - $tick_length, $iy);
                $cr->rel_move_to(-$ext->{'width'} - 2, $ext->{'height'} / 2);
            } else {
                $cr->line_to($x + $tick_length, $iy);
                $cr->rel_move_to(0, $ext->{'height'} / 2);
            }
            $cr->show_text($self->format_value($val));
        }

        # Draw the label
        if($self->label()) {
            my $ext = $self->{'label_extents_cache'};
            if ($pos == $CC_LEFT) {
                $cr->move_to($ext->{'height'}, ($height + $ext->{'width'}) / 2);
                $cr->rotate(3*PI/2);
            } else {
                $cr->move_to($width - $ext->{'height'}, ($height - $ext->{'width'}) / 2);
                $cr->rotate(PI/2);
            }
            $cr->show_text($self->label());
        }
    }

    $cr->set_source_rgba($self->color->rgba());
    $cr->stroke();

    return $surf;
}

sub format_value {
    my $self = shift;
    my $value = shift;

    if($self->format()) {
        return sprintf($self->format(), $value);
    }
    return $value;
}

1;
__END__

=head1 NAME

Chart::Clicker::Axis

=head1 DESCRIPTION

Chart::Clicker::Axis represents the plot of the chart.

=head1 SYNOPSIS

  use Chart::Clicker::Axis;
  use Chart::Clicker::Drawing qw(:positions);
  use Chart::Clicker::Drawing::Color;
  use Chart::Clicker::Drawing::Font;
  use Chart::Clicker::Drawing::Stroke;

  my $axis = new Chart::Clicker::Axis({
    color => new Chart::Clicker::Drawing::Color({ name => 'black' }),
    font  => new Chart::Clicker::Drawing::Font(),
    orientation => $CC_VERTICAL,
    position => $CC_LEFT,
    show_ticks => 1,
    stroke = new Chart::Clicker::Drawing::Stroke(),
    tick_length => 2,
    tick_stroke => new Chart::Clicker::Drawing::Stroke(),
    visible => 1,
  });

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Axis->new()

Creates a new Chart::Clicker::Axis.  If no arguments are given then sane
defaults are chosen.

=back

=head2 Class Methods

=over 4

=item color

Set/Get the color of the axis.

=item font

Set/Get the font used for the axis' labels.

=item format

Set/Get the format to use for the axis values.  The format is applied to each
value 'tick' via sprintf().  See sprintf()s perldoc for details!  This is
useful for situations where the values end up with repeating decimals.

=item height

Set/Get the height of the axis.

=item label

Set/Get the label of the axis.

=item orientation

Set/Get the orientation of this axis.

=item per

Set/Get the 'per' value for the axis.  This is how many physical pixels a unit
on the axis represents.  If the axis represents a range of 0-100 and the axis
is 200 pixels high then the per value will be 2.

=item position

Set/Get the position of the axis on the chart.

=item range

Set/Get the Range for this axis.

=item show_ticks

Set/Get the show ticks flag.

=item stroke

Set/Get the stroke for this axis.

=item tick_length

Set/Get the tick length

=item tick_stroke

Set/Get the stroke for the tick markers.

=item tick_values

Set/Get the arrayref of values show as ticks on this Axis.

=item ticks

Set/Get the number of 'ticks' to show.  Setting this will divide the
range on this axis by the specified value to establish tick values.

=item mark

Given a value, returns it's position on this axis.

=item format_value

Given a value, returns it formatted using this Axis' formatter.

=item examine_values

Gives the axis an opportunity to examine values.

=item prepare

Prepare this Axis by determining the size required.  If the orientation is
CC_HORIZONTAL this method sets the height.  Otherwise sets the width.

=item draw

Draw this axis.

=item visible

Set/Get this axis visibility flag.

=item width

Set/Get this axis' width.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
