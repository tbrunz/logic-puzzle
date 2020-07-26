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
	
	zebraPuzzle 
		addAttribute: #Nationality 
		withProperties: #( #Norwegian #Japanese #Ukrainian #Englishman #Spaniard ).
	
	zebraPuzzle 
		addAttribute: #Pet 
		withProperties: #( #Dog #Horse #Snails #Fox #Zebra ).
	
	zebraPuzzle createRelationships.
	
	zebraPuzzle primaryAttribute: #Nationality.
	
	zebraPuzzle relationOf: #Spaniard with: #Snails is: #Matched.
	
	string := zebraPuzzle renderRelationshipOf: #Nationality with: #Pet .
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
	^ attributeDatabase primaryAttribute
]

{ #category : #accessing }
LogicPuzzle >> primaryAttribute: attributeOrName [
	
	^ attributeDatabase primaryAttribute: attributeOrName 
]

{ #category : #lookup }
LogicPuzzle >> relationshipOf: propertyOrNameOne with: propertyOrNameTwo [
	"Get the relationship between the two Properties."

	^ (attributeDatabase
			propertyRelationshipFor: propertyOrNameOne
			with: propertyOrNameTwo) 
		relationshipState printString
]

{ #category : #lookup }
LogicPuzzle >> relationshipOf: propertyOrNameOne with: propertyOrNameTwo is: relationship [
	"Set the relationship between the two Properties."
	
	| relationshipState |
	relationshipState := self stateNameToClass: relationship.

	^ attributeDatabase
		propertyRelationshipFor: propertyOrNameOne
		with: propertyOrNameTwo
		is: relationshipState
]

{ #category : #reporting }
LogicPuzzle >> renderAllRelationships [
	"Render arr AttributeRelationship as a string for display."
	
	^ attributeDatabase renderAllRelationships
]

{ #category : #reporting }
LogicPuzzle >> renderRelationshipOf: attributeOrNameOne with: attributeOrNameTwo [
	"Render an AttributeRelationship into a string for display."
	
	^ attributeDatabase 
		renderRelationshipOf: attributeOrNameOne 
		with: attributeOrNameTwo
]

{ #category : #lookup }
LogicPuzzle >> stateNameToClass: relationshipName [
	"Validate & convert a text reference to a RelationshipState."
	
	| relationship |
	relationship := attributeDatabase validateName: relationshipName.
	
	^ LPRelationshipState stateNameToClass: relationship 
]
