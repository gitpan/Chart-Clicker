package Chart::Clicker::Axis;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(
        color font height label orientation per position range show_ticks stroke
        tick_length tick_stroke tick_values visible width
    )
);

use Chart::Clicker::Data::Range;
use Chart::Clicker::Drawing qw(:common);
use Chart::Clicker::Drawing::Color;
use Chart::Clicker::Drawing::Font;
use Chart::Clicker::Drawing::Stroke;

=head1 NAME

Chart::Clicker::Axis

=head1 DESCRIPTION

Chart::Clicker::Axis represents the plot of the chart.

=head1 SYNOPSIS

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Axis->new()

Creates a new Chart::Clicker::Axis.

=back

=cut
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
    $self->range(new Chart::Clicker::Data::Range());


    return $self;
}

=head2 Class Methods

=over 4

=item label()

Set/Get the label of the axis.

=item length()

Set/Get the physical length of this axis in the chart.

=item range()

Set/Get the Range for this axis.

=item show_ticks()

Set/Get the show ticks flag

=item tick_length()

Set/Get the tick length

=item tick_values()

Set/Get the arrayref of values show as ticks on this Axis.

=item visible()

Set/Get this Axis' visibility

=item prepare()

Prepare this Axis by determining the size required.  If the orientation is
CC_HORIZONTAL this method sets the height.  Otherwise sets the width.

=cut
sub prepare {
    my $self = shift();
    my $cairo = shift();

    unless($self->visible()) {
        return;
    }

    $cairo->set_font_size($self->font()->size());
    $cairo->select_font_face(
        $self->font()->face(), $self->font()->slant(), $self->font()->weight()
    );

    # Determine all this once... much faster.
    my $biggest = 0;
    my $key;
    if($self->orientation() == $CC_HORIZONTAL) {
        $key = 'height';
    } else {
        $key = 'width';
    }
    my $vi = 0;
    foreach my $val (@{ $self->tick_values() }) {
        my $ext = $cairo->text_extents($val);
        $self->{'extents_cache'}->[$vi] = $ext;
        if($ext->{$key} > $biggest) {
            $biggest = $ext->{$key};
        }
        $vi++;
    }

    if($self->show_ticks()) {
        $biggest += $self->tick_length();
    }

    if($self->orientation() == $CC_HORIZONTAL) {
        $self->height($biggest);
    } else {
        $self->width($biggest);
    }
}

sub render {
    my $self = shift();
    my $cr = shift();
    my $x = shift();
    my $y = shift();

    $cr->set_line_width($self->stroke()->width());
    $cr->set_line_cap($self->stroke()->line_cap());
    $cr->set_line_join($self->stroke()->line_join());

    $cr->set_font_size($self->font()->size());
    $cr->select_font_face(
        $self->font()->face(), $self->font()->slant(), $self->font()->weight()
    );

    $cr->move_to($x, $y);
    if($self->orientation() == $CC_HORIZONTAL) {
        # Draw a line for our axis
        $cr->line_to($x + $self->width(), $y);

        # Draw the 0th tick mark.
        $cr->move_to($x, $y);
        if($self->position() == $CC_TOP) {
            $cr->line_to($x, $y - $self->tick_length());
        } else {
            $cr->line_to($x, $y + $self->tick_length());
        }

        # Draw a tick for each value.
        my $vi = 0;
        foreach my $val (@{ $self->tick_values() }) {
            # Grab the extent from the cache.
            my $ext = $self->{'extents_cache'}->[$vi];
            my $ix = $x + int($val * $self->per());
            $cr->move_to($ix, $y);
            if($self->position() == $CC_TOP) {
                $cr->line_to($ix, $y - $self->tick_length());
                $cr->rel_move_to(-($ext->{'width'} / 1.8), $ext->{'height'});
            } else {
                $cr->line_to($ix, $y + $self->tick_length());
                # I have NO idea why I had to use 1.8 instead of 2 here...
                $cr->rel_move_to(-($ext->{'width'} / 1.8), $ext->{'height'});
            }
            $cr->show_text($val);
            $vi++;
        }

        # Draw the final tick mark.
        $cr->move_to($x + $self->width(), $y);
        if($self->position() == $CC_TOP) {
            $cr->line_to($x + $self->width(), $y - $self->tick_length());
        } else {
            $cr->line_to($x + $self->width(), $y + $self->tick_length());
        }

    } else {
        $cr->line_to($x, $y + $self->height());

        $cr->move_to($x, $y);
        if($self->position() == $CC_LEFT) {
            $cr->line_to($x - $self->tick_length(), $y);
        } else {
            $cr->line_to($x + $self->tick_length(), $y);
        }
        my $vi = 0;
        foreach my $val (@{ $self->tick_values() }) {
            my $iy = $y + $self->height() - ($val * $self->per());
            my $ext = $self->{'extents_cache'}->[$vi];
            $cr->move_to($x, $iy);
            if($self->position() == $CC_LEFT) {
                $cr->line_to($x - $self->tick_length(), $iy);
                $cr->rel_move_to(-$ext->{'width'}, $ext->{'height'} / 2);
            } else {
                $cr->line_to($x + $self->tick_length(), $iy);
                $cr->rel_move_to(-$ext->{'width'}, $ext->{'height'} / 2);
            }
            $cr->show_text($val);
            $vi++;
        }

        $cr->move_to($x, $self->height() + $y);
        if($self->position() == $CC_LEFT) {
            $cr->line_to($x - $self->tick_length(), $self->height() + $y);
        } else {
            $cr->line_to($x + $self->tick_length(), $self->height() + $y);
        }
    }



    $cr->set_source_rgba($self->color()->rgba());
    $cr->stroke();
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut
1;
