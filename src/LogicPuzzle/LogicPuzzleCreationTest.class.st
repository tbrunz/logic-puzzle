Class {
	#name : #LogicPuzzleCreationTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleCreationTest >> testAddTraitsToPuzzle [
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
	self assert: ((puzzle traitsDB tagsOfTrait: #Pet) at: 2) name equals: #Fox .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Cat #Weasel #Horse ) ] raise: Error .
	self assert: ((puzzle traitsDB tagsOfTrait: #Pet) at: 2) name equals: #Weasel .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testAssociatingTraits [
	"Test validating, assigning, and detecting trait associations."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Can't make associations unless the set of associations has been created."
	self should: [ puzzle associationOf: #Norwegian with: #Zebra is: true ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 3 .
	
	"Reject traits that aren't known, and trait tags that aren't part of a given trait:"
	self should: [ puzzle associationOf: #Swedish with: #Zebra is: true ] raise: Error .
	self should: [ puzzle associationOf: #Norwegian with: #Weasel is: true ] raise: Error .
	
	"Reject any trait or tag name that isn't a string or symbol:"
	self should: [ puzzle associationOf: 3 with: #Zebra is: true ] raise: Error .
	self should: [ puzzle associationOf: #Norwegian with: #('abc') is: true ] raise: Error .
	
	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle associationOf: #Norwegian with: #Zebra is: true ] raise: Error .
	self shouldnt: [ puzzle associationOf: 'Ukrainian' with: 'Tea' is: true ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateLogicPuzzle [
	"Test behavior of the Logic Puzzle constructor."
	
	self shouldnt: [ LogicPuzzle new ] raise: Error
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateTraitTables [
	"Test creating trait associations for a puzzle."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	self assert: (puzzle createTraitTables) size equals: 3 .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 associations:"
	self shouldnt: [ puzzle addTrait: #Smokes withTags: #( #Kools #Parliaments #Chesterfields ) ] raise: Error .
	self assert: (puzzle createTraitTables) size equals: 6 .
	
	"Puzzle with 5 traits -> 5*4/2 = 10 associations:"
	self shouldnt: [ puzzle addTrait: #House withTags: #( #Yellow #Blue #Green ) ] raise: Error .
	self assert: (puzzle createTraitTables) size equals: 10 .
	
	"Puzzle with 6 traits -> 6*5/2 = 15 associations:"
	self shouldnt: [ puzzle addTrait: #Order withTags: #( #Left #Middle #Right ) ] raise: Error .
	self assert: (puzzle createTraitTables) size equals: 15 .
	
	"Puzzle with 7 traits --> 7*6/2 = 21 associations:"
	self shouldnt: [ puzzle addTrait: #Food withTags: #( #Beef #Pork #Chicken ) ] raise: Error .
	self assert: (puzzle createTraitTables) size equals: 21 .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testSetPrimaryTrait [
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
LogicPuzzleCreationTest >> testSetTraitTags [
	"Test validation of Trait tag arays when adding traits to a puzzle."
	
	| puzzle |
	"We need to do this in the context of a puzzle; the puzzle does validation:"
	puzzle := LogicPuzzle new .
	
	"Trait tags argument must be an array:"
	self should: [ puzzle addTrait: 'abc' withTags: 'xyz' ] raise: Error .
	self should: [ puzzle addTrait: 'def' withTags: #uvw ] raise: Error .
	self should: [ puzzle addTrait: 'ghi' withTags: 7 ] raise: Error .

	"Trait tag array must have the same size as the puzzle:"
	self shouldnt: [ puzzle addTrait: 'jkl' withTags: #( ab bc cd de ) ] raise: Error .
	self should: [ puzzle addTrait: 'mno' withTags: #( ef fg gh ) ] raise: Error .
	self should: [ puzzle addTrait: 'pqr' withTags: #( hi ij jk kl lm ) ] raise: Error .
	
	"Trait tag array elements must be strings or symbols:"
	self should: [ puzzle addTrait: 'stu' withTags: #( 1 2 3 4 ) ] raise: Error .
	
	"Trait tag array with correct size and elements is good:"
	self shouldnt: [ puzzle addTrait: 'vwx' withTags: #( mn no op pq ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: 'yza' withTags: #( #qr #rs #st #tu ) ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testTraitAssociations [
	"Test that associating traits results in expected matrix values."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	self assert: (puzzle createTraitTables) size equals: 3 .
	
	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle associationOf: #Norwegian with: #Zebra is: true ] raise: Error .
	self shouldnt: [ puzzle associationOf: 'Ukrainian' with: 'Tea' is: false ] raise: Error .
	
	"Setting the same association a second time should throw an error:"
	self should: [ puzzle associationOf: #Norwegian with: #Zebra is: true ] raise: Error .
	self should: [ puzzle associationOf: #Norwegian with: #Zebra is: false ] raise: Error .
	
	"Associations should report the value they were set with; unset associations should report nil:"
	self assert: (puzzle associationOf: #Norwegian with: #Zebra) equals: true .
	self assert: (puzzle associationOf: #Ukrainian with: #Tea) equals: false .
	self assert: (puzzle associationOf: #Japanese with: #Snails) equals: nil .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testTraitNaming [
	"Test validation of Trait names when adding traits to a puzzle."
	
	| puzzle |
	"We need to do this in the context of a puzzle; the puzzle does validation:"
	puzzle := LogicPuzzle new .
	
	"Trait names must be either a non-empty string or a symbol:"
	self should: [ puzzle addTrait: 1 withTags: #( mn no op ) ] raise: Error .
	self should: [ puzzle addTrait: #( 1 2 3 ) withTags: #( pq qr rs ) ] raise: Error .
	self should: [ puzzle addTrait: '' withTags: #( st tu uv ) ] raise: Error .
	self should: [ puzzle addTrait: #( 'abc' ) withTags: #( vw wx xy ) ] raise: Error .
	
	"A string or symbol is allowed (since strings are cast to symbols):"
	self shouldnt: [ puzzle addTrait: 'uvw' withTags: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #xyz withTags: #( jkl mno pqr ) ] raise: Error .
	
	"A string or symbol containing or entirely spaces, is allowed:"
	self shouldnt: [ puzzle addTrait: 'abc xyz' withTags: #( ab bc cd ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #'xyz abc' withTags: #( de ef fg ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: '   ' withTags: #( gh hi ij ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #' ' withTags: #( jk kl lm ) ] raise: Error .
]
