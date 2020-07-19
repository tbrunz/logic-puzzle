"
I represent a relationship between two Attribute Properties of 
the subjects of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I hold the Relationship State between my two properties, and I 
know the Attribute Relationship I belong to.

I can therefore update my Attribute Relationship with myself, 
or request that my Attribute Relationship update me with its 
current state.
"
Class {
	#name : #LPPropertyRelationship,
	#superclass : #Object,
	#instVars : [
		'relationshipState',
		'attributeRelationship',
		'propertyOne',
		'propertyTwo'
	],
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #'instance creation' }
LPPropertyRelationship class >> newFor: attributeRelationship with: propertyOne with: propertyTwo [
	"Make a new PropertyRelationship of Unknown state."
	
	^ self new 
		initializeFor: attributeRelationship With: propertyOne with: propertyTwo;
		yourself
]

{ #category : #accessing }
LPPropertyRelationship >> attributeRelationship [
	^ attributeRelationship
]

{ #category : #updating }
LPPropertyRelationship >> commit [
	"Commit myself to my AttributeRelationship."
	
	attributeRelationship commitPropertyRelationship: self
]

{ #category : #updating }
LPPropertyRelationship >> commitAsExcluded [
	"Set my state to 'unknown', then commit myself to the TruthTable."
	
	relationshipState := LPRelationshipExcluded.
	
	^ self commit
]

{ #category : #updating }
LPPropertyRelationship >> commitAsMatched [
	"Set my state to 'unknown', then commit myself to the TruthTable."
	
	relationshipState := LPRelationshipMatched.
	
	^ self commit
]

{ #category : #updating }
LPPropertyRelationship >> fetch [
	"Refresh myself from my AttributeRelationship."
	
	^ attributeRelationship fetchPropertyRelationship: self
]

{ #category : #initialization }
LPPropertyRelationship >> initializeFor: anAttributeRelationship With: firstProperty with: secondProperty [
	"Set up a new PropertyRelationship with an Unknown state."
	
	attributeRelationship := anAttributeRelationship.
	
	propertyOne := firstProperty.
	propertyTwo := secondProperty.
	
	relationshipState := LPRelationshipUnknown 
]

{ #category : #testing }
LPPropertyRelationship >> isExcluded [
	"Convenience wrapper for relationship state."
	
	^ relationshipState = LPRelationshipExcluded 
]

{ #category : #testing }
LPPropertyRelationship >> isMatched [
	"Convenience wrapper for relationship state."
	
	^ relationshipState = LPRelationshipMatched 
]

{ #category : #testing }
LPPropertyRelationship >> isUnknown [
	"Convenience wrapper for relationship state."
	
	^ relationshipState = LPRelationshipUnknown 
]

{ #category : #accessing }
LPPropertyRelationship >> propertyOne [
	^ propertyOne
]

{ #category : #accessing }
LPPropertyRelationship >> propertyTwo [
	^ propertyTwo
]

{ #category : #accessing }
LPPropertyRelationship >> relationshipState [
	^ relationshipState
]

{ #category : #accessing }
LPPropertyRelationship >> relationshipState: aRelationshipState [
	relationshipState := aRelationshipState
]
