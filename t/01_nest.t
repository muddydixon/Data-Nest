#!perl -T
use strict;
use Test::More;
use Data::Dumper;
use Data::Nest;

my $sample = [
    {userid => 3, itemid => 1, quantity => 3},
    {userid => 3, itemid => 4, quantity => 3},
    {userid => 4, itemid => 2, quantity => 3},
    {userid => 1, itemid => 1, quantity => 3},
    {userid => 1, itemid => 2, quantity => 2},
    {userid => 1, itemid => 2, quantity => 3},
    {userid => 1, itemid => 3, quantity => 3},
    {userid => 2, itemid => 2, quantity => 3},
    {userid => 2, itemid => 4, quantity => 3},
    {userid => 2, itemid => 4, quantity => 1},
    ];

my $entries;

$entries = new Data::Nest()->key('userid')->keyname("hoge");
is($entries->{keyname}, "hoge");

$entries = new Data::Nest()->key('userid')->valname("fuga");
is($entries->{valname}, "fuga");

$entries = new Data::Nest()->key('userid')->entries($sample);
is(4, scalar @{$entries});

is(1, $entries->[0]{key});
is(4, scalar @{$entries->[0]{values}});
is(2, $entries->[1]{key});
is(3, scalar @{$entries->[1]{values}});
is(3, $entries->[2]{key});
is(2, scalar @{$entries->[2]{values}});
is(4, $entries->[3]{key});
is(1, scalar @{$entries->[3]{values}});

$entries = nest()->key('userid')->entries($sample);
is(4, scalar @{$entries});

is(1, $entries->[0]{key});
is(4, scalar @{$entries->[0]{values}});
is(2, $entries->[1]{key});
is(3, scalar @{$entries->[1]{values}});
is(3, $entries->[2]{key});
is(2, scalar @{$entries->[2]{values}});
is(4, $entries->[3]{key});
is(1, scalar @{$entries->[3]{values}});

$entries = new Data::Nest()->key('userid')
    ->keyname('hoge')->valname('fuga')->entries($sample);
is(4, scalar @{$entries});

is(1, $entries->[0]{hoge});
is(4, scalar @{$entries->[0]{fuga}});
is(2, $entries->[1]{hoge});
is(3, scalar @{$entries->[1]{fuga}});
is(3, $entries->[2]{hoge});
is(2, scalar @{$entries->[2]{fuga}});
is(4, $entries->[3]{hoge});
is(1, scalar @{$entries->[3]{fuga}});

$entries = nest()->key('userid')
    ->keyname('hoge')->valname('fuga')->entries($sample);
is(4, scalar @{$entries});

is(1, $entries->[0]{hoge});
is(4, scalar @{$entries->[0]{fuga}});
is(2, $entries->[1]{hoge});
is(3, scalar @{$entries->[1]{fuga}});
is(3, $entries->[2]{hoge});
is(2, scalar @{$entries->[2]{fuga}});
is(4, $entries->[3]{hoge});
is(1, scalar @{$entries->[3]{fuga}});

$entries = nest()->key('userid', 'itemid')->entries($sample);
is(8, scalar @{$entries});

is("1_____1", $entries->[0]{key});
is(1, scalar @{$entries->[0]{values}});
is("1_____2", $entries->[1]{key});
is(2, scalar @{$entries->[1]{values}});
is("1_____3", $entries->[2]{key});
is(1, scalar @{$entries->[2]{values}});
is("2_____2", $entries->[3]{key});
is(1, scalar @{$entries->[3]{values}});
is("2_____4", $entries->[4]{key});
is(2, scalar @{$entries->[4]{values}});
is("3_____1", $entries->[5]{key});
is(1, scalar @{$entries->[5]{values}});
is("3_____4", $entries->[6]{key});
is(1, scalar @{$entries->[6]{values}});
is("4_____2", $entries->[7]{key});
is(1, scalar @{$entries->[7]{values}});

$entries = nest(delimiter => ",")->key('userid', 'itemid')->entries($sample, );
is(8, scalar @{$entries});

is("1,1", $entries->[0]{key});
is(1, scalar @{$entries->[0]{values}});
is("1,2", $entries->[1]{key});
is(2, scalar @{$entries->[1]{values}});
is("1,3", $entries->[2]{key});
is(1, scalar @{$entries->[2]{values}});
is("2,2", $entries->[3]{key});
is(1, scalar @{$entries->[3]{values}});
is("2,4", $entries->[4]{key});
is(2, scalar @{$entries->[4]{values}});
is("3,1", $entries->[5]{key});
is(1, scalar @{$entries->[5]{values}});
is("3,4", $entries->[6]{key});
is(1, scalar @{$entries->[6]{values}});
is("4,2", $entries->[7]{key});
is(1, scalar @{$entries->[7]{values}});

