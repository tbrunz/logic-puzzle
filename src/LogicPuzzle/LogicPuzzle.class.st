"
I represent a logic puzzle (such as the ""Zebra Puzzle""), a type of constraint satisfaction problem.

I create puzzle instances and define their top-level behavior.

I keep a dictionary of my subject traits; traits are comprised of multiple tags. 
I know how to inspect & verify my set of traits, and how to create a sets of associations from them. 

I keep a dictionary of trait associations; I know how to print them, vet them, and modify them. 
I keep a dictionary of truth tables; each table contains the true/false details of trait associations.

Example:

	zebraPuzzle := LogicPuzzle new.
	
	zebraPuzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian #Englishman #Spaniard ).
	zebraPuzzle addTrait: #Pet withTags: #( #Dog #Horse #Snails #Fox #Zebra ).
	
	zebraPuzzle createAssociations.
	--> 15 associations created
	
	zebraPuzzle primaryTrait: #Nationality.
	
	zebraPuzzle associationOf: #Spaniard with: #Snails is: true.
	
	zebraPuzzle printAssociation: #Nationality vs: #Pet .
"
Class {
	#name : #LogicPuzzle,
	#superclass : #Object,
	#instVars : [
		'primaryTrait',
		'reportLog',
		'traitsDB',
		'traitTablesDB',
		'tableTripletsDB'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #adding }
LogicPuzzle >> addTrait: aTraitName withTags: aTagArray [
	"Create a new trait for the puzzle.  The database will do validation."
	
	traitsDB addTrait: aTraitName withTags: aTagArray
]

{ #category : #adding }
LogicPuzzle >> createTables [
	"Create the set of trait tables for the puzzle."
	
	^ traitTablesDB 
]

{ #category : #initialization }
LogicPuzzle >> initialize [ 

	super initialize.
	
	"Create the object that manages collections of traits & tags:"
	traitsDB := LPTraits new.
	
	"Create a set of dictionaries to be filled in as the user adds traits:" 
	traitTablesDB := Dictionary new.
	tableTripletsDB := OrderedCollection new
]

{ #category : #accessing }
LogicPuzzle >> primaryTrait [
	^ primaryTrait
]

{ #category : #accessing }
LogicPuzzle >> primaryTrait: aTraitName [
	"Can only specify a trait that we know about to be a primary."
	
	(traitsDB traitNames anySatisfy: [ :name | name = aTraitName ])
		ifTrue: [ primaryTrait := aTraitName ]
		ifFalse: [ self error: 'Unknown trait "' , aTraitName printString , '"' ].
	
	^ aTraitName 
]

{ #category : #accessing }
LogicPuzzle >> reportLog [
	^ reportLog
]

{ #category : #accessing }
LogicPuzzle >> reportLog: aString [
	reportLog := aString
]

{ #category : #accessing }
LogicPuzzle >> tableTripletsDB [
	^ tableTripletsDB
]

{ #category : #accessing }
LogicPuzzle >> tableTripletsDB: aTripletsDB [
	tableTripletsDB := aTripletsDB
]

{ #category : #accessing }
LogicPuzzle >> traitTablesDB [
	^ traitTablesDB
]

{ #category : #accessing }
LogicPuzzle >> traitTablesDB: aTablesDB [
	traitTablesDB := aTablesDB
]

{ #category : #accessing }
LogicPuzzle >> traitsDB [
	^ traitsDB
]

{ #category : #accessing }
LogicPuzzle >> traitsDB: aTraitsDB [
	traitsDB := aTraitsDB
]
