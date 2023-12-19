package singleton;

=head1 NAME

signleton - class realized singleton constructor

=cut

use strict;
use warnings;
use 5.022;


=head2 singleton

Constructor

Usage:
   my $object = singleton new Class;

=cut

sub main::singleton {
	my $obj   = shift;
	my $class = ref $obj or return;
	state $s = {};
	$s->{$class} //= $obj;
	return $s->{$class};
}

1;
