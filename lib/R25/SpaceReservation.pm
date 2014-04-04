package R25::SpaceReservation;

use strict;
use warnings;

use R25::Space;


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


sub SpaceId {
    my $self = shift;
    return $self->{'xc'}->findvalue( 'r25:space_id' );
}


sub SpaceName {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:space_name' )
        || $self->{'xc'}->findvalue( 'r25:space/r25:space_name' );
}

sub Reservation {
    my $self = shift;

    my $node = $self->{'xc'}->getContextNode->parentNode;
    my $reservation = R25::Reservation->new( node => $node );

    return $reservation;
}


1;
