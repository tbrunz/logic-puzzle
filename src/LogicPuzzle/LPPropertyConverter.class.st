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
	#category : #'LogicPuzzle-Helpers'
}

{ #category : #'instance creation' }
LPPropertyConverter class >> newWith: attributeOne with: attributeTwo [
	"Generate the dictionaries needed to convert Properties & Points."
	
	^ self new 
		initializeWith: attributeOne with: attributeTwo;
		yourself
]

{ #category : #initialization }
LPPropertyConverter >> initializeWith: attributeOne with: attributeTwo [
	"Create the custom conversion dictionaries."
	
	| tablePoint |
	propertyToPoint := Dictionary new.
	pointToProperty := Dictionary new.
	
	"Arbitrarily choose Attribute One as 'x' or 'row':"
	attributeOne propertySet asArray withIndexDo: [ :property :index |
		tablePoint := Point x: index y: 0.
		propertyToPoint add: property name -> tablePoint.
		pointToProperty add: tablePoint -> property ].
	
	"Which chooses Attribute Two as 'y' or 'column':"
	attributeTwo propertySet asArray withIndexDo: [ :property :index |
		tablePoint := Point x: 0 y: index.
		propertyToPoint add: property name -> tablePoint.
		pointToProperty add: tablePoint -> property ]
]

{ #category : #converting }
LPPropertyConverter >> pointToProperty: aPoint [
	"Convert the Point into a Property or Property array."

	| propertyOne propertyTwo |
	"Start with the assumption that we have a degenerate Point:"
	propertyOne := propertyTwo := nil.
	
	"If the 'x' component is a valid Array index, create a new 
	Point with it, then use that as a key to get its Property:"
	aPoint x > 0
		ifTrue: [ propertyOne := pointToProperty at: aPoint x @ 0 ].
		
	"If the 'y' component is a valid Array index, create a new 
	Point with it, then use that as a key to get its Property:"
	aPoint y > 0
		ifTrue: [ propertyOne := pointToProperty at: aPoint x @ 0 ].
	
	"Now revisit our assumption that one or the other Point 
	component is invalid, i.e., less than 1.  If either one is, 
	return the Property for the other; if both happen to be bad, 
	e.g., 0 @ 0, we'll end up returning 'nil', which is perfect:"
	propertyOne ifNil: [ ^ propertyTwo ].
	propertyTwo ifNil: [ ^ propertyOne ].
	
	"Finally, if we're here, both Point components are good, so 
	we've looked up two Properties; return them as an array:"
	^ Array with: propertyOne with: propertyTwo
]

{ #category : #converting }
LPPropertyConverter >> propertyToPoint: aPropertyOrArray [
	"Convert the Property into a Point."
	
	aPropertyOrArray class isArray
		ifFalse: [ ^ self propertyToPointScalar: aPropertyOrArray ].
		
	^ self propertyToPointWith: aPropertyOrArray first with: aPropertyOrArray second
]

{ #category : #converting }
LPPropertyConverter >> propertyToPointScalar: aPropertyScalar [
	"In this method, we know we have a scalar Property argument."
	
	^ propertyToPoint at: aPropertyScalar name
]

{ #category : #converting }
LPPropertyConverter >> propertyToPointWith: propertyOne with: propertyTwo [
	"Convert the pair of Properties into a Point."
	
	| pointOne pointTwo |
		
	pointOne := self propertyToPointScalar: propertyOne.
	pointTwo := self propertyToPointScalar: propertyTwo.
	
	^ pointOne + pointTwo
]
