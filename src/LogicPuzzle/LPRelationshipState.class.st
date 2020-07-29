"
I represent the abstract state of a relationship between two 
Attribute Properties of the subjects of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Any two Attribute Properties have a relationship, which can be 
Unknown, Excluded, or Matched.  

An Excluded state means the puzzle subject that has the Property 
for the first Attribute does NOT also have the Property of the 
second Attribute.  

Similarly, a Matched state means the puzzle subject that has the 
Property for the first Attribute DOES also have the Property of 
the second Attribute. 
"
Class {
	#name : #LPRelationshipState,
	#superclass : #Object,
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #printing }
LPRelationshipState class >> printString [
	^ self subclassResponsibility 
]

{ #category : #printing }
LPRelationshipState class >> printSymbol [
	^ self subclassResponsibility 
]

{ #category : #lookup }
LPRelationshipState class >> stateNameToClass: relationshipName [
	"Convert a text reference to its RelationshipState subclass."
	
	| firstLetter |
	firstLetter := (relationshipName at: 1) uppercase. 
	
	firstLetter = $M
		ifTrue: [ ^ LPRelationshipMatched ].
	
	firstLetter = $E
		ifTrue: [ ^ LPRelationshipExcluded ].
	
	firstLetter = $U
		ifTrue: [ ^ LPRelationshipUnknown ].
		
	self error: 'Unknown relationship state (', relationshipName printString, ')'
]
