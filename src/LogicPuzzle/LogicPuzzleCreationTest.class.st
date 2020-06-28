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
	puzzle := LogicPuzzle newWithTraitSize: 3 .
	
	"Adding traits with 3 tags should be accepted:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Adding traits with too many or too few tags should throw errors:"
	self should: [ puzzle addTrait: #House withTags: #( #Yellow #Blue #Red #Green ) ] raise: Error .
	self should: [ puzzle addTrait: #Order withTags: #( #Left #Middle ) ] raise: Error .
	
	"Adding a trait with the same name as an existing one should replace, not throw an error:"
	self assert: ((puzzle setOfTraits at: #Pet) at: 2) equals: #Fox .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Cat #Weasel #Zebra ) ] raise: Error .
	self assert: ((puzzle setOfTraits at: #Pet) at: 2) equals: #Weasel .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateLogicPuzzle [
	"Test behavior of the Logic Puzzle constructor."
	
	"Providing a non-integer for 'traitSize' is an error:"
	self should: [ LogicPuzzle newWithTraitSize: 'abc' ] raise: Error .
	self should: [ LogicPuzzle newWithTraitSize: #( 'abc' 'xyz' ) ] raise: Error .
	self should: [ LogicPuzzle newWithTraitSize: #( 1 2 3 ) ] raise: Error . 
	
	"Floats and rationals are also no good:"
	self should: [ LogicPuzzle newWithTraitSize: 3.1416 ] raise: Error .
	self should: [ LogicPuzzle newWithTraitSize: 11/3 ] raise: Error .
	
	"Integers are required, but less than 2 is an error:"
	self should: [ LogicPuzzle newWithTraitSize: -1 ] raise: Error .
	self should: [ LogicPuzzle newWithTraitSize: 0 ] raise: Error .
	self should: [ LogicPuzzle newWithTraitSize: 1] raise: Error .
	
	"An integer of 2 or greater is good:"
	self shouldnt: [ LogicPuzzle newWithTraitSize: 2 ] raise: Error .
	self shouldnt: [ LogicPuzzle newWithTraitSize: 5 ] raise: Error .
	self shouldnt: [ LogicPuzzle newWithTraitSize: 15 ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreatePuzzleAssociations [
	"Test creating trait associations for a puzzle."
	
	| puzzle |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle newWithTraitSize: 3 .
	
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
LogicPuzzleCreationTest >> testCreateTrait [
	"Test the creation of a Trait object."
	
	"Trait names must be either a non-empty string or a symbol:"
	self should: [ LPTrait new name: 1 ] raise: Error .
	self should: [ LPTrait new name: #( 1 2 3 ) ] raise: Error .
	self should: [ LPTrait new name: '' ] raise: Error .
	self should: [ LPTrait new name: #( 'abc' ) ] raise: Error .
	
	"A string or symbol is allowed (since strings are cast to symbols):"
	self shouldnt: [ LPTrait new name: 'abc' ] raise: Error .
	self shouldnt: [ LPTrait new name: #xyz ] raise: Error .
	
	"A string or symbol containing or entirely spaces, is allowed:"
	self shouldnt: [ LPTrait new name: 'abc xyz' ] raise: Error .
	self shouldnt: [ LPTrait new name: #'ijk lmn' ] raise: Error .
	self shouldnt: [ LPTrait new name: '   ' ] raise: Error .
	self shouldnt: [ LPTrait new name: #' ' ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testSetPrimaryTrait [
	"Test setting a primary trait."
	| puzzle |
	
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle newWithTraitSize: 5 .
	
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

	| trait |
	trait := LPTrait new 
		name: #testTrait .

	"Providing a proper tags array without having set 'size' is an error:"
	self should: [ trait tags: #( 'abc' 'def' 'ghi' ) ] raise: Error .

	"Trait tag array must have the same size as the puzzle:"
	trait size: 5 .
	self should: [ trait tags: #( 'abc' 'def' 'ghi' ) ] raise: Error .
	
	"Trait tags argument must be an array:"
	self should: [ trait tags: 'abc' ] raise: Error .
	self should: [ trait tags: #abc ] raise: Error .
	self should: [ trait tags: 1 ] raise: Error .
	
	"Trait tag array elements must be strings or symbols:"
	trait size: 3 .
	self should: [ trait tags: #( 1 2 3 ) ] raise: Error .
	
	"Trait tag array with correct size and elements is good:"
	self shouldnt: [ trait tags: #( 'abc' 'def' 'ghi' ) ] raise: Error .	
]
