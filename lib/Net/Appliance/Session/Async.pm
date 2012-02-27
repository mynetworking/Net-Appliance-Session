package Net::Appliance::Session::Async;

use Moose::Role;

sub put {
    my ($self, $cmd, $opts) = @_;
    $opts ||= {};
    return $self->nci->transport->put($cmd,
        ($opts->{no_ors} ? () : $self->nci->transport->ors));
}

sub gather {
    my ($self, $opts) = @_;
    $opts ||= {};
    $opts->{no_ors} = 1; # force no newline
    return $self->cmd('', $opts);
}

1;
