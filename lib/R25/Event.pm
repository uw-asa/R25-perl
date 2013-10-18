package R25::Event;

use strict;
use warnings;

our $path = '/r25ws/servlet/wrd/run/event.xml';


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
    my $id = shift;

    if ( $id !~ /^\d+$/ ) {
        use URI::Escape;
        R25->Rest->GET( $path . '?alien_uid=' . uri_escape($id) );
    } else {
        R25->Rest->GET( $path . R25->Rest->buildQuery( event_id => $id ) );
    }

    $self->{'xc'} = R25->Rest->responseXpath();
    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );

    return ( undef, "R25 Event $id not found" ) unless $self->{'xc'}->exists( '//r25:event' );

    $self->{'xc'}->setContextNode( $self->{'xc'}->findnodes( '//r25:event' )->shift );

    return $self->Id;
}


sub Id {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event_id' );
}


sub AlienUid {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:alien_uid' );
}


sub Name {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event_name' );
}


sub Title {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event_title' );
}


sub StartDate {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:start_date' );
}


sub EndDate {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:end_date' );
}



=head State

    returns the state of the event as an integer

    0 Draft
    1 Tentative
    2 Confirmed
    3 Sealed
   98 Denied
   99 Cancelled

=cut

my %EVENT_STATE_NAME = (
    0  => 'Draft',
    1  => 'Tentative',
    2  => 'Confirmed',
    3  => 'Sealed',
    4  => 'Denied',
    99 => 'Cancelled',
);

sub State {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:state' );
}

sub StateName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:state_name' )
        if $self->{'xc'}->findvalue( 'r25:state_name' );

    return $EVENT_STATE_NAME{$self->State};
}


sub ParentId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:parent_id' );
}


sub Parent {
    my $self = shift;
    
    return undef unless $self->ParentId;

    my $parent = R25::Event->new;
    $parent->Load($self->ParentId);

    return $parent;
}



sub CabinetId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:cabinet_id' );
}


sub CabinetName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:cabinet_name' );
}


sub Cabinet {
    my $self = shift;
    
    return undef unless $self->CabinetId;

    my $cabinet = R25::Event->new;
    $cabinet->Load($self->CabinetId);

    return $cabinet;
}


sub Children {
    my $self = shift;

    use R25::Events;
    my $children = R25::Events->new;
    $children->Find( ParentId => $self->Id )
        or return undef;

    return $children;
}


sub BindingReservations {
    my $self = shift;

    my @nodes = $self->{'xc'}->findnodes( 'r25:profile/r25:binding_reservation' );

    my @binding_reservation_list;
    use R25::BindingReservation;
    for ( @nodes ) {
        my $binding_reservation = R25::BindingReservation->new( node => $_ );
        push @binding_reservation_list, $binding_reservation;
    }

    use R25::BindingReservations;
    my $binding_reservations = R25::BindingReservations->new( binding_reservation_list => \@binding_reservation_list );

    return $binding_reservations;
}


sub Reservations {
    my $self = shift;

    my @nodes = $self->{'xc'}->findnodes( 'r25:profile/r25:reservation' );

    my @reservation_list;
    use R25::Reservation;
    for ( @nodes ) {
        my $reservation = R25::Reservation->new( node => $_ );
        push @reservation_list, $reservation;
    }

    use R25::Reservations;
    my $reservations = R25::Reservations->new( reservation_list => \@reservation_list );

    return $reservations;
}


sub old_Reservations {
    my $self = shift;

    use R25::Reservations;
    my $reservations = R25::Reservations->new;
    $reservations->Find(
        EventId => $self->Id,
        StartDT => $self->StartDate,
        EndDT   => $self->EndDate,
        )
        or return undef;

    return $reservations;
}


1;
