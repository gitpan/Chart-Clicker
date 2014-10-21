package Chart::Clicker::Decoration::Plot;
use Moose;

use Layout::Manager::Axis;
use Layout::Manager::Single;

use Chart::Clicker::Decoration::Grid;

# TODO READD THIS
#use Chart::Clicker::Decoration::MarkerOverlay;

# TODO MOve this class?  It's not decoration anymore.
extends 'Chart::Clicker::Container';

has 'clicker' => (
    is => 'rw',
    isa => 'Chart::Clicker',
);
has 'grid' => (
    is => 'rw',
    isa => 'Chart::Clicker::Decoration::Grid',
    default => sub {
        Chart::Clicker::Decoration::Grid->new( name => 'grid' )
    }
);
has '+layout_manager' => (
    default => sub { Layout::Manager::Axis->new }
);
has 'render_area' => (
    is => 'rw',
    isa => 'Chart::Clicker::Container',
    default => sub {
        Chart::Clicker::Container->new(
            name => 'render_area',
            layout_manager => Layout::Manager::Single->new
        )
    }
);

override('prepare', sub {
    my ($self) = @_;

    # TODO This is also happening in Clicker.pm
    foreach my $c (@{ $self->components }) {
        $c->clicker($self->clicker);
    }

    # TODO This is kinda messy...
    foreach my $c (@{ $self->render_area->components }) {
        $c->clicker($self->clicker);
    }

    super;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__

=head1 NAME

Chart::Clicker::Decoration::Plot - Area on which renderers draw

=head1 DESCRIPTION

A Component that handles the rendering of data via Renderers.  Also
handles rendering the markers that come from the Clicker object.

=head1 SYNOPSIS

=head1 ATTRIBUTES

=head2 background_color

Set/Get this Plot's background color.

=head2 border

Set/Get this Plot's border.

=head2 clicker

Set/Get this Plot's clicker instance.

=head2 markers

Set/Get the flag that determines if markers are drawn on this plot.

=head1 METHODS

=head2 new

Creates a new Plot object.

=head2 draw

Draw this Plot

=head2 grid

Set/Get the Grid component used on this plot.

=head2 layout

Set/Get this Plot's layout.  See L<Layout::Manager>.

=head2 prepare

Prepare this Plot by determining how much space it needs.

=head1 AUTHOR

Cory G Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
