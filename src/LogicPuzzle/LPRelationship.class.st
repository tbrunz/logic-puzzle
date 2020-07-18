"
I represent a relationship between two attributes of subjects 
of a logic puzzle. 

The attributes in a logic puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these attributes defines a set of tags, its values. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I manage a 'truth table' that matches up the tags of one attribute 
against those of the second attribute.  Each truth table value 
can be 'nil', 'true', or 'false'.  ('nil' means the relationship 
between the two tags is indeterminate.)

I can get or set a truth table cell value, or the entire truth 
table.  I can also return an array of all the 'true' cell 
coordinates.

I know how to peform deductive analyses on my truth table, to 
deduce 'true' relations and 'excluded' relations.  I can update 
my truth table accordingly, and track when I make modifications 
and when I detect inconsistencies.

A logic puzzle contains C(m,2) instances of me (where 'm' is the 
number of attributes in the puzzle), in the form of a dictionary 
keyed by an AttributePair.  And since the ordering of attributes 
is important for how my truth table is stored, my dictionary has 
P(m,2) elements; half its elements are for (a,b) ordering, and 
half are for (b,a) ordering, but both point to the single (a,b) 
Relationship.
"
Class {
	#name : #LPRelationship,
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
LPRelationship class >> newWith: attributePair [
	"Create a new trait table instance for the given trait pair."
	
	^ self 
		newWith: attributePair attributeOne with: attributePair attributeTwo 
]

{ #category : #'instance creation' }
LPRelationship class >> newWith: attributeOne with: attributeTwo [
	"Create a new relationship instance for the given attributes."

	| count indices tagsOne tagsTwo |
	"Make a dictionary to map tags to their corresponding matrix indices,
	and a pair of arrays to map truth table indices back to their tags."
	indices := Dictionary new.
	count := attributeOne tags size.
	
	tagsOne := Array ofSize: count.
	tagsTwo := Array ofSize: count.
	
	"Note that tags are unique, even between attributes; matrix indices aren't.
	This is because the truth table is 2D, so the index ranges are the same.
	We'll need to address the truth table with a pair of tags.  There's a 
	1D Dictionary, but not a 2D dictionary, so we'll need the combination 
	of a Dictionary and an Array2D to make the mapping."
	1 to: count do: [ :i | 
		| tagOne tagTwo |
		tagOne := attributeOne tags at: i.
		tagTwo := attributeTwo tags at: i.
		
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
LPRelationship >> addMatchPairAt: indexOne at: indexTwo [
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
LPRelationship >> attributePair [
	^ attributePair
]

{ #category : #accessing }
LPRelationship >> attributePair: anAttributePair [
	attributePair := anAttributePair
]

{ #category : #deductions }
LPRelationship >> deduceExcludedRelations [
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
LPRelationship >> deduceMatchedRelations [
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
LPRelationship >> excludeAttributeOneAt: indexTwo [
	"Hold indexTwo constant and walk attributeOne to set 'nil' cells 'false'."

	"If we change a cell from 'nil' to 'false', mark this table 'modified'."
	1 to: truthTable numberOfRows do: [ :indexOne | 
		(truthTable at: indexOne at: indexTwo)
			ifNil: [ truthTable at: indexOne at: indexTwo put: false.
				self isModified: true ] ]
]

{ #category : #indexing }
LPRelationship >> excludeAttributeTwoAt: indexOne [
	"Hold indexTwo constant and walk attributeOne to set 'nil' cells 'false'."

	"If we change a cell from 'nil' to 'false', mark this table 'modified'."
	1 to: truthTable numberOfRows do: [ :indexTwo | 
		(truthTable at: indexOne at: indexTwo)
			ifNil: [ truthTable at: indexOne at: indexTwo put: false.
				self isModified: true ] ]
]

{ #category : #indexing }
LPRelationship >> excludeRelationAround: indexOne at: indexTwo [
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
LPRelationship >> findMatchedRelations [
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
LPRelationship >> hasTruesAdded [
	^ hasTruesAdded
]

{ #category : #accessing }
LPRelationship >> hasTruesAdded: aBoolean [
	hasTruesAdded := aBoolean
]

{ #category : #accessing }
LPRelationship >> isInconsistent [
	^ isInconsistent
]

{ #category : #accessing }
LPRelationship >> isInconsistent: aBoolean [
	isInconsistent := aBoolean
]

{ #category : #accessing }
LPRelationship >> isModified [
	^ isModified
]

{ #category : #accessing }
LPRelationship >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #accessing }
LPRelationship >> matchPairs [
	^ matchPairs
]

{ #category : #accessing }
LPRelationship >> matchPairs: aCollection [
	matchPairs := aCollection
]

{ #category : #indexing }
LPRelationship >> matchRelationOf: indexOne at: indexTwo [
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
LPRelationship >> nextNilAfter: nilIndex for: truth at: index [
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
LPRelationship >> nextTrueAfter: trueIndex for: truth at: index [
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
LPRelationship >> nilIndexOfOneAt: indexTwo [
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
LPRelationship >> nilIndexOfTwoAt: indexOne [
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
LPRelationship >> relationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #relationship }
LPRelationship >> relationOf: aTagPair is: aBoolean [
	"Set the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo is: aBoolean 
]

{ #category : #relationship }
LPRelationship >> relationOf: tagOne with: tagTwo [
	"Look up the truth table value for a pair of tags: true, false, or nil."
	
	^ truthTable at: (tagIndices at: tagOne name) at: (tagIndices at: tagTwo name)
]

{ #category : #relationship }
LPRelationship >> relationOf: tagOne with: tagTwo is: aBoolean [
	"Set the truth table value for a pair of tags: true, false, or nil."
	
	^ truthTable at: (tagIndices at: tagOne name) at: (tagIndices at: tagTwo name) put: aBoolean
]

{ #category : #reporting }
LPRelationship >> renderRelationship [
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
LPRelationship >> tableString [
	^ tableString
]

{ #category : #accessing }
LPRelationship >> tableString: aString [
	tableString := aString
]

{ #category : #accessing }
LPRelationship >> tagIndices [
	^ tagIndices
]

{ #category : #accessing }
LPRelationship >> tagIndices: anIndexArray [
	tagIndices := anIndexArray
]

{ #category : #accessing }
LPRelationship >> tagsOne [
	^ tagsOne
]

{ #category : #accessing }
LPRelationship >> tagsOne: anIndex [
	tagsOne := anIndex
]

{ #category : #accessing }
LPRelationship >> tagsTwo [
	^ tagsTwo
]

{ #category : #accessing }
LPRelationship >> tagsTwo: anIndex [
	tagsTwo := anIndex
]

{ #category : #indexing }
LPRelationship >> trueIndexOfOneAt: indexTwo [
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
LPRelationship >> trueIndexOfTwoAt: indexOne [
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
LPRelationship >> truthTable [
	^ truthTable
]

{ #category : #accessing }
LPRelationship >> truthTable: aTruthTable [
	truthTable := aTruthTable
]
