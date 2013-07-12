package R25::SpaceReservations;

use strict;
use warnings;

use R25::Reservation;

use POSIX qw(strftime);

our $path = '/r25ws/servlet/wrd/run/rm_reservations.xml';


sub new  {
    my $class = shift;
    my %args = (
        node => undef,
        @_,
        );

    my $self  = {};
    bless ($self, $class);

    if ( $args{'SpaceId'} ) {
        $self->Find( %args );
    }

    return $self;
}


sub Find {
    my $self = shift;
    my %args = (
        SpaceId    => undef, # int
        StartDT    => undef, # time 
        EndDT      => undef, # time
        EventState => undef, # list
        State      => undef, # list
        @_,
        );

    my %findargs = (
        scope => 'extended',
        );

    $findargs{'space_id'} = $args{'SpaceId'} if $args{'SpaceId'};
    $findargs{'start_dt'} = strftime( "%Y%m%dT%H%M%S00", localtime($args{'StartDT'}) ) if $args{'StartDT'};
    $findargs{'end_dt'}   = strftime( "%Y%m%dT%H%M%S00", localtime($args{'EndDT'})   ) if $args{'EndDT'};
    $findargs{'event_state'} = join( '+', @{$args{'event_state'}} ) if $args{'EventState'};
    $findargs{'state'}       = join( '+', @{$args{'state'}}       ) if $args{'State'};

    R25->Rest->GET( $path . R25->Rest->buildQuery( %findargs ) );

    $self->{'xc'} = R25->Rest->responseXpath();
    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );

    my @nodes = $self->{'xc'}->findnodes( '//r25:space_reservation' );

    return undef unless scalar @nodes;

    for my $node (@nodes) {
        my $space = R25::Reservation->new(node => $node);
        push @{$self->{'reservation_list'}}, $space;
    }

    return scalar(@{$self->{'reservation_list'}});
}


sub List {
    my $self = shift;

    return undef unless $self->{'reservation_list'};

    return @{$self->{'reservation_list'}};
}


1;
