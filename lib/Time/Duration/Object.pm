package Time::Duration::Object;
use Time::Duration;

use warnings;
use strict;

=head1 NAME

Time::Duration::Object - Time::Duration, but an object

=head1 VERSION

version 0.161

 $Id$

=cut

our $VERSION = '0.161';

=head1 SYNOPSIS

 use Time::Duration::Object;

 my $duration = Time::Duration::Object->new($end_time - $start_time);

=head1 DESCRIPTION

This module provides an object-oriented interface to Time::Duration.  Sure,
it's overkill, and Time::Duration is plenty useful without OO, but this
interface makes it easy to use Time::Duration with Class::DBI, and that's a
good thing.

=head1 METHODS

=head2 C< new($seconds) >

This returns a new Time::Duration::Object for the given number of seconds.

=cut

sub new {
	my ($class, $duration) = @_;
	return unless defined $duration;
	bless \$duration => $class;
}

=head2 C< seconds >

This returns the number of seconds in the duration (i.e., the argument you
passed to your call to C<new>.)

=cut

sub seconds {
	return ${(shift)};
}

=head2 C<duration>

=head2 C<duration_exact>

=head2 C<ago>

=head2 C<ago_exact>

=head2 C<from_now>

=head2 C<from_now_exact>

=head2 C<later>

=head2 C<later_exact>

=head2 C<earlier>

=head2 C<earlier_exact>

These methods all perform the function of the same name from Time::Duration.

=cut

{
  ## no critic (ProhibitNoStrict)
	no strict 'refs';
	no warnings 'redefine';
	my @methods = qw(
		duration duration_exact ago ago_exact from_now from_now_exact later
		later_exact earlier earlier_exact
	);
	for (@methods) {
		my $method = \&{"Time::Duration::$_"};
		*{$_} = sub {
			unshift @_, ${(shift)};
			my $result = &$method(@_);
			bless \$result => 'Time::Duration::_Result';
		}
	}
}

package Time::Duration::_Result;

=head2 C< concise>

This method can be called on the result of the above methods, trimming down the
ouput.  For example:

 my $duration = Time::Duration::Object->new(8000);
 print $duration->ago; # 2 hours and 13 minutes ago
 print $duration->ago->concise # 2hr13m ago

=cut

sub concise {
	my $self = shift;
	Time::Duration::concise(${$self});
}

use overload
	'""' => sub { ${$_[0]} },
	fallback => 1;

=head1 SEE ALSO

Obviously, this module would be useless without Sean Burke's super-useful
L<Time::Duration>.  There are those, I'm sure, who will think that even I<with>
that module...

=head1 AUTHOR

Ricardo Signes, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-time-duration-object@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2004-2006 Ricardo Signes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
