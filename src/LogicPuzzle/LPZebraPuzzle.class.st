"
I solve the famous Zebra Puzzle...

LPZebraPuzzle new 
	solveTheZebraPuzzle.
	
The solution appears on the Transcript.

"
Class {
	#name : #LPZebraPuzzle,
	#superclass : #Object,
	#category : #'LogicPuzzle-Base'
}

{ #category : #'as yet unclassified' }
LPZebraPuzzle >> solveTheZebraPuzzle [
	"This is the solution to the Zebra Puzzle.
	Note that multiple analysis passes were made 
	and 'human assistance' was needed to infer 
	the last several relationship rules..."

	| puzzle database displayString |
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


	"Make a pair of temps for ease of analysis & inspection:"
	database := puzzle attributeDatabase.

	"Now DO THE ANALYSIS !"
	database analyzeRelationships.

	"Now display the results on the Transcript:"
	Transcript
		crShow: '------------------------------------';
		cr.
		
	displayString := puzzle renderAllRelationships.
	Transcript crShow: displayString.
	
	database listInconsistencies
		ifNotEmpty: [ Transcript
				crShow: 'Puzzle is inconsistent!';
				cr ].
			
	Transcript
		crShow: '------------------------------------';
		cr
]
