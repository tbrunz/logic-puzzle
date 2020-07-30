Class {
	#name : #LogicPuzzleCreationTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleCreationTest >> test001CreateLogicPuzzle [
	"Test behavior of the Logic Puzzle constructor."
	
	self shouldnt: [ LogicPuzzle new ] raise: Error
]

{ #category : #tests }
LogicPuzzleCreationTest >> test002AttributeNaming [
	"Test validation of attribute names when adding attributes to a puzzle."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	"Attribute names must be either a non-empty string or a symbol:"
	self should: [ puzzle addAttribute: 1 withProperties: #( mn no op ) ] raise: Error .
	self should: [ puzzle addAttribute: #( 1 2 3 ) withProperties: #( pq qr rs ) ] raise: Error .
	self should: [ puzzle addAttribute: '' withProperties: #( st tu uv ) ] raise: Error .
	self should: [ puzzle addAttribute: #( 'abc' ) withProperties: #( vw wx xy ) ] raise: Error .
	
	"A string or symbol is allowed (since strings are cast to symbols):"
	self shouldnt: [ puzzle addAttribute: 'uvw' withProperties: #( abc def ghi ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #xyz withProperties: #( jkl mno pqr ) ] raise: Error .
	
	"A string or symbol containing or entirely spaces, is allowed:"
	self shouldnt: [ puzzle addAttribute: 'abc xyz' withProperties: #( ab bc cd ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #'xyz abc' withProperties: #( de ef fg ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: '   ' withProperties: #( gh hi ij ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #' ' withProperties: #( jk kl lm ) ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> test003SetAttributeProperties [
	"Test validation of attribute tag arays when adding attributes to a puzzle."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	"Attribute tags argument must be an array:"
	self should: [ puzzle addAttribute: 'abc' withProperties: 'xyz' ] raise: Error .
	self should: [ puzzle addAttribute: 'def' withProperties: #uvw ] raise: Error .
	self should: [ puzzle addAttribute: 'ghi' withProperties: 7 ] raise: Error .

	"Attribute tag array must have the same size as the puzzle:"
	self shouldnt: [ puzzle addAttribute: 'jkl' withProperties: #( ab bc cd de ) ] raise: Error .
	self should: [ puzzle addAttribute: 'mno' withProperties: #( ef fg gh ) ] raise: Error .
	self should: [ puzzle addAttribute: 'pqr' withProperties: #( hi ij jk kl lm ) ] raise: Error .
	
	"Attribute tag array elements must be strings or symbols:"
	self should: [ puzzle addAttribute: 'stu' withProperties: #( 1 2 3 4 ) ] raise: Error .
	
	"Attribute tag array with correct size and elements is good:"
	self shouldnt: [ puzzle addAttribute: 'vwx' withProperties: #( mn no op pq ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: 'yza' withProperties: #( #qr #rs #st #tu ) ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> test004AddAttributesToPuzzle [
	"Test adding attributes to a puzzle."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	"Adding attributes with 3 tags should be accepted:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Adding attributes with too many or too few tags should throw errors:"
	self should: [ puzzle addAttribute: #House withProperties: #( #Yellow #Blue #Red #Green ) ] raise: Error .
	self should: [ puzzle addAttribute: #Order withProperties: #( #Left #Middle ) ] raise: Error .
	
	"Adding an attribute with the same name as an existing one should replace, not throw an error:"
	self assert: ((puzzle attributeDatabase propertySetOfAttribute: #Pet) anySatisfy: [ :property | property name = #Fox ]) equals: true .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Cat #Weasel #Horse ) ] raise: Error .
	self assert: ((puzzle attributeDatabase propertySetOfAttribute: #Pet) anySatisfy: [ :property | property name = #Weasel ]) equals: true .
]

{ #category : #tests }
LogicPuzzleCreationTest >> test005SetPrimaryAttribute [
	"Test setting a primary attribute."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian #Englishman #Spaniard ) .
	puzzle addAttribute: #Pet withProperties: #( #Dog #Horse #Snails #Fox #Zebra ) .
	
	"A provided trait name must be a string or symbol:"
	self should: [ puzzle primaryAttribute: 3 ] raise: Error .
	self should: [ puzzle primaryAttribute: #( 'abc' 'def' ) ] raise: Error .
	
	"A trait name that we don't recognize is an error:"
	self should: [ puzzle primaryAttribute: #JoeBob ] raise: Error .
	
	"A trait name matching a trait we know is good:"
	puzzle primaryAttribute: 'Pet' .
	self shouldnt: [ puzzle primaryAttribute: 'Pet' ] raise: Error .
	self shouldnt: [ puzzle primaryAttribute: #Nationality ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> test006CreateRelationships [
	"Test creating attribute relationships for a puzzle."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 relationship pair combinations = 6 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 6 .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 relationship pair combinations = 12 permutations:"
	self shouldnt: [ puzzle addAttribute: #Smokes withProperties: #( #Kools #Parliaments #Chesterfields ) ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 12 .
	
	"Puzzle with 5 traits -> 5*4/2 = 10 relationship pair combinations = 20 permutations:"
	self shouldnt: [ puzzle addAttribute: #House withProperties: #( #Yellow #Blue #Green ) ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 20 .
	
	"Puzzle with 6 traits -> 6*5/2 = 15 relationship pair combinations = 30 permutations:"
	self shouldnt: [ puzzle addAttribute: #Order withProperties: #( #Left #Middle #Right ) ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 30 .
	
	"Puzzle with 7 traits --> 7*6/2 = 21 relationship pair combinations = 42 permutations:"
	self shouldnt: [ puzzle addAttribute: #Food withProperties: #( #Beef #Pork #Chicken ) ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 42 .
]

{ #category : #tests }
LogicPuzzleCreationTest >> test007RelatingAttributes [
	"Test validating, assigning, and detecting attribute relationships."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Can't make associations unless the set of associations has been created."
	self should: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #Matched ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 6 .
	
	"Reject traits that aren't known, and trait tags that aren't part of a given trait:"
	self should: [ puzzle relationshipOf: #Swedish with: #Zebra is: #Matched ] raise: Error .
	self should: [ puzzle relationshipOf: #Norwegian with: #Weasel is: #matched ] raise: Error .
	
	"Reject any trait or tag name that isn't a string or symbol:"
	self should: [ puzzle relationshipOf: 3 with: #Zebra is: #Match ] raise: Error .
	self should: [ puzzle relationshipOf: #Norwegian with: #('abc') is: #match ] raise: Error .
	
	puzzle relationshipOf: #Norwegian with: #Zebra is: #matched .
	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #matched ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> test008AttributeRelations [
	"Test that relating attributes results in expected truth table values."
	
	| puzzle |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 relationship pair combinations = 6 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	self assert: puzzle createRelationships relationshipDictionary size equals: 6 .

	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: 'matched' ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: 'excluded' ] raise: Error .

	"Setting the same association a second time should not throw an error:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: 'excluded' ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: 'matched' ] raise: Error .
	
	"Associations should report the value they were set with; unset associations should report nil:"
	self assert: (puzzle relationshipOf: #Norwegian with: #Zebra) equals: 'matched' .
	self assert: (puzzle relationshipOf: #Ukrainian with: #Tea) equals: 'excluded' .
	self assert: (puzzle relationshipOf: #Japanese with: #Snails) equals: 'unknown' .
]
