#!/usr/bin/perl -w

my @prereqs;
my $resursive;
my @unique;
my %seen;

if (@ARGV != 2) {
    print "Usage: ./recursive_prereq.pl -r <course code> at ./recursive_prereq";
    exit;
}

for $arg (@ARGV) {
	if ($arg =~ "-r") {
		$recursive = 1;
	} else {
		&prereqs_url($arg)
	}
}

foreach $prereq (sort @prereqs) {
    $prereq =~ tr/a-z/A-Z/;
    if (! $seen{$prereq}++) {
        push (@unique, $prereq);
    }
}

foreach $final (sort @unique) {
        print "$final\n";
}

sub prereqs_url {
	my @matches;
	$url1 = "http://www.handbook.unsw.edu.au/undergraduate/courses/2015/$_[0].html";
	$url2 = "http://www.handbook.unsw.edu.au/postgraduate/courses/2015/$_[0].html";
	open my $F, "wget -q -O- $url1 $url2|" or die;

	while ($line = <$F>) {
		if ($line =~ /.*equisite:.*/) {
            $line =~ s/<.*?>//g;
            $line =~ s/Excluded:.*//g;
			@matches = $line =~ /[A-Za-z]{4}[0-9]{4}/gi;
			for $match (@matches) {
				if (!seen($match)) {
					push(@prereqs, $match);
					&prereqs_url($match) if $recursive;
				}
			}
		} elsif ($line =~ /.*pre-requisite MTRN2500.*/) {
            @matches = $line =~ /[A-Za-z]{4}[0-9]{4}/gi;
			for $match (@matches) {
				if (!seen($match)) {
					push(@prereqs, $match);
					&prereqs_url($match) if $recursive;
				}
			}
        } elsif ($line =~ /.*Pre:*/) {
            $line =~ s/<.*?>//g;
            $line =~ s/Excluded:.*//g;
            @matches = $line =~ /[A-Za-z]{4}[0-9]{4}/gi;
			for $match (@matches) {
				if (!seen($match)) {
					push(@prereqs, $match);
					&prereqs_url($match) if $recursive;
				}
			}
        }

	}
}

sub seen {
	my $return;
	for $val_true (@prereqs) {
		if ($val_true eq $_[0]) {
			$return = 1;
		}
	}
	return $return;
}



