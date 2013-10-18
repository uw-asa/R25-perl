package R25::BindingReservation;

use strict;
use warnings;


sub new  {
    my $class = shift;
    my %args = (
        node => undef,
        @_,
        );

    my $self  = {};
    if ( $args{'node'} ) {
        $self->{'xc'} = XML::LibXML::XPathContext->new($args{'node'});
        $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );
    }

    bless ($self, $class);

    return $self;
}


sub Id {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:bound_reservation_id' );
}


sub PrimaryReservation {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:primary_reservation' );
}


sub Name {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:bound_name' );
}


sub EventId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:bound_event_id' );
}


sub EventName {
    my $self = shift;

    my ($eventname, $profilename) = split '/', $self->Name;

    return $eventname;
}


1;
