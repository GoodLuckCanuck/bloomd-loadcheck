#!/usr/bin/perl -I /root/vanitygen/Bloomd-Client/lib

# Usage: cat keys.txt | bloomcheck.pl filter_name
# This will use the characters before the first space as the key -- all remaining characters are printed, but not used in the bloomd check.
# This will print only those items from STDIN that have a possible match in each bloom filter (one line might result in matches in more than one filter).

use feature ':5.12';
use Bloomd::Client;
use English;
use Data::Dumper;

select(STDERR);
$| = 1;
select(STDOUT); # default
$| = 1;

my $b = Bloomd::Client->new,
my @filters, $lines, @keys, $results;

my @filters      = @ARGV;
my $max_length   = 2500;
my $cur_length   = 0;
my $aref_lines   = [];
my $aref_keys    = [];
my $href_results = {};


while (<STDIN>)
{
    my $line = $_;
    chomp( $line );
    next if $line =~ /^$/;
    my ($key) = $line =~ /([^ ]*)/;
    $cur_length += length($key)+1;
    push( @{$aref_keys},  $key );
    push( @{$aref_lines}, $line );
    if ($cur_length > $max_length)
    {
        foreach my $filter (@filters)
        {
            $href_results = $b->multi($filter, @{$aref_keys});
            printResults($href_results,$aref_keys,$aref_lines);
        }
        $cur_length = 0;
        @{$aref_keys}    = ();
        @{$aref_lines}   = ();
    }
}
foreach my $filter (@filters)
{
    $href_results = $b->multi($filter, @{$aref_keys});
    printResults($href_results,$aref_keys,$aref_lines);
}

sub printResults
{
    my $results = shift;
    my $keys    = shift;
    my $lines   = shift;
    #foreach my $key (@{$keys})
    for ( my $idx = 0; $idx < scalar(@{$keys}); $idx++ )
    {
        my $key   = $keys->[$idx];
        my $line  = $lines->[$idx];
        print( "$line\n" ) if $results->{$key};
        #my $found = $results->{$key}?"YES":"NO";
        #print( "$line ($found)\n" );
    }
}
