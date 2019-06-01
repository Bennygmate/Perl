#!/usr/bin/perl -w 

if (@ARGV != 1) {
    print "Usage: ./frequency.pl <word to count> at ./frequency.pl";
    exit;
}

$total_word = 0;
$word_count = 0;
$count_word = $ARGV[0];

foreach $file (glob "poems/*.txt") {
    open ($POEM, "$file") or die "Can't open $file";
    while ($line = <$POEM>) {
        for $word (split /[^A-Za-z]/, $line) {
            for $word (split / /, $word) {
                $total_word++;
                if (lc $word eq lc $count_word) {
                    $word_count++;
                }
            }
        }
    }
    $division = ($word_count/$total_word);
    $file =~ s/.*\///;
    $file =~ s/_/ /g;
    $file =~ s/\..*//;
    printf ("%4d/%6d = %.9f %s\n", $word_count, $total_word, $division, $file);
    $word_count = 0;
    $total_word = 0;
}

