# bloomd-loadcheck
Simple command-line tools for bloomd to load and check values piped in through STDIN.

bloomd-load.pl takes each line from STDIN and loads it into the bloomd filter named as the one and only parameter. STDIN should consist of one value per line, without any spaces (due to the way that bloomd-check.pl currently operates).

bloomd-check.pl takes the first string from each line (up to the first space), and checks for its existence in the named bloomd filter. If the string is potentially found, then the entire line is printed to STDOUT. This seemingly odd approach of taking the first string only is because I wanted to store IDs in the bloom filter, but be able to pass other information along with the ID, and print everything to STDOUT if the ID was potentially found in the filter.

When using bloomd-load.pl, the named filter will be created using the default parameters for bloomd (this is a no-op if the filter already exists). If you want a filter with specific capacity and probability, simply create it first.

Future work: add better parameter handling, including options for whether to use the entire line or just the first string in the line.
