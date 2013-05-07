package BikeMinds;
use Mojo::Base 'Mojolicious';
#use Mojolicious::Plugin::Mongodb;
use Mango;
use Data::Dumper;

sub startup {
  my $s = shift;

#  $s->plugin('mongodb', {
#      host => 'localhost',
#      port => 27017,
#      helper => 'db',
#  });

  $s->hook(before_dispatch => sub {
#    push @{$self->req->url->base->path->parts}, splice @{$self->req->url->path->parts}, 0, 2; 
    my $s = shift;
    shift @{$s->req->url->base->path->parts}; 
    $s->app->log->debug( Dumper( $s->req->url->base->path->parts ) );
  });
  $s->app->log->debug( 'wtf' );

  my $conf = $s->plugin('Config');

  $s->secret('it\'s not secret');
  $s->helper(mango => sub { state $mango = Mango->new(
    "mongodb://localhost/bikeminds");});

  my $r = $s->routes;

  $r->any('/')->to('main#index')->name('index');
  $r->any('/images')->to('main#showImages');
  $r->any('/upload')->to('main#upload');
  $r->any('/upload/:name')->to('main#upload');
  $r->post('/login')->to('main#login');
}

1;
