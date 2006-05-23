package Chart::Clicker::Drawing::Component;
use strict;

use Chart::Clicker::Drawing::Dimension;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(
        background_color border color height insets location width
    )
);

use Cairo;

=head1 NAME

Chart::Clicker::Drawing::Component

=head1 DESCRIPTION

A Component is an entity with a graphical representation.

=head1 SYNOPSIS

  my $c = new Chart::Clicker::Drawing::Component({
    location => new Chart::Clicker::Drawing::Point({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

  my $c = new Chart::Clicker::Drawing::Component({
    location => new Chart::Clicker::Drawing::Point({
        x => $x, y => $y
    }),
    width => 500, height => 350
  });

Creates a new Component.

=back

=cut
sub new {
    my $proto = shift();

    my $self = $proto->SUPER::new(@_);

    return $self;
}

=head2 Class Methods

=over 4

=item raw

Draw this component.

=cut
sub draw {
    my $self = shift();
    my $clicker = shift();

    my $surface = Cairo::ImageSurface->create(
        'argb32', $self->width(), $self->height()
    );
    my $context = Cairo::Context->create($surface);

    if(defined($self->background_color())) {
        $context->set_source_rgba($self->background_color()->rgba());
        $context->rectangle(0, 0, $self->width(), $self->height());
        $context->paint();
    }

    if(defined($self->border())) {
        my $border = $self->border();
        $context->set_source_rgba($border->color()->rgba());
        $context->set_line_width($border->stroke()->width());
        $context->set_line_cap($border->stroke()->line_cap());
        $context->set_line_join($border->stroke()->line_join());
        $context->new_path();
        my $swhalf = $border->stroke()->width() / 2;
        $context->rectangle(
            0, 0,
            $self->width() - $swhalf, $self->height() - $swhalf
        );
        $context->stroke();
    }

    return $surface;
}

=item inside_width

Get the width available in this container after taking away space for
insets and borders.

=cut
sub inside_width {
    my $self = shift();

    my $w = $self->width();

    if(defined($self->insets())) {
        $w -= $self->insets()->left() + $self->insets()->right()
    }
    if(defined($self->border())) {
        $w -= $self->border()->stroke()->width() * 2;
    }

    return $w;
}

=item inside_dimension

Get the dimension of this container's inside.

=cut
sub inside_dimension {
    my $self = shift();

    return new Chart::Clicker::Drawing::Dimension({
        width   => $self->inside_width(),
        height  => $self->inside_height()
    });
}

=item inside_height

Get the height available in this container after taking away space for
insets and borders.

=cut
sub inside_height {
    my $self = shift();

    my $h = $self->height();
    if(defined($self->insets())) {
        $h -= $self->insets()->bottom() + $self->insets()->top();
    }
    if(defined($self->border())) {
        $h -= $self->border()->stroke()->width() * 2;
    }

    return $h;
}

=item height

Set/Get this Component's height

=item location

Set/Get this Component's location

=item width

Set/Get this Component's height

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut
1;
