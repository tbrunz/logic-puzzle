"
I represent a logic puzzle (such as the ""Zebra Puzzle""), a type of 
constraint satisfaction problem.

I create puzzle instances and define their top-level behavior.

I keep a dictionary of my subject attributes; attributes are comprised 
of multiple tags. 

I know how to inspect & verify my set of attributes, and how to create 
sets of relationships among them. 

I keep a dictionary of attribute relationships; I know how to print 
them, vet them, and modify them. 

I keep a dictionary of relationship truth tables; each table contains 
the true/false details of attribute relationships.

Examples:

	zebraPuzzle := LogicPuzzle new.
	
	zebraPuzzle addAttribute: #Nationality withTags: #( #Norwegian 
		#Japanese #Ukrainian #Englishman #Spaniard ).
	
	zebraPuzzle addAttribute: #Pet withTags: #( #Dog #Horse #Snails #Fox #Zebra ).
	
	zebraPuzzle createRelationships.
	--> 15 relationships created
	
	zebraPuzzle primaryAttribute: #Nationality.
	
	zebraPuzzle relationOf: #Spaniard with: #Snails is: true.
	
	zebraPuzzle printRelationship: #Nationality vs: #Pet .
"
Class {
	#name : #LogicPuzzle,
	#superclass : #Object,
	#instVars : [
		'primaryAttribute',
		'relationshipDictionary',
		'relationTrioCollection',
		'attributeDatabase'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #adding }
LogicPuzzle >> addAttribute: attributeName withTags: arrayOfTagNames [
	"Create a new attribute and add to the puzzle attribute dictionary."
	
	attributeDatabase addAttribute: attributeName withTags: arrayOfTagNames 
]

{ #category : #accessing }
LogicPuzzle >> attributeDatabase [
	^ attributeDatabase
]

{ #category : #initialization }
LogicPuzzle >> initialize [
	"Initialize my collections and constraints."

	super initialize.
	
	"Create the expandable arrays to accumulate the set of 
	Attributes and the set of Tags as the user provides them."
	attributeDatabase := LPAttributeDatabase new.
	relationshipDictionary := Dictionary new.
	relationTrioCollection := OrderedCollection new
]

{ #category : #accessing }
LogicPuzzle >> primaryAttribute [
	^ primaryAttribute
]

{ #category : #accessing }
LogicPuzzle >> primaryAttribute: attributeOrName [
	"Validate the argument to look up the attribute to set as primary."
	
	| attributeName |
	
	attributeName := attributeDatabase validateName: attributeOrName.
	
	^ primaryAttribute := attributeDatabase attributeSet at: attributeName
]

{ #category : #accessing }
LogicPuzzle >> relationTrioCollection [
	^ relationTrioCollection
]

{ #category : #accessing }
LogicPuzzle >> relationshipDictionary [
	^ relationshipDictionary
]
