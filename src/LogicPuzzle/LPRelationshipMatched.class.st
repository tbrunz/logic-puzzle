"
I represent the Matched state of a relationship between two 
Attribute Properties of the subjects of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Any two Attribute Properties have a relationship, which can be 
Unknown, Excluded, or Matched.  

A Matched state means the puzzle subject that has the Property 
for the first Attribute DOES also have the Property of the 
second Attribute.
"
Class {
	#name : #LPRelationshipMatched,
	#superclass : #LPRelationshipState,
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #printing }
LPRelationshipMatched class >> printString [
	^ 'matched'
]

{ #category : #printing }
LPRelationshipMatched class >> printSymbol [
	^ '@'
]
