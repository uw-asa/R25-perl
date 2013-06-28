package R25::Spaces;

use strict;
use warnings;

use R25::Space;

our $path = '/r25ws/servlet/wrd/run/spaces.xml';


sub new  {
    my $class = shift;
    my $self  = {};
    bless ($self, $class);

    return $self;
}


sub Find {
    my $self = shift;
    my %args = (
        @_,
        );

    my %findargs;

    R25->Rest->GET( $path . R25->Rest->buildQuery( %findargs ) );

    $self->{'xc'} = R25->Rest->responseXpath()
        or croak("couldn't get xml");

    $self->{'xc'}->registerNs( 'r25', 'http://www.collegenet.com/r25' );

    my @nodes = $self->{'xc'}->findnodes( '//r25:space' );

    for my $node (@nodes) {
        my $space = R25::Space->new(node => $node);
        push @{$self->{'space_list'}}, $space;
    }

    return scalar(@{$self->{'space_list'}});
}

1;
