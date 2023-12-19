package Pouet::Controller::Portfolio;

use base 'Mojolicious::Controller';

use strict;
use warnings;
use 5.022;
use FindBin qw($Bin);
use utf8;
use experimental 'smartmatch';

sub dir {
	my $self = shift;
	return "$Bin/../content/portfolio";
}

sub load_index {
	my $self = shift;
	
	my $fi;
	open $fi, '<:encoding(utf8)', $self->dir() . '/index.txt' or return $self->reply->not_found;
	my $s = join '', <$fi>;
	close $fi;

	return split /\n/, $s;
}

sub section {
	my $self 	= shift;
	my @section = @_;
	
	my @files = ();	

	my $dir = $self->dir();
	for ($self->load_index()) {
		push @files, {
			name => ($dir . '/' . $_), 
		};
	}
	
	for my $f (@files) {
		my $fi;
		open $fi, '<:encoding(utf8)', $f->{name};
		$f->{content} = join '', <$fi>;
		close $fi;
	}
	
	for (@files) {
		my $c = $_->{content};
		my $url = $_->{name};
		$url =~ s/^.*(\/\w+\/.+\.html)$/$1/;
		$c =~ s/^(.*?\<h4.*?\<p.*?\<br\/\>.+?<br\/\>.+?<br\/\>.+?<br\/\>).+(\<\/p\>\s*)$/$1\<a href="$url"\>Читать полностью...\<\/a\>$2/ms;
		$_->{snippet} = $c;
	}
	
	return @files;
}

sub portfolio {
	my $self = shift;
	
	my @posts = ();
	
	my $url = $self->url_for();
	
	my $title = '';
		
	@posts = $self->section;
	
	$self->render(
		posts => \@posts,
		title => $title ? 'Поэт :: ' . $title : 'Поэт',
	);
}

sub page {
	my $self = shift;

	my $page = $self->stash('page');
	return $self->reply->not_found unless $page =~ /^[\w\d\-]+\.html$/;
	
	my $file = $page;

	my $fi;
	open $fi, '<:encoding(utf8)', $self->dir() . '/' . $file or return $self->reply->not_found;
	my $s = join '', <$fi>;
	close $fi;
	
	my ($title) = $s =~ /\<h4.*?\>(.*?)\<\/h4\>/;
	
	return $self->render(
		article => $s,
		title   => $title . ' :: Поэт',
	);
}

1;
