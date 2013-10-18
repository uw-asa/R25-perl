package R25::Events;

use strict;
use warnings;

use R25::Event;

our $path = '/r25ws/servlet/wrd/run/events.xml';


sub new  {
    my $class = shift;
    my $self  = { @_ };
    bless ($self, $class);

    return $self;
}


sub Find {
    my $self = shift;
    my %args = (
        ParentId => undef, # int
        @_,
        );

    my %findargs;

    $findargs{'parent_id'} = $args{'ParentId'} if $args{'ParentId'};

    R25->Rest->GET( $path . R25->Rest->buildQuery( %findargs ) );

    $self->{'xc'} = R25->Rest->responseXpath()
        or croak("couldn't get xml");

    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );

    my @nodes = $self->{'xc'}->findnodes( '//r25:event' );

    return undef unless scalar @nodes;

    for my $node (@nodes) {
        my $event = R25::Event->new(node => $node);
        push @{$self->{'event_list'}}, $event;
    }

    return scalar(@{$self->{'event_list'}});
}


sub List {
    my $self = shift;

    return () unless $self->{'event_list'};

    return @{$self->{'event_list'}};
}


1;
