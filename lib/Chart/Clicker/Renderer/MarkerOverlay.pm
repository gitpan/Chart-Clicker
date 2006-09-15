package Chart::Clicker::Renderer::Marker;
use strict;
use warnings;

use Chart::Clicker::Renderer::Base;
use base 'Chart::Clicker::Renderer::Base';

sub render {
    my $self = shift();
    my $clicker = shift();
    my $cr = shift();
    my $series = shift();
    my $domain = shift();
    my $range = shift();

    my $width = $domain->width();
    my $height = $range->height();

    my $shape = new Chart::Clicker::Shape::Arc({
        radius  => 3,
        angle1  => 0,
        angle2  => 360
    });
    my $color = new Chart::Clicker::Drawing::Color({
        red     => 1.0,
        green   => 1.0,
        blue    => 1.0,
        alpha   => 0
    });

    my @vals = @{ $series->values() };
    my @keys = @{ $series->keys() };
    for(0..($series->key_count() - 1)) {
        my $x = $domain->mark($keys[$_]);
        my $y = $height - $range->mark($vals[$_]);

        if($x && $y) {
            $cr->move_to($x, $y);
            $shape->create_path($cr, $x, $y);
        } elsif($x) {
        } elsif($y) {
        }
    }

    $cr->set_source_rgba($color->rgba());
    $cr->fill();

    return 1;
}

1;
__END__

=head1 NAME

Chart::Clicker::Renderer::Marker

=head1 DESCRIPTION

Chart::Clicker::Renderer::Marker renders markers, not data.

=head1 SYNOPSIS

  my $mr = new Chart::Clicker::Renderer::Marker();

=head1 METHODS

=head2 Class Methods

=over 4

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
