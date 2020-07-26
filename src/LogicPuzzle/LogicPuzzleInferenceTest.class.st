Class {
	#name : #LogicPuzzleInferenceTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleInferenceTest >> test001DeduceExclusions [
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
	
	Transcript crShow: '------------------------------------'; cr.
	
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
LogicPuzzleInferenceTest >> test002DeduceMatches [
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
	
	Transcript crShow: '------------------------------------'; cr.
	
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
	(relationship := relationships at: #Nationality , #Beverage) renderRelationship .
	Transcript crShow: relationship stringRepresentation .

	self shouldnt: [ (relationships at: #Nationality , #Pet) deduceMatchedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Pet) isModified equals: true .
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

	
	"Test for deducing relationship matches; these should progressively fill in the Truth Table:"
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
LogicPuzzleInferenceTest >> test003TrapInconsistencies [
	"Test that a matched relationship will produce row/column exclusions."
	
	| puzzle relationship database relationships relshpNatBev relshpNatPet |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 Attributes -> 3*2/2 = 3 relationship combinations = 6 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Retrieve relationships created so we can inspect them:"
	relshpNatBev := relationships at: #Nationality , #Beverage .
	relshpNatPet := relationships at: #Nationality , #Pet .
	
	Transcript crShow: '------------------------------------'; cr.
	
	"Attempt to create multiple matches for a Property:"
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .

	self shouldnt: [ relshpNatBev deduceExcludedRelationships ] raise: Error .
	self assert: relshpNatBev isModified equals: true .
	self assert: relshpNatBev isInconsistent equals: true .
	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .

	
	"Attempt to create multiple exclusions for a Property:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #Matched ] raise: Error .
	self assert: (puzzle relationshipOf: #Norwegian with: #Zebra) equals: 'matched'.
	
	self shouldnt: [ puzzle relationshipOf: #Ukrainian with: #Zebra is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Ukrainian with: #Snails is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Ukrainian with: #Fox is: #Excluded ] raise: Error .
	
	self shouldnt: [ relshpNatPet deduceMatchedRelationships ] raise: Error .
	self assert: relshpNatPet isModified equals: true .
	self assert: relshpNatPet isInconsistent equals: true .

	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> test004AnalyzeRelationships [
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
	
	Transcript crShow: '------------------------------------'; cr.
	
	"Make some relationship matches to test with:"
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Excluded ] raise: Error .
	
	"Now test the features for this test:"
	self shouldnt: [ database analyzeRelationships ] raise: Error .
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .

	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .

database analyzeRelationships.
	self shouldnt: [ database analyzeRelationships ] raise: Error .
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	
	self shouldnt: [ puzzle relationshipOf: #Japanese with: #Tea is: #Matched ] raise: Error .	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .

	self assert: (puzzle relationshipOf: 'Ukrainian' with: 'Snails') equals: 'unknown'.
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Snails' is: 'matched' ] raise: Error .
	
	self shouldnt: [ database analyzeRelationships ] raise: Error .	
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	relshpBevPet renderRelationship .
	Transcript crShow: relshpBevPet stringRepresentation .

	
	self assert: (puzzle relationshipOf: #Norwegian with: #Water) equals: 'unknown'.
	self shouldnt: [ puzzle relationshipOf: 'Norwegian' with: 'Water' is: 'excluded' ] raise: Error .
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	
	self shouldnt: [ database analyzeRelationships ] raise: Error .
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	relshpBevPet renderRelationship .
	Transcript crShow: relshpBevPet stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> test005Inferencing [
	"Test RelationshipTrio inferences."
	
	| puzzle database relationships relshpNatCol relshpNatPet relshpPetCol |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 6 Attributes -> 6*5/2 = 15 relationship combinations = 30 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Dog #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #HouseColor withProperties: #( #Yellow #Blue #Red ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Make some relationship matches from the Zebra Puzzle:"
	self shouldnt: [ puzzle relationshipOf: #Ukrainian with: #Fox is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Japanese with: #Red is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Zebra with: #Yellow is: #Matched ] raise: Error .
	
	"Retrieve relationships created so we can inspect them:"
	relshpNatPet := relationships at: #Nationality , #Pet .
	relshpNatCol := relationships at: #Nationality , #HouseColor.
	relshpPetCol := relationships at: #Pet , #HouseColor.
	
	Transcript crShow: '------------------------------------'; cr.

	self shouldnt: [ database analyzeRelationships ] raise: Error .
	self assert: relshpNatPet isInconsistent equals: false .	
	self assert: relshpNatCol isInconsistent equals: false .	
	self assert: relshpPetCol isInconsistent equals: false .	
	
	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	relshpNatCol renderRelationship .
	Transcript crShow: relshpNatCol stringRepresentation .
	relshpPetCol renderRelationship .
	Transcript crShow: relshpPetCol stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> test006ZebraPuzzle [
	"Test the Zebra Puzzle."
	
	| puzzle database relationships relshpNatBev relshpNatPet relshpBevPet relshpNatSmk relshpNatCol relshpNatSeq relshpBevSmk relshpBevCol relshpBevSeq relshpPetSmk relshpPetCol relshpPetSeq relshpSmkCol relshpSmkSeq relshpColSeq |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 6 Attributes -> 6*5/2 = 15 relationship combinations = 30 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Englishman #Ukrainian #Spaniard ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Dog #Horse #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #OrangeJuice #Milk #Tea #Coffee ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Smokes withProperties: #( #Kools #LuckyStrike #Parliaments #OldGold #Chesterfields ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #HouseColor withProperties: #( #Yellow #Blue #Red #Ivory #Green ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Sequence withProperties: #( #One #Two #Three #Four #Five ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Make some relationship matches from the Zebra Puzzle:"
	self shouldnt: [ puzzle relationshipOf: #Englishman with: #Red is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Spaniard with: #Dog is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Coffee with: #Green is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Ukrainian with: #Tea is: #Matched ] raise: Error .
	
	self shouldnt: [ puzzle relationshipOf: #Green with: #One is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Ivory with: #Five is: #Excluded ] raise: Error .
	
	self shouldnt: [ puzzle relationshipOf: #OldGold with: #Snails is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Kools with: #Yellow is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Milk with: #Three is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #One is: #Matched ] raise: Error .
	
	self shouldnt: [ puzzle relationshipOf: #Chesterfields with: #Fox is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Kools with: #Horse is: #Excluded ] raise: Error .
	
	self shouldnt: [ puzzle relationshipOf: #LuckyStrike with: #OrangeJuice is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Japanese with: #Parliaments is: #Matched ] raise: Error .
	
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Blue is: #Excluded ] raise: Error .
	
	"Retrieve relationships created so we can inspect them:"
	relshpNatBev := relationships at: #Nationality , #Beverage .
	relshpNatPet := relationships at: #Nationality , #Pet .
	relshpNatSmk := relationships at: #Nationality , #Smokes.
	relshpNatCol := relationships at: #Nationality , #HouseColor.
	relshpNatSeq := relationships at: #Nationality , #Sequence.
	relshpBevPet := relationships at: #Beverage , #Pet .
	relshpBevSmk := relationships at: #Beverage , #Smokes.
	relshpBevCol := relationships at: #Beverage , #HouseColor.
	relshpBevSeq := relationships at: #Beverage , #Sequence.
	relshpPetSmk := relationships at: #Pet , #Smokes.
	relshpPetCol := relationships at: #Pet , #HouseColor.
	relshpPetSeq := relationships at: #Pet , #Sequence.
	relshpSmkCol := relationships at: #Smokes , #HouseColor.
	relshpSmkSeq := relationships at: #Smokes , #Sequence.
	relshpColSeq := relationships at: #HouseColor , #Sequence.
	
	Transcript crShow: '------------------------------------'; cr.
	
	self shouldnt: [ database analyzeRelationships ] raise: Error .
	relshpNatBev renderRelationship .
	Transcript crShow: relshpNatBev stringRepresentation .
	relshpNatPet renderRelationship .
	Transcript crShow: relshpNatPet stringRepresentation .
	relshpNatSmk renderRelationship .
	Transcript crShow: relshpNatSmk stringRepresentation .
	relshpNatCol renderRelationship .
	Transcript crShow: relshpNatCol stringRepresentation .
	relshpNatSeq renderRelationship .
	Transcript crShow: relshpNatSeq stringRepresentation .
	relshpBevPet renderRelationship .
	Transcript crShow: relshpBevPet stringRepresentation .
	relshpBevSmk renderRelationship .
	Transcript crShow: relshpBevSmk stringRepresentation .
	relshpBevCol renderRelationship .
	Transcript crShow: relshpBevCol stringRepresentation .
	relshpBevSeq renderRelationship .
	Transcript crShow: relshpBevSeq stringRepresentation .
	relshpPetSmk renderRelationship .
	Transcript crShow: relshpPetSmk stringRepresentation .
	relshpPetCol renderRelationship .
	Transcript crShow: relshpPetCol stringRepresentation .
	relshpPetSeq renderRelationship .
	Transcript crShow: relshpPetSeq stringRepresentation .
	relshpSmkCol renderRelationship .
	Transcript crShow: relshpSmkCol stringRepresentation .
	relshpSmkSeq renderRelationship .
	Transcript crShow: relshpSmkSeq stringRepresentation .
	relshpColSeq renderRelationship .
	Transcript crShow: relshpColSeq stringRepresentation .
	
	Transcript crShow: '------------------------------------'; cr 
	
]
