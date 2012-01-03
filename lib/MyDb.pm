package MyDb;

use strict;
use warnings;
use DBI;

# Constructor
sub new {
    my $class = shift;
    my $self = {
      dbname => "./sessions.db",
      @_,
      dbh => undef,
    };
    bless($self, $class);

    my $dbh = DBI->connect(
	"dbi:SQLite:dbname=$self->{dbname}",
	"",
	"",
    );
    return unless $dbh;

    # set up our table
    $dbh->do("CREATE TABLE IF NOT EXISTS session (key, uid, gecos)");

    $self->{dbh} = $dbh;
    return $self;
}

# Store session in db
sub store {
  my $self = shift;
  return unless $self->{dbh};

  my %param = ( 
      uid   => '+invalid+',
      gecos => 'n/a',
      key   => '+invalid+',
      @_,
  );

  my $stmt = "INSERT INTO session (key, uid, gecos) VALUES (?, ?, ?)";
  my $sth = $self->{dbh}->prepare($stmt);
  $sth->execute($param{key}, $param{uid}, $param{gecos});
  return unless $sth;

  return 1;
}


# Retrieve uid/gecos from session key
sub retreive {
  my ($self, $key) = @_;
  return unless $self->{dbh};

  my $stmt = "SELECT uid, gecos FROM session WHERE key = ?";
  my $sth = $self->{dbh}->prepare($stmt);
  $sth->execute($key);

  my @row = $sth->fetchrow_array;
  return unless @row;

  return wantarray ? @row : $row[0];
}


# clear all entries with a uid
sub clear_uid {
  my ($self, $uid) = @_;
  return unless $uid;

  my $stmt = "DELETE FROM session WHERE uid = ?";
  my $sth = $self->{dbh}->prepare($stmt);
  $sth->execute($uid);
  
  return;
}

1;
