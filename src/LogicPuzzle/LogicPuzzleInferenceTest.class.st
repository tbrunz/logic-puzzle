Class {
	#name : #LogicPuzzleInferenceTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleInferenceTest >> test001DeduceMatches [
	"Test that row or column of N-1 exclusions will produce row/column matches."
	
	| puzzle database relationships relationship |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 4 Attributes -> 4*3/2 = 6 relationship combinations = 12 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian #Englishman ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Dog #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Milk #Tea #Coffee ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Make some relationships to test with:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .
	
	"Verify that relations set in the truth table are what we expect:"
	self assert: (puzzle relationshipOf: #Norwegian with: #Zebra) equals: 'matched'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Tea) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Coffee) equals: 'matched'.
	
	"Verify that the rows & columns of a matched relationship are set to excluded:"
	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceMatchedRelationships ] raise: Error .
	self assert: (relationships at: #Beverage , #Nationality) isModified equals: true .

	self shouldnt: [ (relationships at: #Nationality , #Pet) deduceMatchedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Pet) isModified equals: true .

	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .

	(relationship := relationships at: #Nationality , #Pet) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceExcludedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Beverage) isModified equals: true .

	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	self shouldnt: [ puzzle relationshipOf: #Japanese with: #Tea is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Norwegian' with: 'Water' is: #Excluded ] raise: Error .
	
	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceMatchedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Beverage) isModified equals: true .

	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .

	
	"Test for deducing relationship matches:"
	self shouldnt: [ relationship deduceMatchedRelationships ] raise: Error .
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	self shouldnt: [ relationship deduceExcludedRelationships ] raise: Error .
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	self shouldnt: [ relationship deduceMatchedRelationships ] raise: Error .
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	self shouldnt: [ relationship deduceExcludedRelationships ] raise: Error .
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> test002DeduceExclusions [
	"Test that a matched relationship will produce row/column exclusions."
	
	| puzzle relationship database relationships |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 Attributes -> 3*2/2 = 3 relationship combinations = 6 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Make some relationships to test with:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .
	
	"Verify that relations set in the truth table are what we expect:"
	self assert: (puzzle relationshipOf: #Norwegian with: #Zebra) equals: 'matched'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Tea) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Coffee) equals: 'matched'.
	
	"Verify that the rows & columns of a matched relationship are set to excluded:"
	self shouldnt: [ (relationships at: #Nationality , #Pet) deduceExcludedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Pet) isModified equals: true .

	"Render the association matrix for printing:"
	(relationship := relationships at: #Nationality , #Pet) renderRelationship .
	self shouldnt: [ relationship renderRelationship ] raise: Error .
	Transcript crShow: relationship stringRepresentation .

	"Verify again for another association pair:"
	(relationships at: #Nationality , #Beverage) deduceExcludedRelationships.
	
	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceExcludedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Beverage) isModified equals: true .
	
	self assert: (puzzle relationshipOf: #Norwegian with: #Coffee) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Japanese with: #Coffee) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Coffee) equals: 'matched'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Tea) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Water) equals: 'excluded'.
	
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	"Add another match to an association that already has one:"
	self shouldnt: [ puzzle relationshipOf: #Japanese with: #Tea is: #Matched ] raise: Error .	
	self assert: (puzzle relationshipOf: #Japanese with: #Tea) equals: 'matched'.

	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceExcludedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Beverage) isModified equals: true .
	
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> test003AnalyzingRelationships [
	"Test iterating over all associations, deducing true/false, until no modifications are made."
	
	| puzzle database relationships relshpNatBev relshpNatPet relshpBevPet |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 associations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian #Englishman ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Dog #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Milk #Tea #Coffee ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Retrieve relationships created so we can inspect them:"
	relshpNatBev := relationships at: #Nationality , #Beverage .
	relshpNatPet := relationships at: #Nationality , #Pet .
	relshpBevPet := relationships at: #Beverage , #Pet .
	
	"Make some relationship matches to test with:"
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Excluded ] raise: Error .
	
	"Now test the features for this test:"
	self shouldnt: [ database analyzeRelationships ] raise: Error .
"	Transcript show: puzzle reportLog contents ."
"	Transcript show: relshpNatBev stringRepresentation ."
	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .

	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .
	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	
"self halt."

	database analyzeRelationships.
	self shouldnt: [ database analyzeRelationships ] raise: Error .
"	Transcript show: puzzle reportLog contents .
"	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	
	self shouldnt: [ puzzle relationshipOf: #Japanese with: #Tea is: #Matched ] raise: Error .	
"	self assert: (puzzle relationshipOf: 'Ukrainian' with: 'Snails') equals: 'matched'."
"	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Snails' is: 'matched' ] raise: Error ."

	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .

	self shouldnt: [ database analyzeRelationships ] raise: Error .
"	Transcript show: puzzle reportLog contents .
"	
"self halt."

	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	relshpBevPet renderRelationship .
	Transcript crShow: relshpBevPet stringRepresentation .

"self halt."
	
"	self assert: (puzzle relationshipOf: #Norwegian with: #Water) equals: 'excluded'."
	
	self shouldnt: [ database analyzeRelationships ] raise: Error .
"	Transcript show: puzzle reportLog contents .
"	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	relshpBevPet renderRelationship .
	Transcript crShow: relshpBevPet stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]
