"
I represent an ordered pair of attributes that represent the 
tag relationships between two subjects of a logic puzzle. 

I am mostly used as the key to the dictionary of Relationships.
See the comment for 'LPAttribute' for more information about me.
"
Class {
	#name : #LPAttributePair,
	#superclass : #Object,
	#instVars : [
		'attributeOne',
		'attributeTwo'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPAttributePair class >> newWith: anAttributeArray [
	"Create a new attribute pair from a collection of attributes."
	
	^ self new
		attributeOne: (anAttributeArray at: 1);
		attributeTwo: (anAttributeArray at: 2);
		yourself
]

{ #category : #'instance creation' }
LPAttributePair class >> newWith: attributeOne with: attributeTwo [
	"Create a new attribute pair from given attributes."
	
	^ self new
		attributeOne: attributeOne;
		attributeTwo: attributeTwo;
		yourself
]

{ #category : #accessing }
LPAttributePair >> attributeOne [
	^ attributeOne
]

{ #category : #accessing }
LPAttributePair >> attributeOne: anAttribute [
	attributeOne := anAttribute
]

{ #category : #accessing }
LPAttributePair >> attributeTwo [
	^ attributeTwo
]

{ #category : #accessing }
LPAttributePair >> attributeTwo: anAttribute [
	attributeTwo := anAttribute
]

{ #category : #label }
LPAttributePair >> dictionaryKey [
	"Return a symbol that can serve as a dictionary key."
	
	^ attributeOne name , attributeTwo name 
]
