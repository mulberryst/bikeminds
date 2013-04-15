package BikeMinds::Main;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Mojo::IOLoop;
use Data::Dumper;
use URI::Escape;
use MD5;
use Try::Tiny;

sub index {
  my $s = shift;
  $s->render;
}

sub showImages {
  my $s = shift;
  my $coll = $s->mango->db->collection('images');

  my $return = 0;
  my $delay = Mojo::IOLoop->delay( sub {
      my ($delay, @docs) = @_;
      $s->app->log->debug("delay: $delay @docs");
#      $s->app->log->debug(Dumper(\@docs));
#      $s->stash(images => [qw(1 2 3 4 5)]);
      $s->stash(images => \@docs);
      $s->render;
      $return = 1;
  });;
  $delay->begin;
  my $img =  $coll->find()->all(sub {
    my ($cursor, $err, $docs) = @_;
    $delay->end(@$docs);
  });

  my @docs;
    @docs = $delay->wait unless Mojo::IOLoop->is_running;


#  $s->render_later;
  #  block
  while (not $return) {
   Mojo::IOLoop->one_tick;
 }
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
      my ($name, $size, $src) = ($s->req->param('name'), $s->req->param('size'), $s->req->param('src'));
#   
#      $s->app->log->debug($data);
      my $md5 = MD5->hexhash($src);
      try {
        $s->mango->db->collection('images')->insert({ _id => $md5, src => $src, size => $size, name => $name, len => length($src) });
      } finally {
        if (@_) {
          if ($_[0] eq 'E11000') {
#            $s->render_json({error => 'duplicate image, this image already exists in our dB'});
          } else {
            $s->render_json({error => join("<br>",@_)});
          }
        } else {
        }
          $s->render_json({message => 'yep'});
      };

    } else {
      $s->render_text('invalid upload!');
    }
  }
}
1;
