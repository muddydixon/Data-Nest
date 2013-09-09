package Data::Nest;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/nest/;

sub new {
    my $class = shift;
    my %opt = @_;

    return bless {
        keys => [],
        tree => {},
        delimiter => $opt{delimiter} || "_____",
    }, $class;
}

sub nest {
    my $data = shift;
    my %opt = @_;

    my $self = new Data::Nest($data, %opt);
    $self;
}

sub key {
    my $self = shift;
    my @keys = @_;

    push @{$self->{keys}}, [@keys];
    $self;
}

sub _entries {
    my $self = shift;
    my $array = shift;
    my $depth = shift;
    return $array if $depth >= scalar @{$self->{keys}};
    my $key = $self->{keys}[$depth];

    my $branch = [];
    my %map;

    foreach my $obj (@$array){
        my $k = join($self->{delimiter}, map { (ref $_ ne "CODE") ? (exists $obj->{$_} ? $obj->{$_} : $self->{delimiter}) : $_->($obj); } @$key);
        $map{$k} = [] unless exists $map{$k};
        push @{$map{$k}}, $obj;
    }

    foreach my $k (sort keys %map){
        push @$branch, {key => $k, values => $self->_entries($map{$k}, $depth+1)};
    }
    $branch;
}

sub entries {
    my $self = shift;
    my $data = shift;

    $self->_entries($data, 0);
}

1;
__END__

=encoding utf-8

=head1 NAME

Data::Nest - It's new $module

=head1 SYNOPSIS

    use Data::Nest;

=head1 DESCRIPTION

Data::Nest is ...

=head1 LICENSE

Copyright (C) muddydixon.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

muddydixon E<lt>muddydixon@gmail.comE<gt>

=cut
