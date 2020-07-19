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
		'isInconsistent',
		'attributeOne',
		'attributeTwo',
		'hasNewMatches',
		'displayString'
	],
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #'instance creation' }
LPAttributeRelationship class >> newWith: attributeOne with: attributeTwo [
	"Create a new Attribute Relationship with the given attributes."
	
	^ self new
		initializeWith: attributeOne with: attributeTwo;
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
		ifTrue: [ matchedRelationships add: (Array with: indexOne with: indexTwo) ]
		ifFalse: [ isInconsistent := true ]
]

{ #category : #deductions }
LPAttributeRelationship >> collectMatchedRelationships [
	"Scan the truth table to find all the 'matched' relationships."

	| matchedRelationships propertyRelationship |
	matchedRelationships := OrderedCollection new.
	
	"Don't bother if the TruthTable is not consistent:"
	truthTable validateTruthTable 
		ifFalse: [ ^ isInconsistent := true ].
		
	"Walk each set of properties, and add them if they're a match:"
	attributeOne propertySet
		do: [ :propertyOne | 
			attributeTwo propertySet
				do: [ :propertyTwo | 
					(propertyRelationship := self matchedRelationshipOf: propertyOne with: propertyTwo)
						ifNotNil: [ matchedRelationships add: propertyRelationship ] ] ].
			
	^ matchedRelationships 
]

{ #category : #deductions }
LPAttributeRelationship >> deduceExcludedRelationships [
	"For each 'matched' Property pairing, mark the exclusions."

	| propertyOne propertyTwo |
	"Obtain a list of all 'matches', walk each of their attributes, 
	with the opposing Property held constant in turn, and set each 
	pair that isn't the 'matched' coordinates to 'excluded'."
	self collectMatchedRelationships
		do: [ :relationship | 
			propertyOne := relationship propertyOne.
			attributeTwo propertySet do: [ :property |
				self excludeRelationshipFor: propertyOne with: property ].
			
			propertyTwo := relationship propertyTwo.
			attributeOne propertySet do: [ :property |
				self excludeRelationshipFor: property with: propertyTwo ] ]
]

{ #category : #deductions }
LPAttributeRelationship >> deduceMatchedRelationships [
	"For each attribute that has N-1 'excludes', we have a match."

	| propertyRelationship unknownFound |
	"Don't bother if the TruthTable is not consistent:"
	truthTable validateTruthTable
		ifFalse: [ ^ isInconsistent := true ].
		
	"Walk each attribute property, counting the 
	with the opposing Property held constant in turn, and set each 
	pair that isn't the 'matched' coordinates to 'excluded'."
	attributeOne propertySet do: [ :propertyOne |
		unknownFound := false.
		attributeTwo propertySet do: [ :property |
			propertyRelationship := truthTable 
				fetchRelationshipFor: propertyOne 
				with: property.
			propertyRelationship isUnknown 
				ifTrue: [ unknownFound := true ]
		] ]
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
LPAttributeRelationship >> excludeRelationshipFor: propertyOne with: propertyTwo [
	"For each 'unknown' PropertyRelationship, mark as 'excluded'."

	| propertyRelationship |
	"If the PropertyRelationship for the pair is 'unknown', then 
	update it to 'excluded'.  If it is 'excluded', do nothing. 
	If it is 'matched', do nothing, as we are essentially stateless, 
	so we can't do consistency checking here."
	propertyRelationship := truthTable
		fetchRelationshipFor: propertyOne
		with: propertyTwo.
		
	propertyRelationship isMatched ifTrue: [ ^ propertyRelationship ].
	
	^ truthTable updateRelationshipToExcluded: propertyRelationship
]

{ #category : #accessing }
LPAttributeRelationship >> hasNewMatches [
	^ hasNewMatches
]

{ #category : #accessing }
LPAttributeRelationship >> hasNewMatches: aBoolean [
	hasNewMatches := aBoolean
]

{ #category : #initialization }
LPAttributeRelationship >> initializeWith: firstAttribute with: secondAttribute [

	attributeOne := firstAttribute.
	attributeTwo := secondAttribute.
	
	truthTable := Array2D new: (attributeOne propertySet size).
		
	matchedRelationships := OrderedCollection new.
		
	displayString := ''.
	
	isModified := false.
	hasNewMatches := false.
	isInconsistent := false
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
	self hasNewMatches: true.
]

{ #category : #deductions }
LPAttributeRelationship >> matchedRelationshipOf: propertyOne with: propertyTwo [
	"If this PropertyRelationship is 'matched', return it."

	| propertyRelationship |
	"Fetch the corresponding PropertyRelationship; we want to 
	cache the entire relationship, not just its state:"
	propertyRelationship := truthTable
		fetchRelationshipFor: propertyOne
		with: propertyTwo.
	
	"Only keep matched relationships; there's no meaningful return."
	propertyRelationship isMatched
		ifFalse: [ ^ nil ].
			
	^ propertyRelationship
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
LPAttributeRelationship >> relationOf: propertyArray [
	"Look up the truth table value for a pair of properties."
	
	^ self relationOf: propertyArray first with: propertyArray second
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: propertyArray is: propertyRelationship [
	"Set the truth table value for a pair of properties."

	^ self
		relationOf: propertyArray first
		with: propertyArray second
		is: propertyRelationship
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: propertyOne with: propertyTwo [
	"Look up the truth table value for a pair of properties."

	| propertyRelationship |
	propertyRelationship := LPPropertyRelationship
		newFor: self
		With: propertyOne
		with: propertyTwo.

	^ truthTable fetchRelationship: propertyRelationship
]

{ #category : #relationship }
LPAttributeRelationship >> relationOf: propertyOne with: propertyTwo is: propertyRelationship [
	"Look up the truth table value for a pair of properties."

	^ truthTable commitRelationship: propertyRelationship
]

{ #category : #reporting }
LPAttributeRelationship >> renderRelationship [
	"Render the truth table of a relationship."

	displayString :=
			(String
				streamContents: [ :stream | 
					stream cr.
					attributeTwo propertySet
						do: [ :property | 
							stream
								nextPutAll:
									(String
										streamContents: [ :s | s nextPutAll: property name ]
										limitedTo: 3);
								space ].
					1 to: attributeOne propertySet do: [ :propertyOne | 
						stream cr.
						1 to: attributeTwo propertySet do: [ :propertyTwo | 
							stream
								nextPut: ' ';
								nextPut:
									(truthTable fetchRelationshipStateFor: propertyOne with: propertyTwo)
										printSymbol;
								nextPutAll: '  ' ].
						stream
							space;
							nextPutAll: (attributeOne propertySet at: propertyOne) name ].
					stream cr ])
]

{ #category : #deductions }
LPAttributeRelationship >> scanRelationshipConsistency [
	"Scan the truth table to find all the 'matched' relationships."
	
	| matchFound |
	"We're going to regenerate the collection; make a new one:"
	matchedRelationships := OrderedCollection new.

	"Don't bother with analyzing an inconsistent truth table:"
	isInconsistent ifTrue: [ ^ matchedRelationships ].
	
	"Hold Property one constant and walk Attribute two for matches:"
	attributeOne propertySet
		do: [ :propertyOne | 
			matchFound := false.
			attributeTwo propertySet
				do: [ :propertyTwo | 
					matchFound ifFalse: [ 
						matchFound := self addMatchedUnless: matchFound with: propertyOne with: propertyTwo ]
					 ] ].

	"Don't bother with analyzing an inconsistent truth table:"
	isInconsistent ifTrue: [ ^ matchedRelationships ].
	
	"Hold Property two constant and walk Attribute one for matches:"
	attributeTwo propertySet
		do: [ :propertyTwo | 
			matchFound := false.
			attributeOne propertySet
				do: [ :propertyOne | 
					matchFound ifFalse: [ 
						matchFound := self addMatchedUnless: matchFound with: propertyOne with: propertyTwo ]
					 ] ].
			
	^ matchedRelationships 
]

{ #category : #accessing }
LPAttributeRelationship >> stringRepresentation [
	^ displayString
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
