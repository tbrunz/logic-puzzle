Class {
	#name : #LPRelationship,
	#superclass : #Object,
	#instVars : [
		'truthTable',
		'isModified',
		'hasTruesAdded',
		'tagIndices',
		'truePairs',
		'attributePair'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPRelationship class >> newWith: attributePair [
	"Create a new trait table instance for the given trait pair."
	
	"TODO: create the tagIndices array from the attribute pair tag arrays"

	^ self new
		attributePair: attributePair;
		truthTable: (Array2D new: attributePair attributeOne tags size);
		tagIndices: OrderedCollection new;
		truePairs: OrderedCollection new;
		isModified: false;
		hasTruesAdded: false;
		yourself
]

{ #category : #'instance creation' }
LPRelationship class >> newWith: attributeOne with: attributeTwo [
	"Create a new relationship instance for the given attributes."

	^ self newWith: (LPAttributePair newWith: attributeOne with: attributeTwo)
]

{ #category : #accessing }
LPRelationship >> attributePair [
	^ attributePair
]

{ #category : #accessing }
LPRelationship >> attributePair: anObject [
	attributePair := anObject
]

{ #category : #accessing }
LPRelationship >> hasTruesAdded [
	^ hasTruesAdded
]

{ #category : #accessing }
LPRelationship >> hasTruesAdded: aBoolean [
	hasTruesAdded := aBoolean
]

{ #category : #accessing }
LPRelationship >> isModified [
	^ isModified
]

{ #category : #accessing }
LPRelationship >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #associating }
LPRelationship >> relationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #associating }
LPRelationship >> relationOf: aTagPair is: aBoolean [
	"Set the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #associating }
LPRelationship >> relationOf: tagOne with: tagTwo [
	"Look up the truth table value for a pair of tags: true, false, or nil."
	
	
]

{ #category : #accessing }
LPRelationship >> tagIndices [
	^ tagIndices
]

{ #category : #accessing }
LPRelationship >> tagIndices: anIndexArray [
	tagIndices := anIndexArray
]

{ #category : #accessing }
LPRelationship >> truePairs [
	^ truePairs
]

{ #category : #accessing }
LPRelationship >> truePairs: anObject [
	truePairs := anObject
]

{ #category : #accessing }
LPRelationship >> truthTable [
	^ truthTable
]

{ #category : #accessing }
LPRelationship >> truthTable: aTruthTable [
	truthTable := aTruthTable
]
