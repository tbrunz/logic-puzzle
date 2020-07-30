"
I represent an Attribute used to describe the subjects of a logic 
puzzle. 

The Attributes I keep track of have a name, 
e.g., #Nationality, #Color, #Sequence. 

Each Attribute has a set of Properties defined for it. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I can return my set of Properties, or one of my Properties, given 
its name.  I can also return a boolean that indicates if a given 
Property is one of my Properties or not.

A logic puzzle contains many instances of me, as I am the focus 
of all elements of a puzzle.
"
Class {
	#name : #LPAttribute,
	#superclass : #Object,
	#instVars : [
		'propertySet',
		'name'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPAttribute class >> newNamed: aName withPropertyNames: propertyNames [
	"Create a new attribute object; the name must already be validated."

	^ self new 
		initializeAs: aName with: propertyNames;
		yourself
]

{ #category : #initialization }
LPAttribute >> initializeAs: attributeName with: propertyNames [
	"Create the attribute and its Property set."

	"The names provided must already be vetted."
	name := attributeName.
	
	"Create a PropertySet from the set of Property names, 
	inserting the owning Attribute into each:"
	propertySet := propertyNames
		collect: [ :propertyName | 
			LPProperty newNamed: propertyName ofAttribute: self ]
]

{ #category : #accessing }
LPAttribute >> name [
	^ name
]

{ #category : #accessing }
LPAttribute >> name: aName [
	name := aName
]

{ #category : #printing }
LPAttribute >> printString [ 
	"Render the attribute name as a string."
	
	^ name asString
]

{ #category : #accessing }
LPAttribute >> propertySet [
	^ propertySet
]

{ #category : #accessing }
LPAttribute >> propertySet: aPropertySet [
	propertySet := aPropertySet
]
