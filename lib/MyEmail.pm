package MyEmail;

use strict;
use warnings;
use utf8;

use Email::Sender::Simple;
use MIME::Entity;

sub send_email {
    my $class = shift;
    my $self = {
      username => "<username>",
      email    => "<email>",
      key      => "<key>",
      host     => "<host>",
      @_,
    };
    bless($self, $class);

    my $data = 
      "Gjenoppretting av passord\n" .
      "\n" .
      "Ditt brukernavn ved innlogging i labben er \"$self->{username}\".\n" .
      "\n" .
      "For å velge et nytt passord, velg følgene lenk eller kopier+lim den\n" .
      "inn i addressefeltet i webbleseren." . 
      "http://$self->{host}/reset/$self->{key}\n" .
      "\n" .
      "Med vennlig hilsen\n" .
      "Administratørene i labben.\n";

    my $msg = MIME::Entity->build(
      From     => 'hostmaster@lab.as2116.net',
      To       => $self->{email},
      Subject  => "Gjenoppretting av passord i labben",
      Data     => $data,
      Charset  => "UTF-8",
      Encoding => "-SUGGEST",
    );

    return Email::Sender::Simple->try_to_send($msg);
}

1;
