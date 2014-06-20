package CGI::Session::Driver::redis;

use strict;
use warnings;

use Carp qw(croak);
use CGI::Session::Driver;

@CGI::Session::Driver::redis::ISA = ("CGI::Session::Driver");

use vars qw($VERSION);
our $VERSION = "0.3";


=pod

=head1 NAME

CGI::Session::Driver::redis - CGI::Session driver for redis

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Redis;

    my $redis = Redis->new();

    my $session = CGI::Session->new( "driver:redis", $sid, { Redis => $redis,
                                                             Expire => 60*60*24 } );


=head1 DESCRIPTION

This backend stores session data in a persistent redis server, with
the ability to specify an expiry time in seconds.


=head1 DRIVER ARGUMENTS

The following options may be passed to the constructor:

=over 4

=item C<Expiry>

Which is the time to expire the sessions, in seconds, in inactivity.
Supplying a value of "0" equates to never expiring sessions.

=item C<Prefix>

A string value to prefix to the session ID prior to redis
storage.  The default is "session".

=item C<Redis>

A Redis object which will be used to store the session data within.

=back

=head1 REQUIREMENTS

=over 4

=item L<CGI::Session>

=item L<Redis>

=back

=head1 AUTHOR

Steve Kemp <steve@steve.org.uk>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 Steve Kemp <steve@steve.org.uk>.

This library is free software. You can modify and or distribute it under
the same terms as Perl itself.

=cut


=head1 METHODS

=cut




=head2 init

Initialise our driver, ensuring we received a 'Redis' attribute.

=cut

sub init
{
    my $self = shift;
    unless ( defined $self->{ Redis } )
    {
        return $self->set_error("init(): 'Redis' attribute is required.");
    }

    return 1;
}



=head2 store

Generate a key, by joining a prefix and the session identifier, then
store the session underneath that key.

=cut

sub store
{
    my $self = shift;
    my ( $sid, $datastr ) = @_;
    croak "store(): usage error" unless $sid && $datastr;

    #
    # Get the prefix, and build a key
    #
    my $prefix = $self->{ 'Prefix' } || "session";
    my $key    = $prefix . ':' . $sid;

    #
    # redis doesn't like to have whitespace in the keys.
    #
    $key =~ s/[ \t\r\n]//g;

    #
    # Store in the server
    #
    $self->{ 'Redis' }->set( $key, $datastr );

    #
    #  Set the expiry time, in seconds, if present.
    #
    my $expire = $self->{'Expire'} || 0;
    if ( $expire && $expire > 0 )
    {
        $self->{ 'Redis' }->expire( $key, $expire );
    }
    return 1;
}



=head2 retrieve

Generate a key, by joining a prefix and the session identifier, then
return the session information stored under that key.

=cut

sub retrieve
{
    my ( $self, $sid ) = @_;

    #
    # Get the prefix, and build a key
    #
    my $prefix = $self->{ 'Prefix' } || "session";
    my $key    = $prefix . ':' . $sid;

    #
    # redis doesn't like to have whitespace in the keys.
    #
    $key =~ s/[ \t\r\n]//g;

    my $rv = $self->{ 'Redis' }->get( $key );
    return 0 unless defined($rv);
    return $rv;
}


=head2 retrieve

Generate a key, by joining a prefix and the session identifier, then
remove that key from the Redis store.

=cut

sub remove
{

    my $self = shift;
    my ( $sid, $datastr ) = @_;

    #
    # Get the prefix, and build a key
    #
    my $prefix = $self->{ 'Prefix' } || "session";
    my $key    = $prefix . ':' . $sid;

    #
    # redis doesn't like to have whitespace in the keys.
    #
    $key =~ s/[ \t\r\n]//g;

    # remove the data associated with the id
    $self->{ 'Redis' }->del( $key );

    return 1;
}


sub teardown
{
    my ( $self, $sid, $options ) = @_;

    # NOP
}

sub DESTROY
{
    my $self = shift;
    # NOP
}



1;


=head1 SEE ALSO

=over 4

=item *

L<CGI::Session|CGI::Session> - CGI::Session manual

=item *

L<CGI::Session::Tutorial|CGI::Session::Tutorial> - extended CGI::Session manual

=item *

L<CGI::Session::CookBook|CGI::Session::CookBook> - practical solutions for real life problems

=item *

L<Redis|Redis> - Redis interface library.

=back

=cut
