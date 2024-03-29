package Chart::Clicker::Decoration::Grid;
$Chart::Clicker::Decoration::Grid::VERSION = '2.88';
use Moose;

extends 'Graphics::Primitive::Canvas';

with 'Graphics::Primitive::Oriented';

# ABSTRACT: Under-data grid

use Graphics::Color::RGB;


has '+background_color' => (
    default => sub {
        Graphics::Color::RGB->new(
            red => 0.9, green => 0.9, blue => 0.9, alpha => 1
        )
    }
);


has 'clicker' => ( is => 'rw', isa => 'Chart::Clicker' );


has 'domain_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => .75, green => .75, blue => .75, alpha => 1
            ),
            width => 1
        )
    }
);


has 'range_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
    default => sub {
        Graphics::Primitive::Brush->new(
            color => Graphics::Color::RGB->new(
                red => .75, green => .75, blue => .75, alpha => 1
            ),
            width => 1
        )
    }
);


has 'show_domain' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);


has 'show_range' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);


override('finalize', sub {
    my $self = shift;

    return unless ($self->show_domain || $self->show_range);

    my $clicker = $self->clicker;

    my $dflt = $clicker->get_context('default');
    my $daxis = $dflt->domain_axis;
    my $raxis = $dflt->range_axis;

    if($self->show_domain) {
        $self->draw_lines($daxis);
        my $dop = Graphics::Primitive::Operation::Stroke->new;
        $dop->brush($self->domain_brush);
        $self->do($dop);
    }

    if($self->show_range) {
        $self->draw_lines($raxis);
        my $rop = Graphics::Primitive::Operation::Stroke->new;
        $rop->brush($self->range_brush);
        $self->do($rop);
    }
});


sub draw_lines {
    my ($self, $axis) = @_;

    my $height = $self->height;
    my $width = $self->width;

    if($axis->is_horizontal) {

        foreach my $val (@{ $axis->tick_values }) {
            my $mark = $axis->mark($width, $val);
            # Don't try and draw a mark if the Axis wouldn't give us a value,
            # it might be skipping...
            next unless defined($mark);
            $self->move_to($mark, 0);
            $self->rel_line_to(0, $height);
        }
    } else {

        foreach my $val (@{ $axis->tick_values }) {
            my $mark = $axis->mark($height, $val);
            # Don't try and draw a mark if the Axis wouldn't give us a value,
            # it might be skipping...
            next unless defined($mark);
            $self->move_to(0, $height - $mark);
            $self->rel_line_to($width, 0);
        }
    }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

__END__

=pod

=head1 NAME

Chart::Clicker::Decoration::Grid - Under-data grid

=head1 VERSION

version 2.88

=head1 DESCRIPTION

Generates a collection of Markers for use as a background.

=head1 ATTRIBUTES

=head2 background_color

Set/Get the background L<color|Graphics::Color::RGB> for this Grid.

=head2 border

Set/Get the L<border|Graphics::Primitive::Border> for this Grid.

=head2 color

Set/Get the L<color|Graphics::Color::RGB> for this Grid.

=head2 domain_brush

Set/Get the L<brush|Graphics::Primitive::Brush> for inking the domain markers.

=head2 range_brush

Set/Get the L<brush|Graphics::Primitive::Brush> for inking the range markers.

=head2 show_domain

Flag to show or not show the domain lines.

=head2 show_range

Flag to show or not show the range lines.

=head2 stroke

Set/Get the Stroke for this Grid.

=head1 METHODS

=head2 draw_lines

Called by pack, draws the lines for a given axis.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Cold Hard Code, LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
