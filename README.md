# Logic Puzzle
### Pharo application to assist in solving "logic puzzles".

Logic puzzles, of which many versions exist, are a type of deductive "constraint satisfaction problem". 
They are perhaps best understood by example, the most familiar of which is the so-called "**Zebra Puzzle**". 

The Zebra puzzle has been used as a benchmark in the evaluation of computer algorithms for 
solving constraint satisfaction problems.

Listed below is the version published in _Life International Magazine_ in 1962. 
Other versions of the puzzle have various differences from the _Life International_ puzzle, 
in which various colors, nationalities, cigarette brands, drinks, and pets are substituted, 
or the clues are given in a different order. These do not change the logic of the puzzle.

```
 1. There are five houses.
 2. The Englishman lives in the red house.
 3. The Spaniard owns the dog.
 4. Coffee is drunk in the green house.
 5. The Ukrainian drinks tea.
 6. The green house is immediately to the right of the ivory house.
 7. The Old Gold smoker owns snails.
 8. Kools are smoked in the yellow house.
 9. Milk is drunk in the middle house.
10. The Norwegian lives in the first house.
11. The man who smokes Chesterfields lives in the house next to the man with the fox.
12. Kools are smoked in the house next to the house where the horse is kept.
13. The Lucky Strike smoker drinks orange juice.
14. The Japanese smokes Parliaments.
15. The Norwegian lives next to the blue house.

Now, who drinks water? Who owns the zebra?

In the interest of clarity, it must be added that each of the five houses is painted a different color, 
and their inhabitants are of different national extractions, own different pets, drink different beverages, 
and smoke different brands of American cigarettes. One other thing: in statement 6, 'right' means your right.  
 -- Life International, December 17, 1962
 ```
 
 This project is a Pharo application that will assist in keeping track of all the associations involving the 
 various traits, as well as all the logical deductions and inferences that can be made, consistent with the 
 constraints listed.  The app is being developed in 64-bit Pharo 8.
