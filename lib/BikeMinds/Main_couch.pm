package BikeMinds::Main;
use Mojo::Base 'Mojolicious::Controller';
use CouchDB::Client;
use Mojo::JSON;
use Data::Dumper;
use URI::Escape;

my $json = Mojo::JSON->new();

sub index {
  my $s = shift;
  $s->render;
}

sub upload {
  my $s = shift;

  if ($s->stash('name')) {
    $s->app->log->debug($s->stash('name'));
    $s->render("upload/".$s->stash('name'));
  } else {
    if ($s->stash('format') eq 'json') {
      $s->app->log->debug("format is json");
      my $data = uri_unescape($s->req->body);
#
      my $c = CouchDB::Client->new(uri => 'http://localhost:5984/');
      $c->testConnection or $s->render_json({error => 'couch server cannot be reached!'}) && return;
      my $db = $c->newDB('images')->create;
      if (!$db->validName) {
        $db->create;
      }

      $s->app->log->debug(Dumper($db->dbInfo));
      my $doc = $db->newDoc('image.jpeg', undef, { src => $data })->create;
      $s->render_json({message => 'yep'});
    } else {
      $s->render_text('invalid upload!');
    }
  }
}
1;
