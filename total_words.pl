#!/usr/bin/perl -w 

$count = 0;

while ($line = <STDIN>) {
    for $word (split /[^A-Za-z]/, $line) {
        for (split / /, $word) {
        $count++;
        }
    }
}

print "$count words\n";
