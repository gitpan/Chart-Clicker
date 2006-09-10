package Chart::Clicker::Renderer::Base;
use strict;
use warnings;

use base 'Chart::Clicker::Drawing::Component';
__PACKAGE__->mk_accessors( qw(options dataset_count) );

sub get_option {
    my $self = shift();
    my $key = shift();

    if(defined($self->options())) {
        return $self->options()->{$key};
    }

    return;
}

sub prepare {
    my $self = shift();
    my $clicker = shift();
    my $dimension = shift();

    $self->width($dimension->width());
    $self->height($dimension->height());

    return 1;
}

## no critic
sub render {
    die('Override me.');
}
## use critic

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Base

=head1 DESCRIPTION

Chart::Clicker::Renderer::Base represents the plot of the chart.

=head1 SYNOPSIS

  my $renderer = new Chart::Clicker::Renderer::Foo();

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

=item prepare

Prepare the component.

=item render

Render the series.

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.
