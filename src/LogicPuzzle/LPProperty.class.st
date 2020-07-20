"
I represent a tag that acts as a value for an attribute of the 
subjects of a logic puzzle. 

The attributes in a logic puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

For each of these attributes, I define one of its tags. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I can return the attribute I belong to. 

I can also return a boolean that indicates if a given attribute 
is my attribute or not.

A logic puzzle contains many instances of me, as I am the focus 
of all elements of a puzzle.
"
Class {
	#name : #LPProperty,
	#superclass : #Object,
	#instVars : [
		'attribute',
		'name'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPProperty class >> newNamed: aName ofAttribute: anAttribute [
	"Called only after the arguments have been validated."

	^ self new 
		name: aName;
		attribute: anAttribute;
		yourself
]

{ #category : #accessing }
LPProperty >> attribute [
	^ attribute
]

{ #category : #accessing }
LPProperty >> attribute: anAttribute [
	attribute := anAttribute 
]

{ #category : #accessing }
LPProperty >> name [
	^ name
]

{ #category : #accessing }
LPProperty >> name: aName [
	name := aName
]

{ #category : #printing }
LPProperty >> printString [ 
	"Render the property name as a string."
	
	^ name asString
]
