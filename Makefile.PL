# $Id$

use strict;
use lib './t/lib';
use ExtUtils::MakeMaker;

my %prereq_pm = (
    'CGI::Session'       => 4.00,
    'Test::More'         => undef,
    'Redis'              => undef,
);

WriteMakefile(
    NAME            => 'CGI::Session::Driver::redis',
    VERSION_FROM    => 'lib/CGI/Session/Driver/redis.pm',
    PREREQ_PM       => \%prereq_pm,
    ABSTRACT        => 'Persistent session data in CGI applications',
    AUTHOR          => 'Steve Kemp <steve@steve.org.uk>',
#    clean           => { FILES => [ 't/cgisess.*', 't/sessiondata' ] },
);


package MY;
use strict;

sub postamble {
    return <<'MAKE_TEXT';
prepare_dist ::	metafile manifest dist
	$(NOECHO) $(NOOP)
MAKE_TEXT
}

sub libscan {
    my ($self, $path) = @_;
    return '' if $path =~ m/\.svn/;
    return $path;
}

