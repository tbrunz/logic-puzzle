"
I represent the Unknown state of a relationship between two 
Attribute Properties of the subjects of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Any two Attribute Properties have a relationship, which can 
be Unknown, Excluded, or Matched.  

An Unknown state means the relationship between the puzzle 
subject that has the Property for the first Attribute is 
unknown or indeterminate as far as the Property of the 
second Attribute in concerned.
"
Class {
	#name : #LPRelationshipUnknown,
	#superclass : #LPRelationshipState,
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #printing }
LPRelationshipUnknown class >> printString [
	^ 'unknown'
]

{ #category : #printing }
LPRelationshipUnknown class >> printSymbol [
	^ '.'
]
