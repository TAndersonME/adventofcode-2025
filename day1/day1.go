package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)

	currPos := 50
	nextPos := currPos
	zeroes := 0
	for stdin.Scan() {
		line := stdin.Text()
		dir := fmt.Sprintf("%.1s", line)
		clicks, err := strconv.ParseInt(strings.TrimLeft(line, "LR"), 10, 0)
		if err != nil {
			fmt.Println(err)
			return
		}

		currPos = nextPos

		zeroes += (int(clicks) / 100)

		// Our next pos depends on direction and the number of clicks after
		// full rotations.
		switch dir {
		case "L":
			nextPos -= (int(clicks) % 100)
		case "R":
			nextPos += (int(clicks) % 100)
		}

		// The rest of the loop can be skipped if we started at 0 since we
		// can't score any more zeroes than the number of full loops.
		// We also don't need any further adjustment except making sure
		// that we fix negative positions, since we can't loop around
		// any more times.
		if currPos == 0 {
			// We have to go backwards from 100, but nextPos is already
			// negative so it's pretty easy.
			if nextPos < 0 {
				nextPos = 100 + nextPos
			}
			continue
		}

		// Now that we know we haven't started at 0 we can make more assumptions

		// If the next position is 0 then we increment the counter because we
		// landed on 0. No more scoring or adjustment is required and the rest
		// is skipped.
		if nextPos == 0 {
			zeroes++
			continue
		}

		// If the next pos is greater than 100, then we crossed zero and have to
		// loop back around.
		if nextPos >= 100 {
			zeroes++
			nextPos %= 100
		}

		// If the next pos is negative, then we also crossed zero and have to
		// loop back around, but the logic is slightly different.
		if nextPos < 0 {
			zeroes++
			nextPos %= 100
			nextPos = 100 + nextPos
		}

		// Then we're done and we can keep on going again.
	}
	fmt.Println("And the total number of zeroes is... \n", zeroes)

	if err := stdin.Err(); err != nil {
		fmt.Println(err)
	}
}
