Class {
	#name : #LogicPuzzleVersion10CreationTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testAddTraitsToPuzzle [
	"Test adding traits to a puzzle."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Adding traits with 3 tags should be accepted:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Adding traits with too many or too few tags should throw errors:"
	self should: [ puzzle addTrait: #House withTags: #( #Yellow #Blue #Red #Green ) ] raise: Error .
	self should: [ puzzle addTrait: #Order withTags: #( #Left #Middle ) ] raise: Error .
	
	"Adding a trait with the same name as an existing one should replace, not throw an error:"
	self assert: ((puzzle setOfTraits at: #Pet) tags at: 2) equals: #Fox .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Cat #Weasel #Zebra ) ] raise: Error .
	self assert: ((puzzle setOfTraits at: #Pet) tags at: 2) equals: #Weasel .
	
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testAssignTraitAssociations [
	"Test validating, assigning, and detecting trait associations."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Can't make associations unless the set of associations has been created."
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 3 .
	
	"Reject traits that aren't known, and trait tags that aren't part of a given trait:"
	self should: [ puzzle makeAssociation: #Country being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Swedish matches: #Pet being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Booze being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Weasel be: true ] raise: Error .
	
	"Reject any trait or tag name that isn't a string or symbol:"
	self should: [ puzzle makeAssociation: #(1 2) being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: 3 matches: #Pet being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: true being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #('abc') be: true ] raise: Error .
	
	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Tea' be: true ] raise: Error .
	
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testCreateLogicPuzzle [
	"Test behavior of the Logic Puzzle constructor."
	
	self shouldnt: [ LogicPuzzle new ] raise: Error .
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testCreatePuzzleAssociations [
	"Test creating trait associations for a puzzle."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 3 .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 associations:"
	self shouldnt: [ puzzle addTrait: #Smokes withTags: #( #Kools #Parliaments #Chesterfields ) ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 6 .
	
	"Puzzle with 5 traits -> 5*4/2 = 10 associations:"
	self shouldnt: [ puzzle addTrait: #House withTags: #( #Yellow #Blue #Green ) ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 10 .
	
	"Puzzle with 6 traits -> 6*5/2 = 15 associations:"
	self shouldnt: [ puzzle addTrait: #Order withTags: #( #Left #Middle #Right ) ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 15 .
	
	"Puzzle with 7 traits --> 7*6/2 = 21 associations:"
	self shouldnt: [ puzzle addTrait: #Food withTags: #( #Beef #Pork #Chicken ) ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 21 .
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testSetPrimaryTrait [
	"Test setting a primary trait."
	| puzzle |
	
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian #Englishman #Spaniard ) .
	puzzle addTrait: #Pet withTags: #( #Dog #Horse #Snails #Fox #Zebra ) .
	
	"A provided trait name must be a string or symbol:"
	self should: [ puzzle primaryTrait: 3 ] raise: Error .
	self should: [ puzzle primaryTrait: #( 'abc' 'def' ) ] raise: Error .
	
	"A trait name that we don't recognize is an error:"
	self should: [ puzzle primaryTrait: #JoeBob ] raise: Error .
	
	"A trait name matching a trait we know is good:"
	self shouldnt: [ puzzle primaryTrait: 'Pet' ] raise: Error .
	self shouldnt: [ puzzle primaryTrait: #Nationality ] raise: Error .
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testSetTraitTags [
	"Test validation of Trait tag arays when adding traits to a puzzle."
	
	| puzzle |
	"We need to do this in the context of a puzzle; the puzzle does validation:"
	puzzle := LogicPuzzle new .
	
	"Trait tags argument must be an array:"
	self should: [ puzzle addTrait: 'abc' withTags: 'xyz' ] raise: Error .
	self should: [ puzzle addTrait: 'abc' withTags: #xyz ] raise: Error .
	self should: [ puzzle addTrait: 'abc' withTags: 7 ] raise: Error .

	"Trait tag array must have the same size as the puzzle:"
	self should: [ puzzle addTrait: 'abc' withTags: #( abc def ) ] raise: Error .
	self should: [ puzzle addTrait: 'abc' withTags: #( abc def ghi jkl ) ] raise: Error .
	
	"Trait tag array elements must be strings or symbols:"
	self should: [ puzzle addTrait: 'abc' withTags: #( 1 2 3 ) ] raise: Error .
	
	"Trait tag array with correct size and elements is good:"
	self shouldnt: [ puzzle addTrait: 'abc' withTags: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: 'abc' withTags: #( #abc #def #ghi ) ] raise: Error .
	
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testTraitAssociationValues [
	"Test that assigning trait associations results in expected matrix values."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 3 .
	
	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Tea' be: false ] raise: Error .
	
	"Setting the same association a second time should throw an error:"
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: false ] raise: Error .
	
	"Associations should report the value they were set with; unset associations should report nil:"
	self assert: (puzzle getValueFor: #Nationality being: #Norwegian with: #Pet being: #Zebra) equals: true .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Tea) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Japanese with: #Pet being: #Snails) equals: nil .
	
]

{ #category : #tests }
LogicPuzzleVersion10CreationTest >> testTraitNaming [
	"Test validation of Trait names when adding traits to a puzzle."
	
	| puzzle |
	"We need to do this in the context of a puzzle; the puzzle does validation:"
	puzzle := LogicPuzzle new .
	
	"Trait names must be either a non-empty string or a symbol:"
	self should: [ puzzle addTrait: 1 withTags: #( abc def ghi ) ] raise: Error .
	self should: [ puzzle addTrait: #( 1 2 3 ) withTags: #( abc def ghi ) ] raise: Error .
	self should: [ puzzle addTrait: '' withTags: #( abc def ghi ) ] raise: Error .
	self should: [ puzzle addTrait: #( 'abc' ) withTags: #( abc def ghi ) ] raise: Error .
	
	"A string or symbol is allowed (since strings are cast to symbols):"
	self shouldnt: [ puzzle addTrait: 'abc' withTags: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #xyz withTags: #( abc def ghi ) ] raise: Error .
	
	"A string or symbol containing or entirely spaces, is allowed:"
	self shouldnt: [ puzzle addTrait: 'abc xyz' withTags: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #'xyz abc' withTags: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: '   ' withTags: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #' ' withTags: #( abc def ghi ) ] raise: Error .
]
