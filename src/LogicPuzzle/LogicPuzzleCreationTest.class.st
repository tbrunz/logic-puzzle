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
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Cat #Weasel #Zebra ) ] raise: Error .
	self assert: ((puzzle traitsDB tagsOfTrait: #Pet) at: 2) name equals: #Weasel .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateLogicPuzzle [
	"Test behavior of the Logic Puzzle constructor."
	
	self shouldnt: [ LogicPuzzle new ] raise: Error
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
