=head1 NAME

Bot::BasicBot::Pluggable::Module::Delicious - automatically post urls mentioned to del.icio.us 

=head1 IRC USAGE

None. If the module is loaded, the bot will post all urls

=head1 VARS

=over 4

NOTE: the channel C<all> can be used

=item username_<channel> 

The user name for a particular channel

=item password_<channel> 

The password for a particular channel

=back




=head1 REQUIREMENTS

L<URI::Title>

L<URI::Find::Simple>

L<Net::Delicious>

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut

package Bot::BasicBot::Pluggable::Module::Delicious;
use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;

use Net::Delicious;
use POSIX qw(strftime):
use URI::Title qw(title);
use URI::Find::Simple qw(list_uris);

sub help {
    return "Speaks the title of URLs mentioned.";
}


sub init {
    my $self = shift;
}


# TODO: 
# logging
# tags 
# privacy 
sub admin {
    # do this in admin so we always get a chance to see titles

    my ($self, $mess) = @_;

    my $channel = $mess->channel;
    return undef if $channel eq 'msg';

    # get the del.icio.us object 
    my $del = $self->{_delicious}->{$channel};

    # bah we don't have one - try and make one (default to all)
    foreach my $c (($channel, 'all')) {
        last if $del;
        my $user = $self->get("username_$c");
        my $pass = $self->get("password_$c");
        next unless defined $user && defined $pass;
        $del = Net::Delicious->new({user=>$user, pswd=>$pass});
        $self->{_delicious}->{$c} = $del if $del;
    }    

    return undef unless $del;

    for (list_uris($mess->{body})) {
        my $title = title($_);
        $mess->{body} =~ m!\s+#\s*(.+?)\s*$!;
        my $desc = $1 || "";
        my $date = strftime("%FT%TZ", localtime);
        $del->add_post({ url         => $_, 
                         title       => $title,
                         description => $desc,
                         dt          => $date, 
                       });         
    }

    return undef; # Delcious.pm is passive, and doesn't intercept things.
    
}

1;

