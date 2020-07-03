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
		'name',
		'matrix'
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
		
		"Create the matrix that will hold the linked associations:"
		matrix: (Array2D new: (firstTrait tags size));
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
LPAssociation >> firstTrait: aTrait [
	firstTrait := aTrait
]

{ #category : #accessing }
LPAssociation >> isComplete [
	^ isComplete
]

{ #category : #accessing }
LPAssociation >> isComplete: aBoolean [
	isComplete := aBoolean
]

{ #category : #accessing }
LPAssociation >> isConsistent [
	^ isConsistent
]

{ #category : #accessing }
LPAssociation >> isConsistent: aBoolean [
	isConsistent := aBoolean
]

{ #category : #accessing }
LPAssociation >> isModified [
	^ isModified
]

{ #category : #accessing }
LPAssociation >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #accessing }
LPAssociation >> matrix [
	^ matrix
]

{ #category : #accessing }
LPAssociation >> matrix: anArray2D [
	matrix := anArray2D
]

{ #category : #accessing }
LPAssociation >> secondTrait [
	^ secondTrait
]

{ #category : #accessing }
LPAssociation >> secondTrait: aTrait [
	secondTrait := aTrait
]

{ #category : #'accessing matrices' }
LPAssociation >> setColFalse: colIndex [
	"Walk the indicated column in the matrix, setting nils to 'false'."

	| trueFound |
	trueFound := false.
	1 to: matrix numberOfRows do: [ :rowIndex | 
		(matrix at: rowIndex at: colIndex)
			ifNil: [ matrix at: rowIndex at: colIndex put: false ]
			ifNotNil: [ (matrix at: rowIndex at: colIndex)
					ifTrue: [ trueFound
							ifFalse: [ trueFound := true ]
							ifTrue: [ self
									error:
										'Inconsistency found in ' , self associationName
											, ': two trues in one column' ] ] ] ]
]

{ #category : #'accessing matrices' }
LPAssociation >> setRowFalse: rowIndex [
	"Walk the indicated row in the matrix, setting nils to 'false'."
	
	| trueFound |
	trueFound := false.
	1 to: matrix numberOfColumns do: [ :colIndex |
		(matrix at: rowIndex at: colIndex) 
			ifNil: [ matrix at: rowIndex at: colIndex put: false ] 
			ifNotNil: [ (matrix at: rowIndex at: colIndex) 
				ifTrue: [ trueFound ifFalse: [ trueFound := true ] 
					ifTrue: [ self error: 'Inconsistency found in ', self associationName, ': two trues in one row' ] ] ]
		]
]
