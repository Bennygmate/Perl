#!/usr/bin/perl -w 

%frequency = ();
%log_poet = ();
$total_word = 0;
$word_count = 0;
$big_log = 0;
$final_poet = "";

foreach $file (glob "poems/*.txt") {
    open ($POEM, "$file") or die "Can't open $file";
    $file =~ s/\..*//;
    $file =~ s/.*\///;
    $file =~ s/\_/ /g;
    while ($line = <$POEM>) {
        for $word (split /[^A-Za-z]/, $line) {
            for $word (split / /, $word) {
                $frequency{$file}{$word}++;
            }
        }
    }
}

foreach $arg (@ARGV) {
    foreach $poem_file (glob $arg) {
        open ($POEM_FILE, "$poem_file") or die "Can't open $poem_file";
        while ($poem_line = <$POEM_FILE>) {
            for $poem_word (split /[^A-Za-z]/, $poem_line) {
                for $poem_word (split / /, $poem_word) {
                    &check_word($poem_word);
                }
            }
        }

    }
    foreach $poets (keys %log_poet) {
    #print "$arg: log_probability of $log_poet{$poets} for $poets\n";
    if ($big_log gt $log_poet{$poets}) {
        $big_log = $log_poet{$poets};
        $final_poet = $poets;
     }
    delete $log_poet{$poets};
    }
    printf "%s most resembles the work of %s (log-probability=%.1f)\n", $arg, $final_poet, $big_log;
    $big_log = 0;
    $final_poet = "";
}



sub check_word {
    $check_word = $poem_word;
    foreach $poet (keys %frequency) {
        foreach $word (keys %{$frequency{$poet}}) {
            if (lc $word eq lc $check_word) {
                $word_count += $frequency{$poet}{$word};
            }
            $total_word += $frequency{$poet}{$word};
        }
        $log_word = log(($word_count + 1)/$total_word);
 #   print "log ($word_count + 1) / $total_word = $log_word) $poet \n";
        $log_poet{$poet} += $log_word;
     $word_count = 0;
    $total_word = 0;
    }
}


