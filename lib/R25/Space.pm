package R25::Space;

use strict;
use warnings;

our $path = '/r25ws/servlet/wrd/run/space.xml';


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
    my $space_id = shift;

    R25->Rest->GET( $path . R25->Rest->buildQuery( 'space_id', $space_id ) );

    $self->{'xc'} = R25->Rest->responseXpath();
    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );

    return $self->Id;
}


sub Id {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:space_id' );
}


sub Name {
    my $self = shift;

    return $self->{'xc'}->findvalue( 'r25:space_name' );
}


1;
