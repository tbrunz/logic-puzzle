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
		'attributeDatabase'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #creating }
LogicPuzzle >> addAttribute: attributeName withProperties: propertyNameSet [
	"Create a new Attribute and add it to the puzzle attribute dictionary."
	
	attributeDatabase addAttribute: attributeName withProperties: propertyNameSet 
]

{ #category : #inferencing }
LogicPuzzle >> analyzeRelationships [ 
	"Perform an analysis pass on the current relationship states."
	
	attributeDatabase analyzeRelationships 
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
	Attributes and their PropertySets as the user provides them."
	attributeDatabase := LPAttributeDatabase new
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
LogicPuzzle >> relationshipOf: propertyOrNameOne with: propertyOrNameTwo [
	"Get the relationship between the two Properties."

	^ (attributeDatabase
			propertyRelationshipFor: propertyOrNameOne
			with: propertyOrNameTwo) 
		relationshipState
]

{ #category : #lookup }
LogicPuzzle >> relationshipOf: propertyOrNameOne with: propertyOrNameTwo is: relationshipState [
	"Set the relationship between the two Properties."

	^ attributeDatabase
		propertyRelationshipFor: propertyOrNameOne
		with: propertyOrNameTwo
		is: relationshipState
]
