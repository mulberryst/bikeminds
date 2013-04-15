#!/usr/bin/env perl
use Mojolicious::Lite;
use CouchDB::Client;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/bikeminds' => sub {
  my $self = shift;
  $self->render('index');
};

helper auth => sub {
  my $s = shift;
  return 1 if 
   $s->param('username') eq 'nate' and
   $s->param('password') ne '';
};


get '/login/' => sub { shift->render('login') };

under sub {
  my $s = shift;
  return 1 if $s->auth;

  $s->render(text => 'Login denied');
};

post '/loggedon/' => sub { shift->render(text=> 'yey' ) };

get '/upload/:upload' => sub {
  my $self = shift;
  $self->render("upload/$upload");
};

post '/upload' => sub {
  my $s = shift;
  my $data = $s->req->json;
  $s->render(json => $data);
  return;
  foreach my $f (@{ $s->param } ) {
    my @vals = $s->param($f);
    foreach my $v (@vals) {
      $s->render(text => "$f => $v<br>");
    }
  }

};

app->start
