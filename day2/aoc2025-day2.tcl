#!/usr/bin/tclsh

# First we've ought to get our ranges
set ranges [gets stdin]
set ranges [split $ranges ,]

# Then we can actually get into the meat of the code.
set rollingsum 0
foreach range $ranges {
    set range [split $range -]
    set min [lindex $range 0]
    set max [lindex $range 1]

    for {set i $min} {$i <= $max} {incr i} {
	set digits [string length $i]
	set maxlen [expr {$digits / 2}]

	# Now for each length up to maxlen, we need to check that an id is not
	# composed of strenghts of length len repeated over and over again
	for {set len 1} {$len <= $maxlen} {incr len} {
	    # We only need to check this if len cleanly divides into the number
	    # of digits in the id.
	    if {($digits % $len) == 0} {
		# Split the id into a list of substrings of length len
		set subIds {}
		for {set j 0} {$j < ($digits / $len)} {incr j} {
		    lappend subIds [string range $i [expr {$j * $len}] [expr {($j * $len) + $len - 1}]]
		}

		# Now check if all the subIds are the same. If they are, it's bad.
		# We can also break the loop, so as to not double count this id.
		if {[lsearch -not $subIds [lindex $subIds 0]] == -1} {
		    puts "Got a bad id... $i"
		    set rollingsum [expr {$rollingsum + $i}]
		    break
		}
	    }
	}
    }
}

puts "The total sum is... $rollingsum \n"

    

