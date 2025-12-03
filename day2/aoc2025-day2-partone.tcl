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

	# We only need to do the check if the number has an even number of digits
	# in it. Odd-length numbers can't possibly be composed of the same string
	# repeated twice.
	if {($digits % 2) == 0} {
	    set firsthalf [string range $i 0 [expr {($digits / 2) - 1}]]
	    set lasthalf [string range $i [expr {($digits / 2)}] [expr {$digits - 1}]]
	    
	    # Then, if the first and last halves are the same, we print that we've
	    # found a bad one and add it to the rolling total.
	    if {$firsthalf eq $lasthalf} {
		puts "Got a bad id: $i, adding it to the running total"
		set rollingsum [expr {$rollingsum + $i}]
	    }
	}
    }
}

puts "The total sum is... $rollingsum \n"

    

