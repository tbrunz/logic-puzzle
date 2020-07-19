"
I represent a 'truth table' of the Property Relationships 
between two Attributes of the subjects of a Logic Puzzle. 

The Attributes in a Logic Puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

Each of these Attributes defines a set of Properties. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I manage the set of Property Relationships that exist among 
all combinations of Properties of my two Attributes, and I 
know the Attribute Relationship I belong to.

I can get and set the Property Relationships that I hold; 
the Property Relationship objects know their two Properties 
as well as the Relationship State between them.
"
Class {
	#name : #LPTruthTable,
	#superclass : #Object,
	#instVars : [
		'attributeRelationship',
		'truthTable',
		'propertyConverter'
	],
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #'instance creation' }
LPTruthTable class >> newWith: attributeRelationship [ 
	"Tell the new instance what AttributeRelationship it's for."
	
	^ self new
		initializeWith: attributeRelationship;
		yourself
]

{ #category : #'as yet unclassified' }
LPTruthTable >> commitRelationship: aPropertyRelationship [
	"Return a PropertyRelationship from the TruthTable."

	| tablePoint propertyOne propertyTwo |
	propertyOne := aPropertyRelationship propertyOne.
	propertyTwo := aPropertyRelationship propertyTwo.
	
	tablePoint := propertyConverter
		propertyToPointWith: propertyOne with: propertyTwo.
		
	^ truthTable
		at: tablePoint x
		at: tablePoint y
		put: aPropertyRelationship
]

{ #category : #'as yet unclassified' }
LPTruthTable >> fetchRelationship: aPropertyRelationship [
	"Return a PropertyRelationship from the TruthTable."

	| tablePoint propertyOne propertyTwo |
	propertyOne := aPropertyRelationship propertyOne.
	propertyTwo := aPropertyRelationship propertyTwo.
	
	tablePoint := propertyConverter
		propertyToPointWith: propertyOne with: propertyTwo.
		
	^ truthTable at: tablePoint x at: tablePoint y
]

{ #category : #initialization }
LPTruthTable >> initializeWith: anAttributeRelationship [
	"Generate our PropertyConverter instance and fill our TruthTable."

	| attributeOne attributeTwo |
	attributeOne := anAttributeRelationship attributeOne.
	attributeTwo := anAttributeRelationship attributeTwo.
	
	"Remember who our boss is:"
	attributeRelationship := anAttributeRelationship.
	
	"Fill all our cells with Unknown-type PropertyRelationships.
	Both of our Attributes have Property sets of the same size;
	Array2D objects are square matrices of a given size:"
	truthTable := Array2D 
		new: attributeOne propertySet size
		element: (LPPropertyRelationship new
			relationshipState: LPRelationshipUnknown).

	"Build us a customized PropertyConverter."
	propertyConverter := LPPropertyConverter
		newWith: attributeOne
		with: attributeTwo
]
