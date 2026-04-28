#!/usr/bin/tclsh

# Grab all the banks and put them in a list
set banks {}
while {[gets stdin bank] >= 0} {
    lappend banks $bank
}

# Then for each bank, we first look for the biggest number we can find and sum 'em all up
set totalJoltage 0
foreach bank $banks {
    set firstDigit 0
    set secondDigit 0

    # First we find the index of the first largest digit.
    set firstBattIndex -1
    for {set i 9} {($i >= 1) && ($firstBattIndex == -1)} {set i [expr {$i - 1}]} {
	set firstBattIndex [string first $i $bank]
    }

    # Most of the time, this will be the first digit.
    set firstDigit [string index $bank $firstBattIndex]

    # But if firstI is the last digit, then we set it to secondDigit and find
    # the largest digit coming before. The variable names get twisted in this
    # specific case.
    set secondBattIndex -1
    if {$firstBattIndex == ([string length $bank] - 1)} {
	set secondDigit $firstDigit

	# We can assume in this case that we can start with a digit smaller is that if
	# the first biggest digit is the last one, then it can't occur at any point
	# before the last digit.
	for {set i [expr {$firstDigit - 1}]} {($i >= 1) && ($secondBattIndex == -1)} {set i [expr {$i - 1}]} {
	    set secondBattIndex [string first $i $bank]
	}

	# This is the minority of the time that firstDigit isn't the biggest one.
	set firstDigit [string index $bank $secondBattIndex]
    } else {
	# Now that we can assume our digit isn't the last one, we just look for the
	# biggest one that comes after.
	for {set i 9} {($i >= 1) && ($secondBattIndex == -1)} {set i [expr {$i - 1}]} {
	    set secondBattIndex [string first $i $bank [expr {$firstBattIndex + 1}]]
	}

	set secondDigit [string index $bank $secondBattIndex]
    }

    set joltage [string cat $firstDigit $secondDigit]

    set totalJoltage [expr {$totalJoltage + $joltage}]

    puts "This round has a joltage of... $joltage"
}

puts "The total joltage is... $totalJoltage"
