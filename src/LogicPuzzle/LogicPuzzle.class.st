"
I represent a logic puzzle (such as the ""Zebra Puzzle""), a type of constraint satisfaction problem.

I create puzzle instances and define their top-level behavior.

I keep a dictionary of my subject traits; I know how many tags each trait must have. 
I know how to inspect & verify my set of traits, and how to create a set of associations from them. 

I keep a dictionary of trait associations; I know how to print them, vet them, and modify them. 

Example:

	zebraPuzzle := LogicPuzzle traitSize: 5 .
	
	zebraPuzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian #Englishman #Spaniard ) .
	zebraPuzzle addTrait: #Pet withTags: #( #Dog #Horse #Snails #Fox #Zebra ) .
	
	zebraPuzzle createAssociations .
	--> 15 associations created
	
	zebraPuzzle makeAssociation: #Nationality as: #Spaniard to: #Pet as: #Snails .
	
	zebraPuzzle printAssociation: #Nationality vs: #Pet .
"
Class {
	#name : #LogicPuzzle,
	#superclass : #Object,
	#instVars : [
		'numberOfTraitTags',
		'primaryTrait',
		'setOfTraits',
		'setOfAssociations'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LogicPuzzle class >> traitSize: numberOfTags [
	"Create a new logic puzzle with a given number of trait tags."

	"Validiate the parameter: Throw an error if not an integer in the required range."
	self validateTraitSize: numberOfTags .

	^ self new 
		numberOfTraitTags: numberOfTags;
		setOfTraits: Dictionary new; 
		setOfAssociations: Dictionary new;
		yourself
]

{ #category : #'instance creation' }
LogicPuzzle class >> validateTraitSize: numberOfTags [
	"Validate the parameter that specifies the required number of trait tags."
	"The number of tags must be an integer greater than 1."

	(numberOfTags className = 'SmallInteger') 
		ifFalse: [ self error: 'Argument must be an integer > 1' ] .
	
	(numberOfTags > 1)
		ifFalse: [ self error: 'Traits must have at least 2 tags' ] .
		
	^ numberOfTags 
]

{ #category : #adding }
LogicPuzzle >> addTrait: traitName withTags: tagArray [
	"Create a new trait from a given symbol & array of tags."
	
	| trait |
		
	trait := LPTrait new
		name: traitName;
		size: self numberOfTraitTags;
		tags: tagArray .
	
	setOfTraits add: traitName -> trait .
	^ trait
]

{ #category : #accessing }
LogicPuzzle >> numberOfTraitTags [
	^ numberOfTraitTags
]

{ #category : #accessing }
LogicPuzzle >> numberOfTraitTags: anInteger [
	numberOfTraitTags := anInteger
]

{ #category : #accessing }
LogicPuzzle >> primaryTrait [
	^ primaryTrait
]

{ #category : #accessing }
LogicPuzzle >> primaryTrait: traitName [
	"Given a trait tag name, set the primary trait."
	| name traitKeys |
	
	"Argument must be a trait name -- string or symbol:"
	name := LPTrait validateTraitName: traitName .
	
	"Get an array of the traits keys (which are the trait names):"
	traitKeys := setOfTraits keys select: [ :key | key = name ] .
	
	"Make the error messages specific to the problem encountered:"
	traitKeys isEmpty ifTrue: [ self error: 'Unknown trait "', name, '"' ] .
	(traitKeys size > 1) ifTrue: [ self error: 'Program failure: Found more than one trait named "', name, '"!' ] .
	
	primaryTrait := name .
	^ name
	
	
]

{ #category : #accessing }
LogicPuzzle >> setOfAssociations [
	^ setOfAssociations
]

{ #category : #accessing }
LogicPuzzle >> setOfAssociations: aDictionary [
	setOfAssociations := aDictionary
]

{ #category : #accessing }
LogicPuzzle >> setOfTraits [
	^ setOfTraits
]

{ #category : #accessing }
LogicPuzzle >> setOfTraits: aDictionary [
	setOfTraits := aDictionary
]
