package Chart::Clicker::Renderer::Point;
use Moose;

extends 'Chart::Clicker::Renderer';

use Geometry::Primitive::Circle;
use Geometry::Primitive::Point;
use Graphics::Primitive::Operation::Fill;
use Graphics::Primitive::Paint::Solid;

has 'shape' => (
    is => 'rw',
    does => 'Geometry::Primitive::Shape',
    default => sub {
        Geometry::Primitive::Circle->new({
           radius => 3,
        });
    }
);
has 'shape_brush' => (
    is => 'rw',
    isa => 'Graphics::Primitive::Brush',
);

override('finalize', sub {
    my ($self) = @_;

    my $clicker = $self->clicker;

    my $width = $self->width;
    my $height = $self->height;

    my $dses = $clicker->get_datasets_for_context($self->context);
    foreach my $ds (@{ $dses }) {
        foreach my $series (@{ $ds->series }) {

            # TODO if undef...
            my $ctx = $clicker->get_context($ds->context);
            my $domain = $ctx->domain_axis;
            my $range = $ctx->range_axis;

            my $min = $range->range->lower;

            my $height = $self->height;

            my @vals = @{ $series->values };
            my @keys = @{ $series->keys };
            for(0..($series->key_count - 1)) {
                my $x = $domain->mark($width, $keys[$_]);
                next unless defined($x);
                my $ymark = $range->mark($height, $vals[$_]);
                next unless defined($ymark);
                my $y = $height - $ymark;

                $self->move_to($x, $y);
                $self->draw_point($x, $y, $series, $_);
            }
            my $op = Graphics::Primitive::Operation::Fill->new(
                paint => Graphics::Primitive::Paint::Solid->new(
                    color => $clicker->color_allocator->next
                )
            );
            if(defined($self->shape_brush)) {
                $op->preserve(1);
            }
            $self->do($op);

            if(defined($self->shape_brush)) {
                my $op3 = Graphics::Primitive::Operation::Stroke->new;
                $op3->brush($self->shape_brush->clone);
                $self->do($op3);
            }
        }
    }

    return 1;
});

sub draw_point {
    my ($self, $x, $y, $series, $count) = @_;

    my $shape = $self->shape->clone;
    $shape->origin(Geometry::Primitive::Point->new(x => $x, y => $y));
    $self->path->add_primitive($shape);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Point - Point renderer

=head1 DESCRIPTION

Chart::Clicker::Renderer::Point renders a dataset as points.

=begin HTML

<p><img src="http://www.onemogin.com/clicker/chart-clicker-examples/point/point.png" width="500" height="250" alt="Point Chart" /></p>

=end HTML

=head1 SYNOPSIS

  my $pr = Chart::Clicker::Renderer::Point->new({
    shape => Geometry::Primitive::Arc->new({
        angle1 => 0,
        angle2 => 180,
        radius  => 5
    })
  });

=head1 ATTRIBUTES

=head2 shape

Specify the shape to be used at each point.  Defaults to 360 degree arc with
a radius of 3.

=head2 shape_brush

Optionally provide a brush with with to stroke each point.

=head1 METHODS

=head2 new

Create a new Point renderer

=head2 draw_point

Called for each point.  Implemented as a separate method so that subclasses
such as Bubble may override the drawing.

=head2 render

Render the series.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
