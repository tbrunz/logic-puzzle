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

{ #category : #accessing }
LPPropertyRelationship >> attributeRelationship [
	^ attributeRelationship
]

{ #category : #updating }
LPPropertyRelationship >> commit [
	"Commit myself to my AttributeRelationship."
	
	attributeRelationship commitPropertyRelationship: self
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

{ #category : #updating }
LPPropertyRelationship >> update [
	"Refresh myself from my AttributeRelationship."
	
	^ attributeRelationship fetchPropertyRelationship: self
]
