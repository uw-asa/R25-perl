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

    R25->Rest->GET( $path . R25->Rest->buildQuery( reservation_id => $reservation_id ) );

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

my %RESERVATION_STATE_NAME = (
    1  => 'Standard',
    2  => 'Exception',
    3  => 'Warning',
    4  => 'Override',
    99 => 'Cancelled',
);

sub State {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_state' );
}

sub StateName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_state_name' )
        if $self->{'xc'}->findvalue( 'r25:reservation_state_name' );

    return $RESERVATION_STATE_NAME{$self->State};
}


sub StartDT {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_start_dt' );
}


sub EndDT {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:reservation_end_dt' );
}


sub Event {
    my $self = shift;

    my $node = $self->{'xc'}->findnodes( 'r25:event' )->shift
        || $self->{'xc'}->getContextNode->parentNode->parentNode;

    use R25::Event;
    my $event = R25::Event->new( node => $node );

    return $event;
}


sub EventId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event/r25:event_id' )
        || $self->{'xc'}->getContextNode->parentNode->parentNode->findvalue( 'r25:event_id' );
}


sub EventName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event/r25:event_name' )
        || $self->{'xc'}->getContextNode->parentNode->parentNode->findvalue( 'r25:event_name' );
}


sub EventTitle {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event/r25:event_title' )
        || $self->{'xc'}->getContextNode->parentNode->parentNode->findvalue( 'r25:event_title' );
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

    return $self->{'xc'}->findvalue( 'r25:event/r25:state' )
        || $self->{'xc'}->getContextNode->parentNode->parentNode->findvalue( 'r25:state' );
}


sub SpaceId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:spaces/r25:space_id' )
        || $self->{'xc'}->findvalue( 'r25:space_reservation/r25:space_id' );
}


sub SpaceName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:spaces/r25:space_name' )
        || $self->{'xc'}->findvalue( 'r25:space_reservation/r25:space/r25:space_name' );
}


sub ProfileId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:profile_id' )
        || $self->{'xc'}->findvalue( 'r25:event/r25:profile_id' )
        || $self->{'xc'}->getContextNode->parentNode->findvalue( 'r25:profile_id' );
}


sub ProfileName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:profile_name' )
        || $self->{'xc'}->findvalue( 'r25:event/r25:profile_name' )
        || $self->{'xc'}->getContextNode->parentNode->findvalue( 'r25:profile_name' );
}


sub ProfileDescription {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:profile_description' )
        || $self->{'xc'}->findvalue( 'r25:event/r25:profile_description' )
        || $self->{'xc'}->getContextNode->parentNode->findvalue( 'r25:profile_description' );
}


1;
