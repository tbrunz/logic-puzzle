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
		'traitTablesDB',
		'tableTripletsDB',
		'traitDatabase'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #adding }
LogicPuzzle >> addTrait: aTraitName withTags: aTagArray [
	"Create a new trait for the puzzle.  The database will do validation."
	
	traitDatabase addTrait: aTraitName withTags: aTagArray
]

{ #category : #associating }
LogicPuzzle >> associationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self associationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #associating }
LogicPuzzle >> associationOf: tagOne with: tagTwo [
	"Return the association between two trait tags: either true, false, or nil."

	| traitPair tagPair traitTable |
	"Create a normalized tag pair and corresponding normalized trait pair:"
	tagPair := traitDatabase tagPairWith: tagOne with: tagTwo.
	traitPair := traitDatabase traitPairFrom: tagPair.

	"Retrieve the corresponding trait table using the trait pair:"
	traitTable := traitTablesDB at: traitPair.

	"Return the association for the tag pair:"
	^ traitTable associationOf: tagPair
]

{ #category : #associating }
LogicPuzzle >> associationOf: tagOne with: tagTwo is: aBoolean [
	"Set the association between two trait tags to either true or false."

	| traitPair tagPair traitTable |
	"Create a normalized tag pair and corresponding normalized trait pair:"
	tagPair := traitDatabase tagPairWith: tagOne with: tagTwo.
	traitPair := traitDatabase traitPairFrom: tagPair.

	"Retrieve the corresponding trait table using the trait pair:"
	traitTable := traitTablesDB at: traitPair.

	"Return the association for the tag pair:"
	^ traitTable associationOf: tagPair is: aBoolean
]

{ #category : #creating }
LogicPuzzle >> createTraitTables [
	"Create the set of trait tables for the puzzle."

	| allTraits traitOne traitTwo traitPair traitTable |
	traitTablesDB := Dictionary new.

	"Get the array of traits to step through systematically:"
	allTraits := traitDatabase allTraits.

	"Step through C(n,2) = every combination of traits taken 2 at a time:"
	1 to: allTraits size - 1 do: [ :outerIndex | 
		traitOne := allTraits at: outerIndex.

		"Step through the remaining traits in the array to pair with this one:"
		outerIndex + 1 to: allTraits size do: [ :innerIndex | 
			traitTwo := allTraits at: innerIndex.

			"Form a table 'name' & make a new table using the two traits:"
			traitPair := traitDatabase traitPairWith: traitOne with: traitTwo.
			traitTable := LPTraitTable newWith: traitPair.

			"Finally, add the new trait table to our collection:"
			traitTablesDB add: traitPair -> traitTable ] ].

	^ traitTablesDB
]

{ #category : #initialization }
LogicPuzzle >> initialize [ 

	super initialize.
	
	"Create the object that manages collections of traits & tags:"
	traitDatabase := LPTraitDatabase new.
	
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
	
	(traitDatabase traitNames anySatisfy: [ :name | name = aTraitName ])
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
	^ traitDatabase
]

{ #category : #accessing }
LogicPuzzle >> traitsDB: aTraitsDB [
	traitDatabase := aTraitsDB
]
