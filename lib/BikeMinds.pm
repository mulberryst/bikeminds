package BikeMinds;
use Mojo::Base 'Mojolicious';
#use Mojolicious::Plugin::Mongodb;
use Mango;

sub startup {
  my $s = shift;

#  $s->plugin('mongodb', {
#      host => 'localhost',
#      port => 27017,
#      helper => 'db',
#  });
#
  my $conf = $s->plugin('Config');

  $s->secret('it\'s not secret');
  $s->helper(mango => sub { state $mango = Mango->new(
    "mongodb://localhost/bikeminds");});

  my $r = $s->routes;
  $r->any('/')->to('main#index')->name('index');
  $r->any('/images')->to('main#showImages');
  $r->any('/upload')->to('main#upload');
  $r->any('/upload/:name')->to('main#upload');

}

1;
