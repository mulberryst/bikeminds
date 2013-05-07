#!/usr/bin/perl
#
use warnings;
use strict;
use Mango;
use Mojo::IOLoop;
use MIME::Base64;
use Data::Dumper;

my $mango = Mango->new('mongodb://localhost:27017');

my $delay = Mojo::IOLoop->delay;
  $delay->begin;
  $mango->db('bikeminds')->collection('images')->find({})->all(sub {
      my ($cursor, $err, $docs) = @_;
      $delay->end(@$docs);
      });
my @docs = $delay->wait;

foreach my $doc (@docs) {
  open (IMG, ">".$doc->{name});

  my $data = $doc->{src};
  $data =~ s/^data:image\/jpeg\;base64//;
  print IMG decode_base64($data);
  close (IMG);
}


=head1 NAME

extractImages

=head1 SYNOPSIS

mkdir somedir && cd somedir
perl ../extractImages.pl

=head1 DESCRIPTION

extract all the base64 encoded images from mongodb into files

=head1 AUTHOR

Nate Lally

=head1 COPYRIGHT AND LICENSE


