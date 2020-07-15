Class {
	#name : #LPRelationship,
	#superclass : #Object,
	#instVars : [
		'truthTable',
		'isModified',
		'hasTruesAdded',
		'isInconsistent',
		'tagIndices',
		'truePairs',
		'attributePair',
		'tagsOne',
		'tagsTwo'
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
		
		indices add: tagOne -> i.
		indices add: tagTwo -> i.
		
		tagsOne at: i put: tagOne.
		tagsTwo at: i put: tagTwo ].
	
	"Now create a new instance and initialize it with the above collections."
	^ self new
		truthTable: (Array2D new: count);
		
		tagsOne: tagsOne;
		tagsTwo: tagsTwo;
		
		tagIndices: indices;
		truePairs: OrderedCollection new;
		
		isModified: false;
		hasTruesAdded: false;
		
		yourself
]

{ #category : #deductions }
LPRelationship >> addTruePairAt: indexOne at: indexTwo [
	"If the indices are valid, add this pair to the true pairs collection."

	"A 'nil' index means this relationship is currently indeterminate."
	indexOne ifNil: [ ^ self ].
	indexTwo ifNil: [ ^ self ].

	"An index of zero means multiple tags of an attribute were 'true'."
	(indexOne < 1 or: [ indexTwo < 1 ])
		ifTrue: [ isInconsistent := true.
			^ truePairs ].

	"Otherwise, we have the table entry of a 'true' by deduction."
	truePairs add: (Array with: indexOne with: indexTwo)
]

{ #category : #accessing }
LPRelationship >> attributePair [
	^ attributePair
]

{ #category : #accessing }
LPRelationship >> attributePair: anObject [
	attributePair := anObject
]

{ #category : #deductions }
LPRelationship >> deduceFalseRelations [
	"For each true tag pairing, make all others in each attribute 'false'."

	| indexOne indexTwo |
	self findTrueRelations.

	"Now that we have a list of all 'trues', walk their attributes:"
	truePairs
		do: [ :pair | 
			indexOne := pair at: 1.
			indexTwo := pair at: 2.
			self unRelateTagsAt: indexOne at: indexTwo ]
]

{ #category : #deductions }
LPRelationship >> deduceTrueRelations [
	"Walk each tag of each attribute in the truth table, looking for N-1 'falses'."

	| indexOne indexTwo |
	1 to: truthTable numberOfRows do: [ :index |
		indexOne := self indexOfNilInOneAt: index.
		indexTwo := self indexOfNilInTwoAt: index.
		
		self relateTagsAt: indexOne at: index.
		self relateTagsAt: index at: indexTwo
		]
]

{ #category : #deductions }
LPRelationship >> findTrueRelations [
	"Scan the truth table to find all the 'true' relationships."
	
	| indexOne indexTwo |
	1 to: truthTable numberOfRows do: [ :index |
		indexOne := self indexOfTrueInOneAt: index.
		indexTwo := self indexOfTrueInTwoAt: index.
		
		self addTruePairAt: indexOne at: index.
		self addTruePairAt: index at: indexTwo
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

{ #category : #deductions }
LPRelationship >> indexOfNilInOneAt: indexTwo [
	"Scan attributeOne x indexTwo in the truth table for 1 nil + N-1 falses."

	| truth nilIndex |
	nilIndex := 0.

	"Return indexOne of a lone nil, or nil if not found."
	1 to: truthTable numberOfRows do: [ :indexOne | 
		truth := truthTable at: indexOne at: indexTwo.
		nilIndex := self nextNilAfter: nilIndex for: truth at: indexOne ].
	
	^ nilIndex
]

{ #category : #deductions }
LPRelationship >> indexOfNilInTwoAt: indexOne [
	"Scan indexOne x attributeTwo in the truth table for 1 nil + N-1 falses."

	| truth nilIndex |
	nilIndex := 0.

	"Return indexTwo of a lone nil, or nil if not found."
	1 to: truthTable numberOfColumns do: [ :indexTwo | 
		truth := truthTable at: indexOne at: indexTwo.
		nilIndex := self nextNilAfter: nilIndex for: truth at: indexTwo ].
	
	^ nilIndex
]

{ #category : #deductions }
LPRelationship >> indexOfTrueInOneAt: indexTwo [
	"Scan attributeOne x indexTwo in the truth table for 1 'true'."

	| truth trueIndex |
	trueIndex := nil.

	"Return indexOne of a lone nil, or nil if not found."
	1 to: truthTable numberOfRows do: [ :indexOne | 
		truth := truthTable at: indexOne at: indexTwo.
		trueIndex := self nextTrueAfter: trueIndex for: truth at: indexOne ].
	
	^ trueIndex
]

{ #category : #deductions }
LPRelationship >> indexOfTrueInTwoAt: indexOne [
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

{ #category : #deductions }
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

{ #category : #deductions }
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

{ #category : #deductions }
LPRelationship >> relateTagsAt: indexOne at: indexTwo [
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
	
	^ truthTable at: (tagIndices at: tagOne) at: (tagIndices at: tagTwo)
]

{ #category : #relationship }
LPRelationship >> relationOf: tagOne with: tagTwo is: aBoolean [
	"Set the truth table value for a pair of tags: true, false, or nil."
	
	^ truthTable at: (tagIndices at: tagOne) at: (tagIndices at: tagTwo) put: aBoolean
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

{ #category : #accessing }
LPRelationship >> truePairs [
	^ truePairs
]

{ #category : #accessing }
LPRelationship >> truePairs: anObject [
	truePairs := anObject
]

{ #category : #accessing }
LPRelationship >> truthTable [
	^ truthTable
]

{ #category : #accessing }
LPRelationship >> truthTable: aTruthTable [
	truthTable := aTruthTable
]

{ #category : #deductions }
LPRelationship >> unRelateTagsAt: indexOne at: indexTwo [
	"If the indices are valid, make a 'true' relationship in the truth table."

	"Hold indexOne constant and walk attributeTwo:"
	self unRelateAttributeOneAt: indexTwo.
	self unRelateAttributeTwoAt: indexOne.
	
	"Otherwise, we have the table entry of a 'true' by deduction; set it."
	truthTable at: indexOne at: indexTwo put: false.
	self isModified: true
]
