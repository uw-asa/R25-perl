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


sub EventName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event/r25:event_name' );
}


1;
