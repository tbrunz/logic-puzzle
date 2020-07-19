"
I represent an attribute used to describe the subjects of a logic puzzle. 

The attributes I keep track of have a name, 
e.g., #Nationality, #Color, #Sequence. 

Each attribute has a set of tags defined for it. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I can return my array of tags, or one of my tags, given its name.
I can also return a boolean that indicates if a given tag is one 
of my tags or not.

A logic puzzle contains many instances of me, as I am the focus 
of all elements of a puzzle.
"
Class {
	#name : #LPAttribute,
	#superclass : #Object,
	#instVars : [
		'symbol',
		'propertySet'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPAttribute class >> newNamed: aSymbol propertySet: aPropertySet [
	"Create a new attribute object; the name must already be validated."

	^ self new 
		symbol: aSymbol;
		propertySet: aPropertySet;
		yourself
]

{ #category : #printing }
LPAttribute >> printString [ 
	"Render the attribute name as a string."
	
	^ symbol asString
]

{ #category : #accessing }
LPAttribute >> propertySet [
	^ propertySet
]

{ #category : #accessing }
LPAttribute >> propertySet: aPropertySet [
	propertySet := aPropertySet
]

{ #category : #accessing }
LPAttribute >> symbol [
	^ symbol
]

{ #category : #accessing }
LPAttribute >> symbol: aSymbol [
	symbol := aSymbol
]
