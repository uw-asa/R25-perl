package R25::Reservation;

use strict;
use warnings;

our $path = '/r25ws/servlet/wrd/run/reservation.xml';


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


sub Load {
    my $self = shift;
    my $reservation_id = shift;

    R25->Rest->GET( $path . R25->Rest->buildQuery( 'reservation_id', $reservation_id ) );

    $self->{'xc'} = R25->Rest->responseXpath();
    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );
    $self->{'xc'}->setContextNode( $self->{'xc'}->findnodes( '//r25:reservation' )->shift );

    return $self->Id;
}


sub Id {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_id' );
}


=head State

    returns the state of the reservation as an integer

    1 Standard
    2 Exception
    3 Warning
    4 Override
   99 Cancelled

=cut

sub State {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_state' );
}


sub StartDT {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_start_dt' );
}


sub EndDT {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_end_dt' );
}



sub EventName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event/r25:event_name' );
}


=head EventState

    returns the state of the event as an integer

    0 Draft
    1 Tentative
    2 Confirmed
    3 Sealed
   98 Denied
   99 Cancelled

=cut

sub EventState {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event/r25:state' );
}



1;
