use 5.008006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Chart::Clicker',
    VERSION_FROM      => 'lib/Chart/Clicker.pm', # finds $VERSION
    PREREQ_PM         =>
        {
            Cairo               => 0.92,
            'Class::Accessor'   => 0.25,
        },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Chart/Clicker.pm', # retrieve abstract from module
       AUTHOR         => "Cory 'G' Watson <gphat\@cpan.org>") : ()),
);
