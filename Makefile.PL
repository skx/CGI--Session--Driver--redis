# $Id$

use strict;

use ExtUtils::MakeMaker;

my %prereq_pm = ( 'CGI::Session' => 4.00,
                  'Test::More'   => undef,
                  'Redis'        => undef,
                );


WriteMakefile(
    NAME         => 'CGI::Session::Driver::redis',
    VERSION_FROM => 'lib/CGI/Session/Driver/redis.pm',
    PREREQ_PM    => \%prereq_pm,
    ABSTRACT     => 'Persistent session data in CGI applications',
    AUTHOR       => 'Steve Kemp <steve@steve.org.uk>',

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
