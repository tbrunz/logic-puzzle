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
