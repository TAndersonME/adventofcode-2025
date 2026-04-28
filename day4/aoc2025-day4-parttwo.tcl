#!/usr/bin/tclsh

# Global configuration
set checkRadius 1
set maxRolls 3

# Obtain the input.
set rows(0) ""
for {set i 0} {[gets stdin line] != -1} {incr i} {
    set rows($i) $line
}

# Utility function for counting the number of times any character in a set occurs in a string
proc countChar {str char} {
    set occurances 0

    set str [regsub -all "\[^$char\]" $str "0"]
    set str [regsub -all "\[$char\]" $str "1"]
    
    set digits [split $str ""]
    
    foreach digit $digits {
	set occurances [expr {$occurances + $digit}]
    }

    return $occurances
}

# Initially count how many rolls there are
set currCount 0
foreach {index row} [array get rows] {
    set currCount [expr {$currCount + [countChar $row @]}]
}

# Initalize lastCount so the following loop can start
set lastCount [expr {$currCount + 1}]

# Now loop over and remove rolls until the number of rolls stops changing, counting
# how many are removed along the way.
set removedRolls 0

while {$lastCount > $currCount} {
    set lastCount $currCount
    puts "Removing rolls..."
    
    for {set i 0} {$i <= ([array size rows] - 1)} {incr i} {
	set row $rows($i)
	
	for {set j 0} {$j <= ([string length $row] - 1)} {incr j} {
	    # The loop can and should be skipped entirely if this isn't a roll of paper.
	    if {[string index $row $j] eq "."} {
		puts "Skipping..."
		continue
	    }

	    puts "Counting how many rolls are nearby..."
	    set nearbyRolls 0
	    
	    for {set k [expr {$i - $checkRadius}]} {$k <= ($i + $checkRadius)} {incr k} {
		# This loop can and should be skipped if it tries to inspect a line that
		# doesn't exist.
		if {($k < 0) || ($k > ([array size rows] - 1))} {
		    continue
		}

		set tempRow $rows($k)
		if {$k == $i} {
		    set tempRow [string replace $tempRow $j $j "."]
		}

		set checkSegment [string range $tempRow [expr {$j - $checkRadius}] [expr {$j + $checkRadius}]]

		puts "Checking on ** $checkSegment **..."

		set nearbyRolls [expr {$nearbyRolls + [countChar $checkSegment {@}]}]
	    }

	    puts "$nearbyRolls rolls are nearby..."
	    if {$nearbyRolls <= $maxRolls} {
		set rows($i) [string replace $rows($i) $j $j "."]
		puts "And that's less than or equal to $maxRolls, so we can remove this roll and are doing so"
		incr removedRolls
	    }
	}
    }

    set currCount 0
    foreach {index row} [array get rows] {
	set currCount [expr {$currCount + [countChar $row @]}]
    }
    puts "We have removed $removedRolls rolls"
    puts "Now $currCount rolls remain..."
}
