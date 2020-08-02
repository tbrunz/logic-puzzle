"
I solve the famous Zebra Puzzle...

Start by creating the puzzle, entering 
most of the provided rules, and making 
a pass at what we have so far:

LPZebraPuzzle new 
	firstPassOnTheZebraPuzzle.

Examining the output, we can infer and 
add more rules, then make another pass:

LPZebraPuzzle new 
	secondPassOnTheZebraPuzzle.

On this next pass, we make a guess...

LPZebraPuzzle new 
	thirdPassOnTheZebraPuzzle.
	
Note that this third pass reveals an 
inconsistency caused by our 'guess',
so we change to the other possibility:

LPZebraPuzzle new 
	fourthPassOnTheZebraPuzzle.

One last inference is needed:

LPZebraPuzzle new 
	solveTheZebraPuzzle.
	
The solutions appear on the Transcript.

"
Class {
	#name : #LPZebraPuzzle,
	#superclass : #Object,
	#instVars : [
		'puzzle'
	],
	#category : #'LogicPuzzle-Examples'
}

{ #category : #displaying }
LPZebraPuzzle >> displaySolutionState [
	"Display the solution state for the relationships on the Transcript:"
	
	Transcript
		crShow: '------------------------------------';
		cr.

	Transcript crShow: puzzle renderAllRelationships.
	
	puzzle attributeDatabase listInconsistencies
		ifNotEmpty: [ Transcript
				crShow: 'Puzzle is inconsistent!';
				cr ].
			
	Transcript
		crShow: '------------------------------------';
		cr
]

{ #category : #examples }
LPZebraPuzzle >> firstPassOnTheZebraPuzzle [
	"This takes a first pass on the Zebra Puzzle."

	puzzle := LogicPuzzle new.

	"Add the Zebra Puzzle Attributes and their Properties:"
	puzzle
		addAttribute: #Nationality
		withProperties: #(#Norwegian #Japanese #Englishman #Ukrainian #Spaniard).
	puzzle
		addAttribute: #Pet
		withProperties: #(#Dog #Horse #Snails #Fox #Zebra).
	puzzle
		addAttribute: #Beverage
		withProperties: #(#Water #OrangeJuice #Milk #Tea #Coffee).
	puzzle
		addAttribute: #Smokes
		withProperties: #(#Kools #LuckyStrike #Parliaments #OldGold #Chesterfields).
	puzzle
		addAttribute: #HouseColor
		withProperties: #(#Yellow #Blue #Red #Ivory #Green).
	puzzle
		addAttribute: #Sequence
		withProperties: #(#One #Two #Three #Four #Five).

	"Create the relationships among the Attributes:"
	puzzle createRelationships.
	
	"Display the newly-created truth tables:"
	self displaySolutionState.

	"Make relationship matches from the Zebra Puzzle rules:"
	puzzle relationshipOf: #Englishman with: #Red is: #Matched.
	puzzle relationshipOf: #Spaniard with: #Dog is: #Matched.
	puzzle relationshipOf: #Coffee with: #Green is: #Matched.
	puzzle relationshipOf: #Ukrainian with: #Tea is: #Matched.
	puzzle relationshipOf: #Green with: #One is: #Excluded.
	puzzle relationshipOf: #Ivory with: #Five is: #Excluded.
	puzzle relationshipOf: #OldGold with: #Snails is: #Matched.
	puzzle relationshipOf: #Kools with: #Yellow is: #Matched.
	puzzle relationshipOf: #Milk with: #Three is: #Matched.
	puzzle relationshipOf: #Norwegian with: #One is: #Matched.
	puzzle relationshipOf: #Chesterfields with: #Fox is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.
	puzzle relationshipOf: #LuckyStrike with: #OrangeJuice is: #Matched.
	puzzle relationshipOf: #Japanese with: #Parliaments is: #Matched.
	puzzle relationshipOf: #Norwegian with: #Blue is: #Excluded.

	"Analyze the data we have entered so far:"
	puzzle attributeDatabase analyzeRelationships.
	self displaySolutionState
	
	"Now examine the results on the Transcript and add more rules."
]

{ #category : #examples }
LPZebraPuzzle >> fourthPassOnTheZebraPuzzle [
	"This is the fourth pass on the Zebra Puzzle."

	puzzle := LogicPuzzle new.

	"Add the Zebra Puzzle Attributes and their Properties:"
	puzzle
		addAttribute: #Nationality
		withProperties: #(#Norwegian #Japanese #Englishman #Ukrainian #Spaniard).
	puzzle
		addAttribute: #Pet
		withProperties: #(#Dog #Horse #Snails #Fox #Zebra).
	puzzle
		addAttribute: #Beverage
		withProperties: #(#Water #OrangeJuice #Milk #Tea #Coffee).
	puzzle
		addAttribute: #Smokes
		withProperties: #(#Kools #LuckyStrike #Parliaments #OldGold #Chesterfields).
	puzzle
		addAttribute: #HouseColor
		withProperties: #(#Yellow #Blue #Red #Ivory #Green).
	puzzle
		addAttribute: #Sequence
		withProperties: #(#One #Two #Three #Four #Five).

	"Create the relationships among the Attributes:"
	puzzle createRelationships.

	"Make relationship matches from the Zebra Puzzle rules:"
	puzzle relationshipOf: #Englishman with: #Red is: #Matched.
	puzzle relationshipOf: #Spaniard with: #Dog is: #Matched.
	puzzle relationshipOf: #Coffee with: #Green is: #Matched.
	puzzle relationshipOf: #Ukrainian with: #Tea is: #Matched.
	puzzle relationshipOf: #Green with: #One is: #Excluded.
	puzzle relationshipOf: #Ivory with: #Five is: #Excluded.
	puzzle relationshipOf: #OldGold with: #Snails is: #Matched.
	puzzle relationshipOf: #Kools with: #Yellow is: #Matched.
	puzzle relationshipOf: #Milk with: #Three is: #Matched.
	puzzle relationshipOf: #Norwegian with: #One is: #Matched.
	puzzle relationshipOf: #Chesterfields with: #Fox is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.
	puzzle relationshipOf: #LuckyStrike with: #OrangeJuice is: #Matched.
	puzzle relationshipOf: #Japanese with: #Parliaments is: #Matched.
	puzzle relationshipOf: #Norwegian with: #Blue is: #Excluded.

	"These are inferred from examining the first pass at the puzzle:"
	puzzle relationshipOf: #Ivory with: #Two is: #Excluded.
	puzzle relationshipOf: #Blue with: #Two is: #Matched.
	puzzle relationshipOf: #Ivory with: #One is: #Excluded.
	puzzle relationshipOf: #Horse with: #Two is: #Matched.
	puzzle relationshipOf: #Yellow with: #Horse is: #Excluded.
	puzzle relationshipOf: #Water with: #Horse is: #Excluded.
	puzzle relationshipOf: #Norwegian with: #Horse is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.

	"Test for inconsistency: #Green = #Four --> produces an inconsistency."
	"puzzle relationshipOf: #Green with: #Four is: #Matched."
	puzzle relationshipOf: #Green with: #Five is: #Matched.
	puzzle relationshipOf: #Ivory with: #Four is: #Matched.

	"Analyze where we are now; Now we try #Green = #Five:"
	puzzle attributeDatabase analyzeRelationships.
	self displaySolutionState
	
	"Now examine the results on the Transcript and add more rules."
]

{ #category : #examples }
LPZebraPuzzle >> secondPassOnTheZebraPuzzle [
	"This is the second pass on the Zebra Puzzle."

	puzzle := LogicPuzzle new.

	"Add the Zebra Puzzle Attributes and their Properties:"
	puzzle
		addAttribute: #Nationality
		withProperties: #(#Norwegian #Japanese #Englishman #Ukrainian #Spaniard).
	puzzle
		addAttribute: #Pet
		withProperties: #(#Dog #Horse #Snails #Fox #Zebra).
	puzzle
		addAttribute: #Beverage
		withProperties: #(#Water #OrangeJuice #Milk #Tea #Coffee).
	puzzle
		addAttribute: #Smokes
		withProperties: #(#Kools #LuckyStrike #Parliaments #OldGold #Chesterfields).
	puzzle
		addAttribute: #HouseColor
		withProperties: #(#Yellow #Blue #Red #Ivory #Green).
	puzzle
		addAttribute: #Sequence
		withProperties: #(#One #Two #Three #Four #Five).

	"Create the relationships among the Attributes:"
	puzzle createRelationships.

	"Make relationship matches from the Zebra Puzzle rules:"
	puzzle relationshipOf: #Englishman with: #Red is: #Matched.
	puzzle relationshipOf: #Spaniard with: #Dog is: #Matched.
	puzzle relationshipOf: #Coffee with: #Green is: #Matched.
	puzzle relationshipOf: #Ukrainian with: #Tea is: #Matched.
	puzzle relationshipOf: #Green with: #One is: #Excluded.
	puzzle relationshipOf: #Ivory with: #Five is: #Excluded.
	puzzle relationshipOf: #OldGold with: #Snails is: #Matched.
	puzzle relationshipOf: #Kools with: #Yellow is: #Matched.
	puzzle relationshipOf: #Milk with: #Three is: #Matched.
	puzzle relationshipOf: #Norwegian with: #One is: #Matched.
	puzzle relationshipOf: #Chesterfields with: #Fox is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.
	puzzle relationshipOf: #LuckyStrike with: #OrangeJuice is: #Matched.
	puzzle relationshipOf: #Japanese with: #Parliaments is: #Matched.
	puzzle relationshipOf: #Norwegian with: #Blue is: #Excluded.

	"These are inferred from examining the first pass at the puzzle:"
	puzzle relationshipOf: #Ivory with: #Two is: #Excluded.
	puzzle relationshipOf: #Blue with: #Two is: #Matched.
	puzzle relationshipOf: #Ivory with: #One is: #Excluded.
	puzzle relationshipOf: #Horse with: #Two is: #Matched.
	puzzle relationshipOf: #Yellow with: #Horse is: #Excluded.
	puzzle relationshipOf: #Water with: #Horse is: #Excluded.
	puzzle relationshipOf: #Norwegian with: #Horse is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.

	"Again, analyze the data we have entered so far:"
	puzzle attributeDatabase analyzeRelationships.
	self displaySolutionState
	
	"Now examine the results on the Transcript and add more rules."
]

{ #category : #examples }
LPZebraPuzzle >> solveTheZebraPuzzle [
	"This is the solution to the Zebra Puzzle.
	Note that multiple analysis passes were made 
	and 'human assistance' was needed to infer 
	the last several relationship rules..."

	puzzle := LogicPuzzle new.

	"Add the Zebra Puzzle Attributes and their Properties:"
	puzzle
		addAttribute: #Nationality
		withProperties: #(#Norwegian #Japanese #Englishman #Ukrainian #Spaniard).
	puzzle
		addAttribute: #Pet
		withProperties: #(#Dog #Horse #Snails #Fox #Zebra).
	puzzle
		addAttribute: #Beverage
		withProperties: #(#Water #OrangeJuice #Milk #Tea #Coffee).
	puzzle
		addAttribute: #Smokes
		withProperties: #(#Kools #LuckyStrike #Parliaments #OldGold #Chesterfields).
	puzzle
		addAttribute: #HouseColor
		withProperties: #(#Yellow #Blue #Red #Ivory #Green).
	puzzle
		addAttribute: #Sequence
		withProperties: #(#One #Two #Three #Four #Five).

	"Create the relationships among the Attributes:"
	puzzle createRelationships.

	"Make relationship matches from the Zebra Puzzle rules:"
	puzzle relationshipOf: #Englishman with: #Red is: #Matched.
	puzzle relationshipOf: #Spaniard with: #Dog is: #Matched.
	puzzle relationshipOf: #Coffee with: #Green is: #Matched.
	puzzle relationshipOf: #Ukrainian with: #Tea is: #Matched.
	puzzle relationshipOf: #Green with: #One is: #Excluded.
	puzzle relationshipOf: #Ivory with: #Five is: #Excluded.
	puzzle relationshipOf: #OldGold with: #Snails is: #Matched.
	puzzle relationshipOf: #Kools with: #Yellow is: #Matched.
	puzzle relationshipOf: #Milk with: #Three is: #Matched.
	puzzle relationshipOf: #Norwegian with: #One is: #Matched.
	puzzle relationshipOf: #Chesterfields with: #Fox is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.
	puzzle relationshipOf: #LuckyStrike with: #OrangeJuice is: #Matched.
	puzzle relationshipOf: #Japanese with: #Parliaments is: #Matched.
	puzzle relationshipOf: #Norwegian with: #Blue is: #Excluded.

	"These are inferred from examining the first pass at the puzzle:"
	puzzle relationshipOf: #Ivory with: #Two is: #Excluded.
	puzzle relationshipOf: #Blue with: #Two is: #Matched.
	puzzle relationshipOf: #Ivory with: #One is: #Excluded.
	puzzle relationshipOf: #Horse with: #Two is: #Matched.
	puzzle relationshipOf: #Yellow with: #Horse is: #Excluded.
	puzzle relationshipOf: #Water with: #Horse is: #Excluded.
	puzzle relationshipOf: #Norwegian with: #Horse is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.

	"Test for inconsistency: #Green = #Four --> produces an inconsistency."
	"puzzle relationshipOf: #Green with: #Four is: #Matched."
	puzzle relationshipOf: #Green with: #Five is: #Matched.
	puzzle relationshipOf: #Ivory with: #Four is: #Matched.

	"Last (human) inference: #Fox must be #One:"
	puzzle relationshipOf: #Fox with: #One is: #Matched.

	"And this should solve the entire puzzle:"
	puzzle attributeDatabase analyzeRelationships.
	self displaySolutionState
]

{ #category : #examples }
LPZebraPuzzle >> thirdPassOnTheZebraPuzzle [
	"This is the third pass on the Zebra Puzzle."

	puzzle := LogicPuzzle new.

	"Add the Zebra Puzzle Attributes and their Properties:"
	puzzle
		addAttribute: #Nationality
		withProperties: #(#Norwegian #Japanese #Englishman #Ukrainian #Spaniard).
	puzzle
		addAttribute: #Pet
		withProperties: #(#Dog #Horse #Snails #Fox #Zebra).
	puzzle
		addAttribute: #Beverage
		withProperties: #(#Water #OrangeJuice #Milk #Tea #Coffee).
	puzzle
		addAttribute: #Smokes
		withProperties: #(#Kools #LuckyStrike #Parliaments #OldGold #Chesterfields).
	puzzle
		addAttribute: #HouseColor
		withProperties: #(#Yellow #Blue #Red #Ivory #Green).
	puzzle
		addAttribute: #Sequence
		withProperties: #(#One #Two #Three #Four #Five).

	"Create the relationships among the Attributes:"
	puzzle createRelationships.

	"Make relationship matches from the Zebra Puzzle rules:"
	puzzle relationshipOf: #Englishman with: #Red is: #Matched.
	puzzle relationshipOf: #Spaniard with: #Dog is: #Matched.
	puzzle relationshipOf: #Coffee with: #Green is: #Matched.
	puzzle relationshipOf: #Ukrainian with: #Tea is: #Matched.
	puzzle relationshipOf: #Green with: #One is: #Excluded.
	puzzle relationshipOf: #Ivory with: #Five is: #Excluded.
	puzzle relationshipOf: #OldGold with: #Snails is: #Matched.
	puzzle relationshipOf: #Kools with: #Yellow is: #Matched.
	puzzle relationshipOf: #Milk with: #Three is: #Matched.
	puzzle relationshipOf: #Norwegian with: #One is: #Matched.
	puzzle relationshipOf: #Chesterfields with: #Fox is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.
	puzzle relationshipOf: #LuckyStrike with: #OrangeJuice is: #Matched.
	puzzle relationshipOf: #Japanese with: #Parliaments is: #Matched.
	puzzle relationshipOf: #Norwegian with: #Blue is: #Excluded.

	"These are inferred from examining the first pass at the puzzle:"
	puzzle relationshipOf: #Ivory with: #Two is: #Excluded.
	puzzle relationshipOf: #Blue with: #Two is: #Matched.
	puzzle relationshipOf: #Ivory with: #One is: #Excluded.
	puzzle relationshipOf: #Horse with: #Two is: #Matched.
	puzzle relationshipOf: #Yellow with: #Horse is: #Excluded.
	puzzle relationshipOf: #Water with: #Horse is: #Excluded.
	puzzle relationshipOf: #Norwegian with: #Horse is: #Excluded.
	puzzle relationshipOf: #Kools with: #Horse is: #Excluded.

	"Test #Green = #Four --> we find this produces an inconsistency."
	puzzle relationshipOf: #Green with: #Four is: #Matched.

	"Analyze where we are now; We try first with #Green = #Four:"
	puzzle attributeDatabase analyzeRelationships.
	self displaySolutionState
	
	"Now examine the results on the Transcript and fix the last rule."
]
