"
I represent an ordered pair of tags that represent a relationship 
between two attributes values for the subjects of a logic puzzle. 

I can be used to refer to truth table cell in a Relationship.
See the comment for 'LPTag' for more information about me.
"
Class {
	#name : #LPTagPair,
	#superclass : #Object,
	#instVars : [
		'tagOne',
		'tagTwo',
		'relationship'
	],
	#category : #'LogicPuzzle-Version30'
}

{ #category : #'instance creation' }
LPTagPair class >> newFor: aRelationship with: tagOne with: tagTwo [

	^ self new
		relationship: aRelationship;
		tagOne: tagOne;
		tagTwo: tagTwo;
		yourself
]

{ #category : #'instance creation' }
LPTagPair class >> newWith: tagOne with: tagTwo [

	^ self new
		tagOne: tagOne;
		tagTwo: tagTwo;
		yourself
]

{ #category : #relationship }
LPTagPair >> relationship [
	"Return the relationship of the two tags in the TagPair."

	relationship ifNil: [ ^ nil ].
		
	^ relationship relationOf: tagOne with: tagTwo
]

{ #category : #accessing }
LPTagPair >> relationship: aRelationship [
	relationship := aRelationship
]

{ #category : #relationship }
LPTagPair >> relationshipIs: aBoolean [
	"Set the relationship of the tags."

	relationship ifNil: [ ^ nil ].
		
	^ relationship relationshipOf: tagOne with: tagTwo is: aBoolean
]

{ #category : #accessing }
LPTagPair >> tagOne [
	^ tagOne
]

{ #category : #accessing }
LPTagPair >> tagOne: aTag [
	tagOne := aTag
]

{ #category : #accessing }
LPTagPair >> tagTwo [
	^ tagTwo
]

{ #category : #accessing }
LPTagPair >> tagTwo: aTag [
	tagTwo := aTag
]
