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
LPAttributePair class >> newWith: attributeOne with: attributeTwo [
	"Create a new trait pair, in the given order."
	
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
