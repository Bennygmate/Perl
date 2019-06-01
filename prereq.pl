#!/usr/bin/perl -w

my @prereqs;
my $counter = 0;
my $array = 0;
my @unique;
my %seen;

if (@ARGV != 1) {
    print "Usage: ./prereq.pl <course code> at ./prereq";
    exit;
}

$course_code = $ARGV[0];
$grad = $course_code;
$grad =~ s/\D//g;
$grad = substr($grad, 0, 1);
if ($grad lt 4) {
    $yr = "undergraduate";
} else {
    $yr = "postgraduate";
}


$url = "http://www.handbook.unsw.edu.au/$yr/courses/2015/$course_code.html";
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
    if ($line =~ /.*Prerequisite.*/) {
        $line =~ s/<.*?>//g;
        $line =~ s/Excluded:.*//g;
        @matches = $line =~ /[A-Z]{4}[0-9]{4}/gi;
        for $match (@matches) {
            push (@prereqs, $match);
            $counter++;
        }
    }
}
while ($counter gt 0) {
    $prereq = $prereqs[$array];
    $urlnext = "http://www.handbook.unsw.edu.au/$yr/courses/2015/$prereq.html";
    open F, "wget -q -O- $urlnext|" or die;
    while ($line = <F>) {
        if ($line =~ /.*Equivalent.*/) {
            $line =~ s/<.*?>//g;
            $line =~ s/CSS.*//g;
            $line =~ s/.*Equivalent//g;
            @matchesnext = $line =~ /[A-Z]{4}[0-9]{4}/gi;
            for $match (@matchesnext) {
                push (@prereqs, $match);
            }
        }
    }
$counter--;
$array++;
}

foreach $prereq (sort @prereqs) {
    if (! $seen{$prereq}++) {
        push (@unique, $prereq);
    }
}

foreach $final (sort @unique) {
        print "$final\n";
}
