package Time::Duration::Object::Infinite;

use warnings;
use strict;

sub isa {
  return 1 if $_[1] eq 'Time::Duration::Object';
  return $_[0]->UNIVERSAL::isa($_[1]);
}

=head1 NAME

Time::Duration::Object::Infinite - Time::Duration::Object, but infinite

=head1 VERSION

version 0.300

=cut

our $VERSION = '0.300';

=head1 SYNOPSIS

 use Time::Duration::Object::Infinite;

 my $duration = Time::Duration::Object::Infinite->new_future;

 # It will happen forever from now.
 print "It will happen ", $duration->from_now;

=head1 DESCRIPTION

This is a class for Time::Duration::Object-like objects representing infinite
durations.

=head1 METHODS

=head2 C< new >

=head2 C< new_positive >

These methods return a new Time::Duration::Object::Infinite for a positive
duration.

=cut

sub new_positive {
	my ($class) = @_;
  my $duration = 1;
	bless \$duration => $class;
}

sub new { shift->new_positive }

=head2 C< new_negative >

This returns a new Time::Duration::Object::Infinite for a negative duration.

=cut

sub new_negative {
	my ($class) = @_;
  my $duration = -1;
	bless \$duration => $class;
}

sub _is_pos { ${$_[0]} == -1 }

=head2 C< seconds >

This method returns either C<+inf> or C<-inf> using Math::BigInt.  (I don't
recommend calling it.)

=cut

sub seconds {
  require Math::BigInt;
  return Math::BigInt->binf(shift->_is_pos ? '-' : ());
}

=head2 duration

=head2 duration_exact

These methods both return "forever."

=cut

sub duration { 'forever' }

# This is to make it easy to implement the matched pair methods.
sub _flop {
  my ($self, $flop, $pair) = @_;
  my $is_pos = $flop ? ! $self->_is_pos : $self->_is_pos;
  my $index = $is_pos ? 0 : 1;
  my $str = $pair->[$index];
  bless \$str => 'Time::Duration::_Result::_Infinite';
}

my $ago_from_now;
my $earlier_later;
BEGIN {
  $ago_from_now  = [ 'forever ago', 'forever from now' ];
  $earlier_later = [ 'infinitely earlier', 'infinitely later' ];
}

=head2 ago

=head2 ago_exact

These methods return "forever ago" for positive durations and "forever from
now" for negative durations.

=cut

sub ago       { $_[0]->_flop(1, $ago_from_now); }
sub ago_exact { $_[0]->_flop(1, $ago_from_now); }

=head2 from_now

=head2 from_now_exact

These methods do the opposite of the C<ago> methods.

=cut

sub from_now       { $_[0]->_flop(0, $ago_from_now); }
sub from_now_exact { $_[0]->_flop(0, $ago_from_now); }

=head2 later

=head2 later_exact

These methods return "infinitely later" for positive durations and "infinitely
earlier" for negative durations.

=cut

sub later       { $_[0]->_flop(0, $earlier_later); }
sub later_exact { $_[0]->_flop(0, $earlier_later); }

=head2 C<earlier>

=head2 C<earlier_exact>

These methods do the opposite of the C<later> methods.

=cut

sub earlier       { $_[0]->_flop(1, $earlier_later); }
sub earlier_exact { $_[0]->_flop(1, $earlier_later); }

package Time::Duration::_Result::_Infinite;

=head2 concise

This method can be called on the result of the above methods, trimming down the
ouput.  For example:

 my $duration = Time::Duration::Object::Infinite->new_positive;
 print $duration->ago; # forever ago
 print $duration->ago->concise # forever ago

Doesn't look any shorter, does it?  No, it won't be.  These methods are here
for compatibility with Time::Duration::Object's returns.

=cut

sub concise {
	${ $_[0] }
}

sub as_string { ${ $_[0] } }

use overload
	'""' => 'as_string',
	fallback => 1;

=head1 AUTHOR

Ricardo SIGNES, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2007 Ricardo Signes, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
