package Pouet::Controller::Home;

use base 'Mojolicious::Controller';

use strict;
use warnings;
use 5.022;
use FindBin qw($Bin);
use utf8;
use experimental 'smartmatch';

use constant SECTIONS => {
	home => '',
};

sub dir {
	my $self = shift;
	return "$Bin/../content";
}

sub page {
	my $self = shift;
	my $article = $self->stash('article');
	
	my $section = 'home';
	
	my $file = $section . '/'. $article;

	my $fi;
	open $fi, '<:encoding(utf8)', $self->dir() . '/' . $file or return $self->reply->not_found;
	my $s = join '', <$fi>;
	close $fi;
	
	
	my ($title) = $s =~ /\<h4.*?\>(.*?)\<\/h4\>/;
	
	return $self->render(
		article => $s,
		title   => $title ? $title . ':: Поэт' : '',
	);
}

1;
