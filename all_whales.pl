#!/usr/bin/perl -w

%pod = ();
%individual = ();


while ($line = <STDIN>) {
    $line =~ /^(\d+)\s+(.*)\s*$/;
    $num = $1;
    $whale = $2;
    $whale =~ tr/A-Z/a-z/;
    $whale =~ s/s$//g;
    $whale =~ s/\s+/ /g; 
    $whale =~ s/\s$//g;
    $pod{$whale}++;
    $individual{$whale} += $num;
}

foreach $whale_name (sort keys %pod) {
    print "$whale_name observations: $pod{$whale_name} pods, $individual{$whale_name} individuals\n";
}
