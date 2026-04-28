#!/usr/bin/tclsh

# Global configuration for the number of digits to select.
set maxDigits 12

# Utility function which finds the biggest set of batteries.
proc findBattSequence {bank} {
    global maxDigits

    set altBank $bank
    set battIndexes {}
    set primary $bank
    set reserves {}
    set reserve {}

    
    
    while {[llength $battIndexes] < 12} {
	set usedReserve 0

	# Find the first digit in primary which is geq all other digits we search
	# Primary first because we want to prioritize having the largest first digit.
	set bigDigitIndex -1
	for {set i 9} {($i >= 1) && (bigDigitIndex == -1)} {set i [expr {$i - 1}]} {
	    set bigDigitIndex [string first $i $primary]
	}

	# If bigDigitIndex is still -1, then primary is empty (we ran out of digits)
	# and have to look for a digit in reserve. We also set a flag that we had to
	# pull from the reserve set since that affects how the index is used.
	for {set i 9; set usedReserve 1} {($i >= 1) && (bigDigitIndex == -1)} {set i [expr {$i - 1}]} {
	    set bigDigitIndex [string first $i $primary]
	}

	# Now we have to set for the next time we call the function.
	set newReserveStart 0
	set newPrimaryStart 0
	# When using primary, we set up new values based on PrimaryStart and split the primary.
	if {usedReserve == 0} {
	    lappend battIndexes [expr {$bigDigitIndex + $primaryStart}]
	    set newReserveStart $primaryStart
	    set newPrimaryStart [expr {$bigDigitIndex + $primaryStart + 1}]
	} else {
	    lappend battIndexes [expr {$bigDigitIndex + $reserveStart}]
	    set newReserveStart $reserveStart
	    set newPrimaryStart [expr {$bigDigitIndex + $reserveStart + 1}]
	}

	set reserve [string range $bank $newReserveStart [expr {$newPrimaryStart - 1}]]
	# Figure out how to keep track of the end of the primary and reserve.
    }

    ### LOOP ENDS HERE
	
}

# Grab all the banks and put them in a list
set banks {}
while {[gets stdin bank] >= 0} {
    lappend banks $bank
}

# Then for each bank, we first look for the biggest number we can find and sum 'em all up
set totalJoltage 0
foreach bank $banks {
    
}

puts "The total joltage is... $totalJoltage"
