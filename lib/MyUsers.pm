package MyUsers;

use strict;
use warnings;
use Net::LDAP;
use Digest::SHA qw( sha1 );

# Some constants
use constant BASE => "dc=example,dc=com";

# Constructor
sub new {
  my $class = shift;
  my $self = {
	      host   => "localhost",
	      base   => BASE,
	      binddn => "cn=admin," . BASE,
	      bindpw => '',
	      @_,
	     };
  bless($self, $class);

  my $ldap = Net::LDAP->new($self->{host});
  return unless $ldap;


  my $msg = $ldap->bind($self->{binddn}, password => $self->{bindpw});
  return if $msg->is_error();

  $self->{ldap} = $ldap;
  return $self;
}


# Search for email address and return associated uid
# on success, false else.
sub find_email {
  my ($self, $email) = @_;
  return unless $email;

  my $result = $self->{ldap}->search(
    base => $self->{base},
    filter => "(mail=$email)",
    attrs => [ 'uid', 'gecos' ],
  );
  return unless $result;

  my $entry = $result->shift_entry;
  return unless $entry;

  my $uid = $entry->get_value('uid');
  my $gecos = $entry->get_value('gecos') || "bla bla";
  return unless $uid;

  return wantarray ? ($uid, $gecos) : $uid;
}


# Set password of user uid
sub set_passwd {
  my ($self, $uid, $passwd) = @_;
  return unless $passwd && $uid; 

  my $dn = "uid=$uid,ou=People,$self->{base}";
  my $result = $self->{ldap}->modify($dn,
    replace => {
      userPassword => sha1($passwd),
    }
  );

  return if $result->is_error();
  return 1;
}

1;
