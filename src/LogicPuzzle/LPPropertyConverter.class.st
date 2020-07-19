"
I am a Property Converter, exclusively owned by and used 
by a TruthTable in a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I convert a Property or a pair of Properties to a Point, 
and vice-versa.  The Points I work with are used by the 
TruthTable as indices to a 2D array.  (Pharo has 1D
Dictionaries, but not 2D Dictionaries, unfortunately.)
"
Class {
	#name : #LPPropertyConverter,
	#superclass : #Object,
	#instVars : [
		'propertyToPoint',
		'pointToProperty'
	],
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #'instance creation' }
LPPropertyConverter class >> newWith: attributeOne with: attributeTwo [
	"Generate the dictionaries needed to convert Properties & Points."
	
	self flag: #TODO.  "Need to finish generating the dictionaries!"
	
	^ self new 
		propertyToPoint: Dictionary new;
		pointToProperty: Dictionary new;
		yourself
]

{ #category : #accessing }
LPPropertyConverter >> pointToProperty [
	^ pointToProperty
]

{ #category : #conversion }
LPPropertyConverter >> pointToProperty: aPoint [
	"Convert the Point into a Property."
	
	
]

{ #category : #accessing }
LPPropertyConverter >> propertyToPoint [
	^ propertyToPoint
]

{ #category : #conversion }
LPPropertyConverter >> propertyToPoint: aProperty [
	"Convert the Property into a Point."
	
	
]

{ #category : #conversion }
LPPropertyConverter >> propertyToPointWith: propertyOne with: propertyTwo [
	"Convert the pair of Properties into a Point."
	
	
]
