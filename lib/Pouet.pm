package Pouet;

use base 'Mojolicious';

use strict;
use warnings;
use 5.022;
use utf8;

use Pouet::Config;


sub startup {
	my $self = shift;

	my $config = $self->{config} = new Pouet::Config;

	my $r = $self->routes;
	$r->get('/')->to('Home#page',         article => 'home.html');
	$r->get('/about')->to('Home#page',    article => 'about.html');
	$r->get('/contacts')->to('Home#page', article => 'contacts.html');
	
	$r->get('/portfolio')->to('Portfolio#portfolio');
	$r->get('/portfolio/*page')->to('Portfolio#page');
}

1;
