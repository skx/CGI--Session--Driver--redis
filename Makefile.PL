# $Id$

use strict;

use ExtUtils::MakeMaker;



my %prereq_pm = (
                 'CGI::Session' => 4.00,
                 'Redis'        => 0,
                );

my %test_pm = (

               # solely for the test-suite.
               'Test::More'      => 0,
               'Test::Pod'       => 0,
               'Test::Strict'    => 0,
               'Test::Exception' => 0,
               'Test::NoTabs'    => 0,
              );


WriteMakefile(
    NAME         => 'CGI::Session::Driver::redis',
    VERSION_FROM => 'lib/CGI/Session/Driver/redis.pm',
    PREREQ_PM     => \%prereq_pm,
    TEST_REQUIRES => \%test_pm,
    ABSTRACT     => 'Persistent session data in CGI applications',
    AUTHOR       => 'Steve Kemp <steve@steve.org.uk>',
    LICENSE       => 'perl',

    META_MERGE => {
          resources => {
              license  => 'http://dev.perl.org/licenses/',
              homepage => 'https://github.com/skx/CGI--Session--Driver--redis/',
              bugtracker =>
                'https://github.com/skx/CGI--Session--Driver--redis/issues',
              repository =>
                'https://github.com/skx/CGI--Session--Driver--redis.git',
          },
    },
);
