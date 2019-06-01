#!/usr/bin/perl -w 

if (@ARGV != 1) {
    print "Usage ./count_world.pl <Counted Word> at ./count_word.pl";
    exit;
} 

$count_word = lc $ARGV[0];
$word_count = 0;

while ($line = <STDIN>) {
    for $word (split /[^A-Za-z]/, $line) {
        for (split / /, $word) {
            if (lc $word eq $count_word) {
                $word_count++;
            }
        }
    }
}

print "$count_word occurred $word_count times\n";
