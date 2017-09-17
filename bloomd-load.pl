#!/usr/bin/perl -I /root/vanitygen/Bloomd-Client/lib

# Usage: cat keys.txt | bloomload.pl filter_name

use feature ':5.12';
use Bloomd::Client;
use English;

my $max_size_threshold = 1400;

my $b = Bloomd::Client->new,
my $current_size = 0;
my $filter = $ARGV[0];
$b->create($filter);
while (<STDIN>)
{
    my $line = $_;
    chomp( $line );
    $current_size += length($line);
    push( @keys, $line );
    if ($current_size > $max_size_threshold)
    {
        $b->bulk($filter, @keys);
        $current_size = 0;
        @keys = ();
    }
}
$b->bulk($filter, @keys);

my $array_ref = $b->list();
my $hash_ref = $b->info($filter);
use Data::Dumper;
print Dumper($hash_ref);
print( "Count:$count\n");
