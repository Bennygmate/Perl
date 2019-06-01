#!/usr/bin/perl -w 

if (@ARGV != 1) { 
    print "Usage: ./log_probability.pl <word-to-frequensize> at ./log_probability.pl";
    exit;
} 

$count_word = $ARGV[0];
$total_word = 0;
$word_count = 0;

foreach $file (glob "poems/*.txt") {
    open ($POEM, "$file") or die "Can't open $file";
    while ($line = <$POEM>) {
        for $word (split /[^A-Za-z]/, $line) {
            for $word (split / /, $word) {
                $total_word++;
                if (lc $word eq lc $count_word){
                    $word_count++;
                }
            }
        }
    }
    $file =~ s/\..*//;
    $file =~ s/.*\///;
    $file =~ s/\_/ /g;
    $log_word = log(($word_count + 1)/$total_word);
    printf "log((%d+1)/%6d) = %8.4f %s\n", $word_count, $total_word, $log_word, $file;
    $total_word = 0;
    $word_count = 0;
}
