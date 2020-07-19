"
I represent a relationship between two Attributes of subjects 
of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I manage a 'truth table' that matches up the Properties of my 
first Attribute against those of my second Attribute.  Each 
TruthTable 'cell' holds an instance of PropertyRelationship. 

PropertyRelationships determine the state of the relationship 
between the Properties of my Attributes, which can be Unknown, 
Excluded, or Matched.

I can get or set a TruthTable cell value, and I can return an 
array of all the 'Matched' cell PropertyRelationships.

I know how to peform deductive analyses on my TruthTable, to 
deduce 'Matched' relationships and 'Excluded' relationships.  
I can update my TruthTable accordingly, and track when I make 
modifications and when I detect inconsistencies.

A Logic Puzzle contains C(m,2) instances of me (where 'm' is 
the number of Attributes in the puzzle; the ordering of my 
Attributes is irrelevant).
"
Class {
	#name : #LPAttributeRelationship,
	#superclass : #Object,
	#instVars : [
		'truthTable',
		'isModified',
		'hasTruesAdded',
		'isInconsistent',
		'tagIndices',
		'attributePair',
		'tagsOne',
		'tagsTwo',
		'matchPairs',
		'tableString'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPAttributeRelationship class >> newWith: attributePair [
	"Create a new trait table instance for the given trait pair."
	
	^ self 
		newWith: attributePair attributeOne with: attributePair attributeTwo 
]

{ #category : #'instance creation' }
LPAttributeRelationship class >> newWith: attributeOne with: attributeTwo [
	"Create a new relationship instance for the given attributes."

	| count indices tagsOne tagsTwo |
	"Make a dictionary to map tags to their corresponding matrix indices,
	and a pair of arrays to map truth table indices back to their tags."
	indices := Dictionary new.
	count := attributeOne propertySet size.
	
	tagsOne := Array ofSize: count.
	tagsTwo := Array ofSize: count.
	
	"Note that tags are unique, even between attributes; matrix indices aren't.
	This is because the truth table is 2D, so the index ranges are the same.
	We'll need to address the truth table with a pair of tags.  There's a 
	1D Dictionary, but not a 2D dictionary, so we'll need the combination 
	of a Dictionary and an Array2D to make the mapping."
	1 to: count do: [ :i | 
		| tagOne tagTwo |
		tagOne := attributeOne propertySet at: i.
		tagTwo := attributeTwo propertySet at: i.
		
		indices add: tagOne name -> i.
		indices add: tagTwo name -> i.
		
		tagsOne at: i put: tagOne.
		tagsTwo at: i put: tagTwo ].
	
	"Now create a new instance and initialize it with the above collections."
	^ self new
		truthTable: (Array2D new: count);
		
		tagsOne: tagsOne;
		tagsTwo: tagsTwo;
		
		tagIndices: indices;
		matchPairs: OrderedCollection new;
		
		isModified: false;
		hasTruesAdded: false;
		
		yourself
]

{ #category : #indexing }
LPAttributeRelationship >> addMatchPairAt: indexOne at: indexTwo [
	"If the indices are valid, add this pair to the true pairs collection."

	"A 'nil' index means this relationship is currently indeterminate,
	so return without doing anything in this case."
	indexOne ifNil: [ ^ self ].
	indexTwo ifNil: [ ^ self ].
	
	"If both indices are non-zero, then we have the table cell of a 'true'.
	If even one index was zero, then multiple tags of that 	attribute were 
	found to be 'true'; this is an inconsistency."
	(indexOne > 0 and: [ indexTwo > 0 ])
		ifTrue: [ matchPairs add: (Array with: indexOne with: indexTwo) ]
		ifFalse: [ isInconsistent := true ]
]

{ #category : #accessing }
LPAttributeRelationship >> attributePair [
	^ attributePair
]

{ #category : #accessing }
LPAttributeRelationship >> attributePair: anAttributePair [
	attributePair := anAttributePair
]

{ #category : #deductions }
LPAttributeRelationship >> deduceExcludedRelations [
	"For each 'true' tag pairing, make all others in each attribute 'false'."

	| indexOne indexTwo |
	self findMatchedRelations.

	"Now that we have a list of all 'trues', walk their attributes, 
	and set each pair that isn't the 'true' coordinates to 'false'."
	matchPairs
		do: [ :pair | 
			indexOne := pair at: 1.
			indexTwo := pair at: 2.
			self excludeRelationAround: indexOne at: indexTwo ]
]

{ #category : #deductions }
LPAttributeRelationship >> deduceMatchedRelations [
	"Walk each tag of each attribute in the truth table, looking for N-1 'falses'."

	| indexOne indexTwo |
	1 to: truthTable numberOfRows do: [ :index |
		indexOne := self nilIndexOfOneAt: index.
		indexTwo := self nilIndexOfTwoAt: index.
		
		self matchRelationOf: indexOne at: index.
		self matchRelationOf: index at: indexTwo
		]
]

{ #category : #indexing }
LPAttributeRelationship >> excludeAttributeOneAt: indexTwo [
	"Hold indexTwo constant and walk attributeOne to set 'nil' cells 'false'."

	"If we change a cell from 'nil' to 'false', mark this table 'modified'."
	1 to: truthTable numberOfRows do: [ :indexOne | 
		(truthTable at: indexOne at: indexTwo)
			ifNil: [ truthTable at: indexOne at: indexTwo put: false.
				self isModified: true ] ]
]

{ #category : #indexing }
LPAttributeRelationship >> excludeAttributeTwoAt: indexOne [
	"Hold indexTwo constant and walk attributeOne to set 'nil' cells 'false'."

	"If we change a cell from 'nil' to 'false', mark this table 'modified'."
	1 to: truthTable numberOfRows do: [ :indexTwo | 
		(truthTable at: indexOne at: indexTwo)
			ifNil: [ truthTable at: indexOne at: indexTwo put: false.
				self isModified: true ] ]
]

{ #category : #indexing }
LPAttributeRelationship >> excludeRelationAround: indexOne at: indexTwo [
	"Walk each of the attributes for the indices, making each 'false'."

	"Hold indexOne constant and walk attributeTwo, setting all 'nil' cells  
	'false'.  Then hold indexTwo constant and repeat for attributeOne."
	self excludeAttributeOneAt: indexTwo.
	self excludeAttributeTwoAt: indexOne.
	
	"Otherwise, we have the table entry of a 'true' by deduction; set it."
	truthTable at: indexOne at: indexTwo put: false.
	self isModified: true
]

{ #category : #deductions }
LPAttributeRelationship >> findMatchedRelations [
	"Scan the truth table to find all the 'true' relationships."
	
	| indexOne indexTwo |
	1 to: truthTable numberOfRows do: [ :index |
		indexOne := self trueIndexOfOneAt: index.
		indexTwo := self trueIndexOfTwoAt: index.
		
		self addMatchPairAt: indexOne at: index.
		self addMatchPairAt: index at: indexTwo
		]
]

{ #category : #accessing }
LPAttributeRelationship >> hasTruesAdded [
	^ hasTruesAdded
]

{ #category : #accessing }
LPAttributeRelationship >> hasTruesAdded: aBoolean [
	hasTruesAdded := aBoolean
]

{ #category : #accessing }
LPAttributeRelationship >> isInconsistent [
	^ isInconsistent
]

{ #category : #accessing }
LPAttributeRelationship >> isInconsistent: aBoolean [
	isInconsistent := aBoolean
]

{ #category : #accessing }
LPAttributeRelationship >> isModified [
	^ isModified
]

{ #category : #accessing }
LPAttributeRelationship >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #accessing }
LPAttributeRelationship >> matchPairs [
	^ matchPairs
]

{ #category : #accessing }
LPAttributeRelationship >> matchPairs: aCollection [
	matchPairs := aCollection
]

{ #category : #indexing }
LPAttributeRelationship >> matchRelationOf: indexOne at: indexTwo [
	"If the indices are valid, make a 'true' relationship in the truth table."

	"A 'nil' index means this relationship is currently indeterminate."
	indexOne ifNil: [ ^ self ].
	indexTwo ifNil: [ ^ self ].

	"An index of zero means all of an attribute's tags were 'false'."
	(indexOne < 1 or: [ indexTwo < 1 ])
		ifTrue: [ isInconsistent := true.
			^ self ].

	"Otherwise, we have the table entry of a 'true' by deduction; set it."
	truthTable at: indexOne at: indexTwo put: true.
	self isModified: true.
	self hasTruesAdded: true.
]

{ #category : #indexing }
LPAttributeRelationship >> nextNilAfter: nilIndex for: truth at: index [
	"Compare a value in the truth table, looking for 1 nil + N-1 falses."

	"if an earlier failure occurred, propogate the failure."
	nilIndex ifNil: [ ^ nil ].

	"Check this cell in the truth table to decide what to propagate."
	truth
		ifNil: [ nilIndex > 0
				ifTrue: [ ^ nil ]
				ifFalse: [ ^ index ] ]
		ifNotNil: [ truth
				ifTrue: [ ^ nil ] ]
]

{ #category : #indexing }
LPAttributeRelationship >> nextTrueAfter: trueIndex for: truth at: index [
	"Compare a value in the truth table, looking for 1 'true'."

	"if an earlier failure occurred, propogate the failure."
	trueIndex = 0
		ifTrue: [ ^ 0 ].

	"Check this cell in the truth table to decide what to propagate."
	truth
		ifTrue: [ trueIndex ifNil: [ ^ index ] ifNotNil: [ ^ 0 ] ].

	^ trueIndex
]

{ #category : #indexing }
LPAttributeRelationship >> nilIndexOfOneAt: indexTwo [
	"Scan attributeOne x indexTwo in the truth table for 1 nil + N-1 falses."

	| truth nilIndex |
	nilIndex := 0.

	"Return indexOne of a lone nil, or nil if not found."
	1 to: truthTable numberOfRows do: [ :indexOne | 
		truth := truthTable at: indexOne at: indexTwo.
		nilIndex := self nextNilAfter: nilIndex for: truth at: indexOne ].
	
	^ nilIndex
]

{ #category : #indexing }
LPAttributeRelationship >> nilIndexOfTwoAt: indexOne [
	"Scan indexOne x attributeTwo in the truth table for 1 nil + N-1 falses."

	| truth nilIndex |
	nilIndex := 0.

	"Return indexTwo of a lone nil, or nil if not found."
	1 to: truthTable numberOfColumns do: [ :indexTwo | 
		truth := truthTable at: indexOne at: indexTwo.
		nilIndex := self nextNilAfter: nilIndex for: truth at: indexTwo ].
	
	^ nilIndex
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: aTagPair is: aBoolean [
	"Set the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo is: aBoolean 
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: tagOne with: tagTwo [
	"Look up the truth table value for a pair of tags: true, false, or nil."
	
	^ truthTable at: (tagIndices at: tagOne name) at: (tagIndices at: tagTwo name)
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: tagOne with: tagTwo is: aBoolean [
	"Set the truth table value for a pair of tags: true, false, or nil."
	
	^ truthTable at: (tagIndices at: tagOne name) at: (tagIndices at: tagTwo name) put: aBoolean
]

{ #category : #reporting }
LPAttributeRelationship >> renderRelationship [
	"Render the truth table of a relationship."

	self
		tableString:
			(String
				streamContents: [ :stream | 
					stream cr.
					tagsTwo
						do: [ :tag | 
							stream
								nextPutAll:
									(String
										streamContents: [ :s | s nextPutAll: tag name ]
										limitedTo: 3);
								space ].
					1 to: truthTable numberOfRows do: [ :row | 
						stream cr.
						1 to: truthTable numberOfColumns do: [ :col | 
							stream
								nextPutAll:
									((truthTable at: row at: col)
										ifNil: [ ' .  ' ]
										ifNotNil: [ (truthTable at: row at: col)
												ifTrue: [ ' @  ' ]
												ifFalse: [ ' x  ' ] ]) ].
						stream
							space;
							nextPutAll: (tagsOne at: row) name ].
					stream cr ])
]

{ #category : #accessing }
LPAttributeRelationship >> tableString [
	^ tableString
]

{ #category : #accessing }
LPAttributeRelationship >> tableString: aString [
	tableString := aString
]

{ #category : #accessing }
LPAttributeRelationship >> tagIndices [
	^ tagIndices
]

{ #category : #accessing }
LPAttributeRelationship >> tagIndices: anIndexArray [
	tagIndices := anIndexArray
]

{ #category : #accessing }
LPAttributeRelationship >> tagsOne [
	^ tagsOne
]

{ #category : #accessing }
LPAttributeRelationship >> tagsOne: anIndex [
	tagsOne := anIndex
]

{ #category : #accessing }
LPAttributeRelationship >> tagsTwo [
	^ tagsTwo
]

{ #category : #accessing }
LPAttributeRelationship >> tagsTwo: anIndex [
	tagsTwo := anIndex
]

{ #category : #indexing }
LPAttributeRelationship >> trueIndexOfOneAt: indexTwo [
	"Scan attributeOne x indexTwo in the truth table for 1 'true'."

	| truth trueIndex |
	trueIndex := nil.

	"Return indexOne of a lone nil, or nil if not found."
	1 to: truthTable numberOfRows do: [ :indexOne | 
		truth := truthTable at: indexOne at: indexTwo.
		trueIndex := self nextTrueAfter: trueIndex for: truth at: indexOne ].
	
	^ trueIndex
]

{ #category : #indexing }
LPAttributeRelationship >> trueIndexOfTwoAt: indexOne [
	"Scan indexOne x attributeTwo in the truth table for 1 'true'."

	| truth trueIndex |
	trueIndex := nil.

	"Return indexOne of a lone nil, or nil if not found."
	1 to: truthTable numberOfColumns do: [ :indexTwo | 
		truth := truthTable at: indexOne at: indexTwo.
		trueIndex := self nextTrueAfter: trueIndex for: truth at: indexTwo ].
	
	^ trueIndex
]

{ #category : #accessing }
LPAttributeRelationship >> truthTable [
	^ truthTable
]

{ #category : #accessing }
LPAttributeRelationship >> truthTable: aTruthTable [
	truthTable := aTruthTable
]
