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

{ #category : #associating }
LogicPuzzle >> associationOf: tagOne with: tagTwo [
	"Return the association between two trait tags: either true, false, or nil."
	
	| traitOne traitTwo traitPair traitTable |
	"Validate and convert the tags to their traits, which determine the table:"
	traitOne := traitsDB traitOfTag: tagOne.
	traitTwo := traitsDB traitOfTag: tagTwo.
	
	"A trait pair is needed as the key to the trait tables collection:"
	traitPair := LPTraitPair newWith: traitOne with: traitTwo.
	
	"We don't know if the order of the traits is correct; fix as needed:"
	traitPair := traitPair canonicalizeFor: self traitPair.
	
	"Retrieve the corresponding trait table:"
	traitTable := traitTablesDB at: traitPair.
	
	^ traitTable associationOf: tagOne with: tagTwo
]

{ #category : #associating }
LogicPuzzle >> associationOf: tagOne with: tagTwo is: aBoolean [
	"Set the association between two trait tags to either true or false."
	
	^ self
]

{ #category : #creating }
LogicPuzzle >> createTraitTables [
	"Create the set of trait tables for the puzzle."

	| allTraits traitOne traitTwo traitPair traitTable |
	traitTablesDB := Dictionary new.

	"Get the array of traits to step through systematically:"
	allTraits := traitsDB traits.

	"Step through C(n,2) = every combination of traits taken 2 at a time:"
	1 to: allTraits size - 1 do: [ :outerIndex | 
		traitOne := allTraits at: outerIndex.

		"Step through the remaining traits in the array to pair with this one:"
		outerIndex + 1 to: allTraits size do: [ :innerIndex | 
			traitTwo := allTraits at: innerIndex.

			"Form a table 'name' & make a new table using the two traits:"
			traitPair := LPTraitPair newWith: traitOne with: traitTwo.
			traitTable := LPTraitTable newWith: traitPair.

			"Finally, add the new trait table to our collection:"
			traitTablesDB add: traitPair -> traitTable ] ].

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
