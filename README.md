#  project7
While the core concept of this game is similar to the previous projects 5 and 6, I have dove a level deeper into the intricacies of interactions of player input and its and object angles/directions.  This project also has 2 additional object nodes added, which seem to significantly increase the code complexity and collision interaction complexity.  

I have implemented some visual changes as well (background and player images) to add some distinction.  While these are not as demanding of a task as thinking about how to code the physics and gameplay, it was a good reminder that adding some new art can make things fresh and fun.

Regarding the physics, I have implemented almost everything that I wanted to see experimentally.  The behavior of the final big_block is now fixed to where it will contact and disrupt the enemy nodes while not colliding with the player or the bullets or the upgrades.  The biggest achievement in my opinion is the implementation of a shot to respond in the general direction of a click, relative to the player.  Also, I have duplicated successfully multiple game timers and UI Bezier paths, both of which I find vital to any game being developed.  

I was able to make use of the Singletone class again in another scenario to modify a parameter on the start-screen which will actually affect the gameplay on the game screen (the speed of player movement).

Overall, I have obtained a great deal of confidence in handling certain physics and contact situations in Swift, and furthermore have developed even more curiosity as to what a better solution would look like when implemented.  I am interested in what a cleaner code outline/implementation would look like to produce similar results or handle these physics interactions more efficiently. 


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
            

12/5: Completed physics interactions of "melee_upgrade" green balls.
        Created a count modifier of the green ball contact with player only
        Resolved issue where bullets were impacting the green ball
        Working on creating a kinematic body upon contact with 5 green ball upgrades.



12/6:  Updated background picture
            Added speed adjustment to main screen (two separate buttons)
            Added a labelnode to track hero speed change
            Made the speed adjustable in the Singleton
            Updated movement of player in main game based on speed variable.



12/7: Added a big_block circle that is supposed to just crash into and push everything it hits
        Effectively added a new UI Bezier path for the big_block to travel from the hero to off-screen.
        Experiencing physicsbody collision detection bugs, it is not contacting anything.
        Finally resolved all unintended  bugs (i.e. some 'bug'-looking issues where one object goes through another is intentional)
        Made touch-ups for final commit.
        
        
