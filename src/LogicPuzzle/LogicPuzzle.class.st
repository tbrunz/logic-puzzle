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

{ #category : #creating }
LogicPuzzle >> addAttribute: attributeName withTags: arrayOfTagNames [
	"Create a new attribute and add to the puzzle attribute dictionary."
	
	attributeDatabase addAttribute: attributeName withTags: arrayOfTagNames 
]

{ #category : #accessing }
LogicPuzzle >> attributeDatabase [
	^ attributeDatabase
]

{ #category : #creating }
LogicPuzzle >> createRelationships [
	"Tell the attribute database to get busy..."
	
	^ attributeDatabase createRelationships
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
	
	^ primaryAttribute := attributeDatabase attributeDictionary at: attributeName
]

{ #category : #lookup }
LogicPuzzle >> relationOfTag: tagOrNameOne withTag: tagOrNameTwo [
	"Retrieve the relationship between the two tags."
	
	| tagOne tagTwo attributePair relationship |
	tagOne := attributeDatabase validateName: tagOrNameOne.
	tagTwo := attributeDatabase validateName: tagOrNameTwo.
	
	attributePair := LPAttributePair newWith: tagOne attribute with: tagTwo attribute.
	
	relationship := attributeDatabase relationshipDictionary at: attributePair.
	
	^ relationship relationOf: tagOne with: tagTwo
]

{ #category : #lookup }
LogicPuzzle >> relationOfTag: tagOrNameOne withTag: tagOrNameTwo is: aBoolean [
	"Set the relationship between the two tags."
	
	| tagOne tagTwo attributePair relationship |
	tagOne := attributeDatabase validateName: tagOrNameOne.
	tagTwo := attributeDatabase validateName: tagOrNameTwo.
	
	tagOne := attributeDatabase tagDictionary at: tagOne.
	tagTwo := attributeDatabase tagDictionary at: tagTwo.
	
	attributePair := LPAttributePair newWith: tagOne attribute with: tagTwo attribute.
	self halt.
	relationship := attributeDatabase relationshipDictionary at: attributePair.
	
	^ relationship relationOf: tagOne with: tagTwo is: aBoolean 
]
