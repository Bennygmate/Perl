#!/usr/bin/perl -w

if (@ARGV != 1) {
    print "Usage: ./echon.pl <whale name> at ./whale";
}

$whale_name = $ARGV[0];
$pod = 0;
$individual =0;

while ($line = <STDIN>) {
    chomp $line;
    $line =~ /(\d+)\s*(.+)\s*$/;
    $curr_species = $line and $curr_amount = $line;
    $curr_species =~ s/\d//g and $curr_species =~ s/^ //g;
    $curr_amount =~ s/\D//g;
    if ($curr_species eq $whale_name) {
    $pod++;
    $individual += $curr_amount;
    } 
}

print "$whale_name observations: $pod pods, $individual individuals\n";
