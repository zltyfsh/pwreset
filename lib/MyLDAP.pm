package MyLDAP;

use Moose;
use Net::LDAP;

has 'host' => ( is => 'rw', isa => 'Str' );
has 'dn' => ( is => 'rw', isa => 'Str' );
has 'pw' => ( is => 'rw', isa => 'Str' );
has 'error' => (is => 'ro', isa => 'Str' );
has '_handle' => ( is => 'bare', isa  => 'Net::LDAP' );


sub bind {
    my $self = shift;
    my $handle = Net::LDAP->new($self->host);
    unless ($handle) {
	$self->error("$@");
	return;
    }
    $self->_handle($handle);

    return $handle->bind($self->dn, password => $self->pw);
};


sub unbind {
    my $self = shift;
    return 1 if (!$self->_handle);
    return $self->_handle->unbind();
}


sub pw_ok {
    my ($self, $user, $pass) = @_;

    
};


sub is_admin {
};
 

# sub new {
#     my $this = shift;
#     my $class = ref($this) || $this;
#     my $self = {};
#     $self->{'DN'} = undef;
#     $self->{'PW'} = undef;
#     $self->{'HANDLE'} = undef;
#     bless $self, $class;
#     return $self;
# }

# sub pw_ok {
#     my ($self, $user, $pw) = @_;
    
#     # Success
#     return 1 if ($user eq $pw);

#     # Fail
#     return;
# }

# sub is_admin {
#     my ($self, $user) = @_;
    
#     # Success
#     return 1 if ($user eq 'a');

#     # Fail
#     return;
# }

    no Moose;

1;
