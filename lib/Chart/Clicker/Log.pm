package Chart::Clicker::Log;
use strict;

use Log::Log4perl;

my $conf = q/
    log4perl.category.Chart = DEBUG, Screen
    log4perl.appender.Screen = Log::Log4perl::Appender::ScreenColoredLevels
    log4perl.appender.Screen.stderr = 1
    log4perl.appender.Screen.layout = Log::Log4perl::Layout::PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %p [%c : %L] %m%n
/;

Log::Log4perl->init(\$conf);

sub get_logger {
    my $self = shift();
    my $class = shift();

    return Log::Log4perl->get_logger($class);
}

1;
