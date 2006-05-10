package Chart::Clicker::Renderer::Base;
use strict;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(
    qw(options)
);

=head1 NAME

Chart::Clicker::Renderer::Base

=head1 DESCRIPTION

Chart::Clicker::Renderer::Base represents the plot of the chart.

=head1 SYNOPSIS

=cut

use Chart::Clicker::Log;

my $log = Chart::Clicker::Log->get_logger('Chart::Clicker::Renderer::Base');

our $RANGE = 0;
our $DOMAIN = 1;

=head1 METHODS

=head2 Constructor

=over 4

=item Chart::Clicker::Renderer::Base->new();

Creates a new Chart::Clicker::Renderer::Base.

=back

=head2 Class Methods

=over 4

=item $foo = get_option('foo)

Returns a value (if it exists) from the options hashref.

=cut
sub get_option {
    my $self = shift();
    my $key = shift();

    if(defined($self->options())) {
        return $self->options()->{$key};
    }
}


=item $image = $r->render($series)

Render the series.

=cut
sub render {
    die('Override me.');
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@onemogin.com>

=head1 SEE ALSO

perl(1)

=cut

1;
