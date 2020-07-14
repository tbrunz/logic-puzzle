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
	#name : #LogicPuzzleVersion20,
	#superclass : #Object,
	#instVars : [
		'primaryTrait',
		'reportLog',
		'traitTablesDB',
		'tableTripletsDB',
		'traitDatabase'
	],
	#category : #'LogicPuzzle-Version20'
}

{ #category : #adding }
LogicPuzzleVersion20 >> addTrait: aTraitName withTags: aTagArray [
	"Create a new trait for the puzzle.  The database will do validation."
	
	traitDatabase addTrait: aTraitName withTags: aTagArray
]

{ #category : #associating }
LogicPuzzleVersion20 >> associationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self associationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #associating }
LogicPuzzleVersion20 >> associationOf: tagOne with: tagTwo [
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
LogicPuzzleVersion20 >> associationOf: tagOne with: tagTwo is: aBoolean [
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
LogicPuzzleVersion20 >> createTraitTables [
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
			traitTable := LPRelationship newWith: traitPair.

			"Finally, add the new trait table to our collection:"
			traitTablesDB add: traitPair -> traitTable ] ].

	^ traitTablesDB
]

{ #category : #initialization }
LogicPuzzleVersion20 >> initialize [ 

	super initialize.
	
	"Create the object that manages collections of traits & tags:"
	traitDatabase := LPTraitDatabaseVersion20 new.
	
	"Create a set of dictionaries to be filled in as the user adds traits:" 
	traitTablesDB := Dictionary new.
	tableTripletsDB := OrderedCollection new
]

{ #category : #accessing }
LogicPuzzleVersion20 >> primaryTrait [
	^ primaryTrait
]

{ #category : #accessing }
LogicPuzzleVersion20 >> primaryTrait: aTraitName [
	"Can only specify a trait that we know about to be a primary."
	
	(traitDatabase traitNames anySatisfy: [ :name | name = aTraitName ])
		ifTrue: [ primaryTrait := aTraitName ]
		ifFalse: [ self error: 'Unknown trait "' , aTraitName printString , '"' ].
	
	^ aTraitName 
]

{ #category : #accessing }
LogicPuzzleVersion20 >> reportLog [
	^ reportLog
]

{ #category : #accessing }
LogicPuzzleVersion20 >> reportLog: aString [
	reportLog := aString
]

{ #category : #accessing }
LogicPuzzleVersion20 >> tableTripletsDB [
	^ tableTripletsDB
]

{ #category : #accessing }
LogicPuzzleVersion20 >> tableTripletsDB: aTripletsDB [
	tableTripletsDB := aTripletsDB
]

{ #category : #accessing }
LogicPuzzleVersion20 >> traitTablesDB [
	^ traitTablesDB
]

{ #category : #accessing }
LogicPuzzleVersion20 >> traitTablesDB: aTablesDB [
	traitTablesDB := aTablesDB
]

{ #category : #accessing }
LogicPuzzleVersion20 >> traitsDB [
	^ traitDatabase
]

{ #category : #accessing }
LogicPuzzleVersion20 >> traitsDB: aTraitsDB [
	traitDatabase := aTraitsDB
]