$entries = nest()->key('userid')->key('itemid')->entries($sample);
is(4, scalar @{$entries});

is(1, $entries->[0]{key});
is(3, scalar @{$entries->[0]{values}});
is(1, $entries->[0]{values}[0]{key});
is(1, scalar @{$entries->[0]{values}[0]{values}});
is(2, $entries->[0]{values}[1]{key});
is(2, scalar @{$entries->[0]{values}[1]{values}});
is(3, $entries->[0]{values}[2]{key});
is(1, scalar @{$entries->[0]{values}[2]{values}});

is(2, $entries->[1]{key});
is(2, scalar @{$entries->[1]{values}});
is(2, $entries->[1]{values}[0]{key});
is(1, scalar @{$entries->[1]{values}[0]{values}});
is(4, $entries->[1]{values}[1]{key});
is(2, scalar @{$entries->[1]{values}[1]{values}});

is(3, $entries->[2]{key});
is(2, scalar @{$entries->[2]{values}});
is(1, $entries->[2]{values}[0]{key});
is(1, scalar @{$entries->[2]{values}[0]{values}});

is(4, $entries->[3]{key});
is(1, scalar @{$entries->[3]{values}});
is(2, $entries->[3]{values}[0]{key});
is(1, scalar @{$entries->[3]{values}[0]{values}});

$entries = nest()->key('userid')->key('itemid')->rollup('sum',
                                         sub {
                                             my @data = @_;
                                             my $sum = 0;
                                             foreach my $d (@data){
                                                 $sum += $d->{quantity};
                                             }
                                             $sum;
                                         })->rollup('sumsq',
                                         sub {
                                             my @data = @_;
                                             my $sum = 0;
                                             foreach my $d (@data){
                                                 $sum += $d->{quantity} * $d->{quantity};
                                             }
                                             $sum;
                                         })->entries($sample);

is(scalar @{$entries}, 4);

is($entries->[0]{key}, 1);
is(scalar @{$entries->[0]{values}}, 3);
is($entries->[0]{values}[0]{key}, 1);
is($entries->[0]{values}[0]{sumsq}, 9);
is($entries->[0]{values}[0]{sum}, 3);
is(scalar @{$entries->[0]{values}[0]{values}}, 1);
is($entries->[0]{values}[1]{key}, 2);
is($entries->[0]{values}[1]{sumsq}, 13);
is($entries->[0]{values}[1]{sum}, 5);
is(scalar @{$entries->[0]{values}[1]{values}}, 2);
is($entries->[0]{values}[2]{key}, 3);
is($entries->[0]{values}[2]{sumsq}, 9);
is($entries->[0]{values}[2]{sum}, 3);
is(scalar @{$entries->[0]{values}[2]{values}}, 1);

is($entries->[1]{key}, 2);
is(scalar @{$entries->[1]{values}}, 2);
is($entries->[1]{values}[0]{key}, 2);
is($entries->[1]{values}[0]{sumsq}, 9);
is($entries->[1]{values}[0]{sum}, 3);
is(scalar @{$entries->[1]{values}[0]{values}}, 1);
is($entries->[1]{values}[1]{key}, 4);
is($entries->[1]{values}[1]{sumsq}, 10);
is($entries->[1]{values}[1]{sum}, 4);
is(scalar @{$entries->[1]{values}[1]{values}}, 2);

is($entries->[2]{key}, 3);
is(scalar @{$entries->[2]{values}}, 2);
is($entries->[2]{values}[0]{key}, 1);
is($entries->[2]{values}[0]{sumsq}, 9);
is($entries->[2]{values}[0]{sum}, 3);
is(scalar @{$entries->[2]{values}[0]{values}}, 1);

is($entries->[3]{key}, 4);
is(scalar @{$entries->[3]{values}}, 1);
is($entries->[3]{values}[0]{key}, 2);
is($entries->[3]{values}[0]{sumsq}, 9);
is($entries->[3]{values}[0]{sum}, 3);
is(scalar @{$entries->[3]{values}[0]{values}}, 1);

done_testing;
