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
	puzzle := LogicPuzzle traitSize: 3 .
	
	"Adding traits of the correct size shouldn't cause errors:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	
	"But adding a trait with the wrong number of tags should be rejected:"
	self should: [ puzzle addTrait: #Beverage withTags: #( #Water #Vodka ) ] raise: Error .
	self should: [ puzzle addTrait: 'Smokes' withTags: #( 'Kools' 'Parliament' 'Lucky Strike' 'Old Gold' ) ] raise: Error .
	
	"Trying to add a trait with an existing name should replace the trait, not cause errors:"
	self assert: (( puzzle setOfTraits at: #Pet ) at: 2 ) equals: #Fox .
	self shouldnt: [ puzzle addTrait: 'Pet' withTags: #( #Cat #Weasel #Rhino ) ] raise: Error .
	self assert: (( puzzle setOfTraits at: #Pet ) at: 2 ) equals: #Weasel .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateLogicPuzzle [
	"Test behavior of the Logic Puzzle constructor."
	
	"Providing a non-integer for 'traitSize' is an error:"
	self should: [ LogicPuzzle traitSize: 'abc' ] raise: Error .
	self should: [ LogicPuzzle traitSize: #( 'abc' 'xyz' ) ] raise: Error .
	self should: [ LogicPuzzle traitSize: #( 1 2 3 ) ] raise: Error . 
	
	"Floats and rationals are also no good:"
	self should: [ LogicPuzzle traitSize: 3.1416 ] raise: Error .
	self should: [ LogicPuzzle traitSize: 11/3 ] raise: Error .
	
	"Integers are required, but less than 2 is an error:"
	self should: [ LogicPuzzle traitSize: -1 ] raise: Error .
	self should: [ LogicPuzzle traitSize: 0 ] raise: Error .
	self should: [ LogicPuzzle traitSize: 1] raise: Error .
	
	"An integer of 2 or greater is good:"
	self shouldnt: [ LogicPuzzle traitSize: 2 ] raise: Error .
	self shouldnt: [ LogicPuzzle traitSize: 5 ] raise: Error .
	self shouldnt: [ LogicPuzzle traitSize: 15 ] raise: Error .
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
	puzzle := LogicPuzzle traitSize: 5 .
	
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
