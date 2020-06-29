"
I represent an association between two puzzle traits. 

I use my traits to create a pair of Dictionaries, representing Row and Column.
My Dictionary keys are taken from the set of tags for each of my traits. 

I form a grid, in row-major order, with each cell containing ( true | false | nil ). 
If a cell is ""true"", its row tag is logically associated with its column tag. 
If a cell is ""false"", its row tag is not associated with its column tag. 
If a cell is ""nil"", the associate between the two trait values is unknown. 

I know how to set an association in myself, and I can report the status of an association.
I know how to inspect myself to determine if I am logically complete (all traits are associated).
I know how to inspect myself to determine if I am logically consistent 
 (i.e., every row trait can be associated with only one column trait).

I know how to render myself as a printable string. 
I know how to render an entire row or column of myself as a printable string. 
"
Class {
	#name : #LPAssociation,
	#superclass : #Object,
	#instVars : [
		'isComplete',
		'isConsistent',
		'isModified',
		'firstTrait',
		'secondTrait',
		'name'
	],
	#classInstVars : [
		'nameSeparator'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #accessing }
LPAssociation class >> nameSeparator [
	^ nameSeparator
]

{ #category : #accessing }
LPAssociation class >> nameSeparator: aString [
	nameSeparator := aString
]

{ #category : #naming }
LPAssociation class >> nameWith: firstSymbol with: secondSymbol [
	"Create an association name (symbol) from its trait names."

	^ (String
		streamContents: [ :stream | 
			stream
				nextPutAll: firstSymbol asString;
				nextPutAll: self nameSeparator;
				nextPutAll: secondSymbol asString ]) asSymbol
]

{ #category : #'instance creation' }
LPAssociation class >> newWith: firstTrait with: secondTrait [
	"Create a new association between two given traits."

	^ self new
		isComplete: false;
		isConsistent: true;
		isModified: false;
		
		"Register the traits, which contain the grid indices:"
		firstTrait: firstTrait;
		secondTrait: secondTrait;
		
		"Use the trait names to make a unique association name:"
		associationName: (self nameWith: firstTrait name with: secondTrait name);
		yourself
		
]

{ #category : #naming }
LPAssociation class >> traitNamesFrom: anAssociationName [
	"Decompose an association key into its constituent trait keys."
	
	^ anAssociationName splitOn: self nameSeparator 
]

{ #category : #accessing }
LPAssociation >> associationName [
	^ name
]

{ #category : #accessing }
LPAssociation >> associationName: stringOrSymbol [
	name := stringOrSymbol 
]

{ #category : #accessing }
LPAssociation >> firstTrait [
	^ firstTrait
]

{ #category : #accessing }
LPAssociation >> firstTrait: anObject [
	firstTrait := anObject
]

{ #category : #accessing }
LPAssociation >> isComplete [
	^ isComplete
]

{ #category : #accessing }
LPAssociation >> isComplete: anObject [
	isComplete := anObject
]

{ #category : #accessing }
LPAssociation >> isConsistent [
	^ isConsistent
]

{ #category : #accessing }
LPAssociation >> isConsistent: anObject [
	isConsistent := anObject
]

{ #category : #accessing }
LPAssociation >> isModified [
	^ isModified
]

{ #category : #accessing }
LPAssociation >> isModified: anObject [
	isModified := anObject
]

{ #category : #accessing }
LPAssociation >> secondTrait [
	^ secondTrait
]

{ #category : #accessing }
LPAssociation >> secondTrait: anObject [
	secondTrait := anObject
]
