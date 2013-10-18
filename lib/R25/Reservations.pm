package R25::Reservations;

use strict;
use warnings;

use R25::Reservation;

use POSIX qw(strftime);

our $path = '/r25ws/servlet/wrd/run/reservations.xml';


sub new  {
    my $class = shift;
    my $self  = { @_ };
    bless ($self, $class);

    return $self;
}


sub Find {
    my $self = shift;
    my %args = (
        EventId    => undef, # int
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

    $findargs{'event_id'} = $args{'EventId'} if $args{'EventId'};
    $findargs{'space_id'} = $args{'SpaceId'} if $args{'SpaceId'};
    $findargs{'start_dt'} = $args{'StartDT'} if $args{'StartDT'};
    $findargs{'end_dt'}   = $args{'EndDT'}   if $args{'EndDT'};
    $findargs{'event_state'} = join( '+', @{$args{'event_state'}} ) if $args{'EventState'};
    $findargs{'state'}       = join( '+', @{$args{'state'}}       ) if $args{'State'};

    #warn ( $path . R25->Rest->buildQuery( %findargs ) );
    R25->Rest->GET( $path . R25->Rest->buildQuery( %findargs ) );

    $self->{'xc'} = R25->Rest->responseXpath();
    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );

    my @nodes = $self->{'xc'}->findnodes( '//r25:reservation' );

    return undef unless scalar @nodes;

    for my $node (@nodes) {
        my $space = R25::Reservation->new(node => $node);
        push @{$self->{'reservation_list'}}, $space;
    }

    return scalar(@{$self->{'reservation_list'}});
}


sub List {
    my $self = shift;

    return () unless $self->{'reservation_list'};

    return @{$self->{'reservation_list'}};
}


1;
