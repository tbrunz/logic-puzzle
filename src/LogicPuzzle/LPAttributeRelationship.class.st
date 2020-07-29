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
Attributes is irrelevant).  But since the order of attributes 
is important for how my truth table is stored, the dictionary 
that holds my instances has twice as many elements; half its 
elements are for (a,b) ordering, and the other half are for 
(b,a) ordering, but both point to the (a,b) Relationship.
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

{ #category : #accessing }
LPAttributeRelationship >> attributeOne [
	^ attributeOne
]

{ #category : #accessing }
LPAttributeRelationship >> attributeTwo [
	^ attributeTwo
]

{ #category : #reporting }
LPAttributeRelationship >> checkConsistency [
	"Check the consistency of the TruthTable."
	
	"Note: I don't return anything useful."
	truthTable validateTruthTable 
		ifFalse: [ isInconsistent := true ]
]

{ #category : #deductions }
LPAttributeRelationship >> collectMatchedRelationships [
	"Scan the truth table to find all the 'matched' relationships."

	| matchedRelationships propertyRelationship |
	matchedRelationships := OrderedCollection new.

	"Don't bother if the TruthTable is not consistent; otherwise, 
	walk each set of Properties, and add them if they're a 'match':"
	truthTable validateTruthTable
		ifFalse: [ isInconsistent := true ]
		ifTrue: [ "Walk each set of properties, and add them if they're a 'match':"
			attributeOne propertySet
				do: [ :propertyOne | 
					attributeTwo propertySet
						do: [ :propertyTwo | 
							(propertyRelationship := self
								matchedRelationshipOf: propertyOne
								with: propertyTwo)
								ifNotNil: [ matchedRelationships 
									add: propertyRelationship ] ] ] ].
					
	^ matchedRelationships
]

{ #category : #deductions }
LPAttributeRelationship >> commitMatchedRelationshipIn: propertyRelationships [
	"The Property Relationship in the given collection represent an entire 
	row or column in the Truth Table; if it contains N-1 'excludes' and 1 
	'unknown', we detect a match; commit the 'unknown' as being 'matched'."

	| unknownRelationships matchedRelationships |
	unknownRelationships := propertyRelationships
		select: [ :propertyRelationship | propertyRelationship isUnknown ].

	matchedRelationships := propertyRelationships
		select: [ :propertyRelationship | propertyRelationship isMatched ].

	"We have a *set*, so use 'anyOne' to get the only element:"
	(unknownRelationships size = 1 and: [ matchedRelationships isEmpty ])
		ifTrue: [ unknownRelationships anyOne commitAsMatched ]
]

{ #category : #lookup }
LPAttributeRelationship >> commitPropertyRelationship: propertyRelationship [
	"Commit my argument to my TruthTable."
	
	isModified := true.
	^ truthTable commitRelationship: propertyRelationship 
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
			relationship propertyTwo attribute propertySet do: [ :property |
				self excludeRelationshipFor: propertyOne with: property ].
			
			propertyTwo := relationship propertyTwo.
			relationship propertyOne attribute propertySet do: [ :property |
				self excludeRelationshipFor: property with: propertyTwo ] ]
]

{ #category : #deductions }
LPAttributeRelationship >> deduceMatchedRelationships [
	"For each Attribute that has N-1 'excludes' and 1 'unknown', 
	along either axis, we detect a match; in this case, commit 
	the 'unknown' cell as being 'matched'."

	| propertyRelationships |
	"Don't bother if the TruthTable is not consistent:"
	truthTable validateTruthTable
		ifFalse: [ ^ isInconsistent := true ].

	"Walk each Attribute Property, holding the Property constant 
	while collecting the PropertyRelationships for all Properties 
	of the other Attribute.  Then send the resulting collection 
	off to be analyzed for 'N-1 excludes + 1 unknown'.  We need 
	to do this along one axis, then along the other axis."
	
	"Start by holding Properties of Attribute one constant:"
	attributeOne propertySet
		do: [ :propertyOne | 
			propertyRelationships := attributeTwo propertySet
				collect:
					[ :propertyTwo | truthTable 
						fetchRelationshipFor: propertyOne 
						with: propertyTwo ].
			self commitMatchedRelationshipIn: propertyRelationships ].

	"Now do the same by holding Properties of Attribute two constant:"
	attributeTwo propertySet
		do: [ :propertyTwo | 
			propertyRelationships := attributeOne propertySet
				collect:
					[ :propertyOne | truthTable 
						fetchRelationshipFor: propertyOne 
						with: propertyTwo ].
			self commitMatchedRelationshipIn: propertyRelationships ]
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
	
	"Change 'unknown' relationships to 'excluded'; leave others alone."
	^ truthTable commitRelationshipAsExcluded: propertyRelationship
]

{ #category : #lookup }
LPAttributeRelationship >> fetchPropertyRelationship: propertyRelationship [
	"Fetch my argument from my TruthTable."
	
	^ truthTable fetchRelationship: propertyRelationship 
]

{ #category : #accessing }
LPAttributeRelationship >> hasNewMatches [
	^ hasNewMatches
]

{ #category : #initialization }
LPAttributeRelationship >> initializeWith: firstAttribute with: secondAttribute [

	attributeOne := firstAttribute.
	attributeTwo := secondAttribute.
		
	displayString := ''.
	
	isModified := false.
	hasNewMatches := false.
	isInconsistent := false.
	
	truthTable := LPTruthTable newWith: self
]

{ #category : #accessing }
LPAttributeRelationship >> isInconsistent [
	^ isInconsistent
]

{ #category : #accessing }
LPAttributeRelationship >> isInconsistent: aBoolean [
	^ isInconsistent := aBoolean
]

{ #category : #accessing }
LPAttributeRelationship >> isModified [
	^ isModified
]

{ #category : #accessing }
LPAttributeRelationship >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #deductions }
LPAttributeRelationship >> matchedRelationshipOf: propertyOne with: propertyTwo [
	"If this PropertyRelationship is 'matched', return it, else nil."

	| propertyRelationship |
	"Fetch the corresponding PropertyRelationship; we want to 
	cache the entire relationship, not just its state:"
	propertyRelationship := truthTable
		fetchRelationshipFor: propertyOne
		with: propertyTwo.
	
	"Return only matched Property Relationships."
	propertyRelationship isMatched
		ifFalse: [ ^ nil ].
			
	^ propertyRelationship
]

{ #category : #lookup }
LPAttributeRelationship >> relationshipOf: propertyCollection [
	"Look up the truth table value for a pair of Properties."
	
	^ self relationshipOf: propertyCollection first with: propertyCollection second
]

{ #category : #lookup }
LPAttributeRelationship >> relationshipOf: propertyCollection is: relationshipState [
	"Set the truth table value for a pair of Properties."

	^ self
		relationshipOf: propertyCollection first
		with: propertyCollection second
		is: relationshipState
]

{ #category : #lookup }
LPAttributeRelationship >> relationshipOf: propertyOne with: propertyTwo [
	"Look up the truth table value for a pair of Properties."

	^ (LPPropertyRelationship
		newFor: self
		with: propertyOne
		with: propertyTwo) fetch
]

{ #category : #lookup }
LPAttributeRelationship >> relationshipOf: propertyOne with: propertyTwo is: aRelationshipState [
	"Set the truth table value for a pair of Properties."

	| propertyRelationship relationshipState |
	"Ensure that we're given a RelationshipState subclass."
	relationshipState := aRelationshipState.
	
	relationshipState superclass = LPRelationshipState
		ifFalse: [ relationshipState := LPRelationshipState 
			stateNameToClass: aRelationshipState ].
		"ifFalse: [ self error: 'Must provide an RelationshipState subclass' ]."
		
	propertyRelationship := LPPropertyRelationship
		newFor: self
		with: propertyOne
		with: propertyTwo.
		
	propertyRelationship relationshipState: aRelationshipState.
	
	^ propertyRelationship commit
]

{ #category : #reporting }
LPAttributeRelationship >> renderRelationship [
	"Render the truth table of an Attribute Relationship."

	^ displayString :=
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
					attributeOne propertySet do: [ :propertyOne | 
						stream cr.
						attributeTwo propertySet do: [ :propertyTwo | 
							stream
								space;
								nextPutAll:
									(truthTable fetchRelationshipStateFor: propertyOne with: propertyTwo)
										printSymbol;
								space; 
								space ].
						stream
							space;
							nextPutAll: propertyOne name ]. 
					stream cr ])
]

{ #category : #accessing }
LPAttributeRelationship >> stringRepresentation [
	^ displayString
]
