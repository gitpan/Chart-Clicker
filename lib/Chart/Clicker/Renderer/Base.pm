package Chart::Clicker::Renderer::Base;
use strict;

use base 'Chart::Clicker::Drawing::Component';
__PACKAGE__->mk_accessors(
    qw(options)
);

=head1 NAME

Chart::Clicker::Renderer::Base

=head1 DESCRIPTION

Chart::Clicker::Renderer::Base represents the plot of the chart.

=head1 SYNOPSIS

=cut

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Chart::Clicker::Renderer::Base.

=back

=head2 Class Methods

=over 4

=item get_option

Returns a value for the specified key (if it exists) from the options hashref.

=cut
sub get_option {
    my $self = shift();
    my $key = shift();

    if(defined($self->options())) {
        return $self->options()->{$key};
    }
}

=item prepare

Prepare the component.

=cut
sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());
}

=item render

Render the series.

=cut
sub render {
    die('Override me.');
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=cut

1;
