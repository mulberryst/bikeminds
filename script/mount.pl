#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use BikeMinds;
use Mojolicious::Commands;
use Mojolicious::Lite;


plugin Mount => {'/bikeminds/' => 'start.pl'};

app->start;
