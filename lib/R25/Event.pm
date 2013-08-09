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
    my $event_id = shift;

    R25->Rest->GET( $path . R25->Rest->buildQuery( 'event_id', $event_id ) );

    $self->{'xc'} = R25->Rest->responseXpath();
    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );
    $self->{'xc'}->setContextNode( $self->{'xc'}->findnodes( '//r25:event' )->shift );

    return $self->Id;
}


sub Id {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event_id' );
}


sub Name {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:event_name' );
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

sub State {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:state' );
}


sub ParentId {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:parent_id' );
}




1;
