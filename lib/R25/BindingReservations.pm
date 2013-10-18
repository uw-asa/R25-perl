package R25::BindingReservations;

use strict;
use warnings;

use R25::BindingReservation;

use POSIX qw(strftime);


sub new  {
    my $class = shift;
    my $self  = { @_ };
    bless ($self, $class);

    return $self;
}


sub List {
    my $self = shift;

    return () unless $self->{'binding_reservation_list'};

    return @{$self->{'binding_reservation_list'}};
}


1;
