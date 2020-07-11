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
		'traitAssnDB',
		'truthTableDB'
	],
	#category : #'LogicPuzzle-Base'
}
