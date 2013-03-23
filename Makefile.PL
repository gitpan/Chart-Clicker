
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Powerful, extensible charting.",
  "AUTHOR" => "Cory G Watson <gphat\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Test::Exception" => 0,
    "Test::Fatal" => 0,
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Chart-Clicker",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Chart::Clicker",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Load" => 0,
    "Color::Scheme" => 0,
    "DateTime" => 0,
    "DateTime::Set" => 0,
    "English" => 0,
    "Geometry::Primitive::Arc" => 0,
    "Geometry::Primitive::Circle" => 0,
    "Geometry::Primitive::Point" => 0,
    "Graphics::Color::RGB" => 0,
    "Graphics::Primitive::Border" => 0,
    "Graphics::Primitive::Brush" => 0,
    "Graphics::Primitive::Canvas" => 0,
    "Graphics::Primitive::Component" => 0,
    "Graphics::Primitive::Container" => 0,
    "Graphics::Primitive::Driver::Cairo" => 0,
    "Graphics::Primitive::Font" => 0,
    "Graphics::Primitive::Insets" => 0,
    "Graphics::Primitive::Operation::Fill" => 0,
    "Graphics::Primitive::Operation::Stroke" => 0,
    "Graphics::Primitive::Oriented" => 0,
    "Graphics::Primitive::Paint::Gradient::Linear" => 0,
    "Graphics::Primitive::Paint::Gradient::Radial" => 0,
    "Graphics::Primitive::Paint::Solid" => 0,
    "Graphics::Primitive::Path" => 0,
    "Graphics::Primitive::TextBox" => 0,
    "Layout::Manager::Absolute" => 0,
    "Layout::Manager::Axis" => 0,
    "Layout::Manager::Compass" => 0,
    "Layout::Manager::Flow" => 0,
    "Layout::Manager::Grid" => 0,
    "Layout::Manager::Single" => 0,
    "List::Util" => 0,
    "Math::Trig" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "POSIX" => 0,
    "Scalar::Util" => 0,
    "constant" => 0
  },
  "VERSION" => "2.85",
  "test" => {
    "TESTS" => "t/*.t t/series/*.t t/xt/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



