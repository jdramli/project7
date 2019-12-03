#  project7

Progress log:


11/28: Created repository with README.md
            Set up conditionals to track the player movement toward the cursor -- buggy

11/30:  Updated conditionals to all else-if and no sequential if statements.  This makes the movement more predictable toward the user-click (though still choppy, but fun).  The sequential if statmenets seemed to be using comparisons that were not updated from the previous position update, and therefore the movement was erratic and unpredictable before
            Added comments detaling this bug fix
            Switched the enemy speed multiplier to just a flat 2 for testing and possibly for the rest of the game.
            

12/2:  Many gameplay updates:
            Changed bullet spawns to spawn at the 4 corners of the hero
            Changed bullet path to move diagonally in the same direction in which it spawns
            Changed enemy spawn areas to upper, lower, and middle of screen.
            Added a separate game timer to spawn upgrades only every 2 seconds (adjustable now since it is on its own timer)
            
