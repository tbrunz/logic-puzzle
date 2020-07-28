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
		'propertyNameToPoint',
		'pointToPropertyInstance'
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
	propertyNameToPoint := Dictionary new.
	pointToPropertyInstance := Dictionary new.
	
	"Use Attribute One as 'x' or 'row':"
	attributeOne propertySet asArray withIndexDo: [ :property :index |
		tablePoint := Point x: index y: 0.
		propertyNameToPoint add: property name -> tablePoint.
		pointToPropertyInstance add: tablePoint -> property ].
	
	"And use Attribute Two as 'y' or 'column':"
	attributeTwo propertySet asArray withIndexDo: [ :property :index |
		tablePoint := Point x: 0 y: index.
		propertyNameToPoint add: property name -> tablePoint.
		pointToPropertyInstance add: tablePoint -> property ]
]

{ #category : #converting }
LPPropertyConverter >> pointToProperty: aPoint [
	"Convert the Point into a Property or Property array."

	| propertyOne propertyTwo pointX pointY |
	"Start with the assumption that we have a degenerate Point:"
	propertyOne := propertyTwo := nil.
	pointX := aPoint x.
	pointY := aPoint y.
	
	"If the 'x' component is a valid Array index, create a new 
	Point with it, then use that as a key to get its Property:"
	pointX > 0
		ifTrue: [ propertyOne := pointToPropertyInstance at: pointX @ 0 ].
		
	"If the 'y' component is a valid Array index, create a new 
	Point with it, then use that as a key to get its Property:"
	pointY > 0
		ifTrue: [ propertyTwo := pointToPropertyInstance at: 0 @ pointY ].
	
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

	"We accept either a scalar or a 2-place Array of Property:"
	aPropertyOrArray class isArray
		ifFalse: [ ^ self propertyToPointScalar: aPropertyOrArray ].

	^ self
		propertyToPointWith: aPropertyOrArray first
		with: aPropertyOrArray second
]

{ #category : #converting }
LPPropertyConverter >> propertyToPointScalar: propertyOrName [
	"We might be given a Property instance, or a name as a key."
	
	"The conversion dictionary is keyed with a symbol, NOT with a 
	Property; if we're given a Property, use its name symbol:"
	propertyOrName class = LPProperty 
		ifTrue: [ ^ propertyNameToPoint at: propertyOrName name ].
			
	^ propertyNameToPoint at: propertyOrName
]

{ #category : #converting }
LPPropertyConverter >> propertyToPointWith: propertyOne with: propertyTwo [
	"Convert the pair of Properties into a Point."

	"The Properties of two Attributes in an Attribute Relationship
	are orthogonal; therefore one Property will convert to (x@0) and 
	the other will convert to (0@y).  Therefore, they can be added:"
	^ (self propertyToPointScalar: propertyOne)
		+ (self propertyToPointScalar: propertyTwo)
]
