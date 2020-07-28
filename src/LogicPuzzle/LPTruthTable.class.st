"
I represent a 'truth table' of the Property Relationships 
between two Attributes of the subjects of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I manage the set of Property Relationships that exist among 
all combinations of Properties of my two Attributes, and I 
know the Attribute Relationship I belong to.

I can get and set the Property Relationships that I hold; 
the Property Relationship objects know their two Properties 
as well as the Relationship State between them.
"
Class {
	#name : #LPTruthTable,
	#superclass : #Object,
	#instVars : [
		'attributeRelationship',
		'truthTable',
		'propertyConverter'
	],
	#category : #'LogicPuzzle-Helpers'
}

{ #category : #'instance creation' }
LPTruthTable class >> newWith: attributeRelationship [ 
	"Tell the new instance what AttributeRelationship it's for."
	
	^ self new
		initializeWith: attributeRelationship;
		yourself
]

{ #category : #updating }
LPTruthTable >> commitRelationship: aPropertyRelationship [
	"Overwrite the truth table PropertyRelationship with the argument."

	| tablePoint |
	"Corvert the property pair into a Point that can be used
	as a pair of indices into the truth table where I'm located:"
	tablePoint := propertyConverter
		propertyToPointWith: aPropertyRelationship propertyOne
		with: aPropertyRelationship propertyTwo.
	
	^ truthTable
		at: tablePoint x
		at: tablePoint y
		put: aPropertyRelationship
]

{ #category : #updating }
LPTruthTable >> commitRelationshipAsExcluded: aPropertyRelationship [
	"Change the PropertyRelationship in the TruthTable to 'excluded'."

	"Is the relationiship 'unknown'?  Cannot change it otherwise!"
	aPropertyRelationship isUnknown
		ifFalse: [ ^ aPropertyRelationship ].
	
	"The response to a 'commit' message is to return what was committed:"
	^ self commitRelationship: 
		(aPropertyRelationship relationshipState: LPRelationshipExcluded)
]

{ #category : #updating }
LPTruthTable >> commitRelationshipAsMatched: aPropertyRelationship [
	"Change the PropertyRelationship in the TruthTable to 'matched'."

	"Is the relationiship 'unknown'?  Cannot change it otherwise!"
	aPropertyRelationship isUnknown
		ifFalse: [ ^ aPropertyRelationship ].

	"The response to a 'commit' message is to return what was committed:"
	^ self commitRelationship: 
		(aPropertyRelationship relationshipState: LPRelationshipMatched)
]

{ #category : #lookup }
LPTruthTable >> fetchRelationship: aPropertyRelationship [
	"Update a PropertyRelationship from the TruthTable."

	^ self 
		fetchRelationshipFor: aPropertyRelationship propertyOne
		with: aPropertyRelationship propertyTwo
]

{ #category : #lookup }
LPTruthTable >> fetchRelationshipFor: propertyOne with: propertyTwo [
	"Return a PropertyRelationship from the TruthTable."

	| tablePoint |
	"Corvert the pair of Properties into a Point that can 
	be used as a pair of indices into the truth table:"
	tablePoint := propertyConverter
		propertyToPointWith: propertyOne with: propertyTwo.
		
	^ truthTable at: tablePoint x at: tablePoint y
]

{ #category : #lookup }
LPTruthTable >> fetchRelationshipStateFor: propertyOne with: propertyTwo [
	"Return a PropertyRelationship State from the TruthTable."

	^ (self fetchRelationshipFor: propertyOne with: propertyTwo)
		relationshipState
]

{ #category : #initialization }
LPTruthTable >> initializeWith: anAttributeRelationship [
	"Generate our PropertyConverter instance and fill our TruthTable."

	| attributeOne attributeTwo |
	attributeRelationship := anAttributeRelationship.
	
	attributeOne := attributeRelationship attributeOne.
	attributeTwo := attributeRelationship attributeTwo.

	"Build us a customized PropertyConverter:"
	propertyConverter := LPPropertyConverter
		newWith:  attributeOne
		with:  attributeTwo.

	"Both of our Attributes have Property sets of the same size;
	Array2D objects are square matrices of a given size:"
	truthTable := Array2D new: attributeOne propertySet size.
	
	"Initialize the TruthTable, by filling all its cells with 
	new PropertyRelationships, which will have 'unknown' state:"
	attributeOne propertySet
		do: [ :propertyOne | 
			attributeTwo propertySet
				do: [ :propertyTwo | 
					self commitRelationship: 
						(LPPropertyRelationship
							newFor: attributeRelationship
							with: propertyOne
							with: propertyTwo)  ] ]
					
]

{ #category : #validating }
LPTruthTable >> validateTruthTable [
	"Scan the truth table and indicate its consistency."

	| propertyCount matchCount excludeCount |
	propertyCount := truthTable numberOfRows.

	"This is low-level: Take advantage of our knowledge of the 
	TruthTable construction to scan through it; start by rows:"
	1 to: propertyCount do: [ :rowIndex | 
		matchCount := excludeCount := 0.
		
		1 to: propertyCount do: [ :colIndex | 
			(truthTable at: rowIndex at: colIndex) isMatched
				ifTrue: [ matchCount := matchCount + 1 ].
			(truthTable at: rowIndex at: colIndex) isExcluded
				ifTrue: [ excludeCount := excludeCount + 1 ] ].
			
		(matchCount > 1 or: [ excludeCount = propertyCount ])
			ifTrue: [ ^ false ] ].

	"Then scan through it by columns:"
	1 to: propertyCount do: [ :colIndex | 
		matchCount := excludeCount := 0.
		
		1 to: propertyCount do: [ :rowIndex | 
			(truthTable at: rowIndex at: colIndex) isMatched
				ifTrue: [ matchCount := matchCount + 1 ].
			(truthTable at: rowIndex at: colIndex) isExcluded
				ifTrue: [ excludeCount := excludeCount + 1 ] ].
			
		(matchCount > 1 or: [ excludeCount = propertyCount ])
			ifTrue: [ ^ false ] ].
		
	^ true
]
