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
	
	^ self 
		newWith: attributePair attributeOne with: attributePair attributeTwo 
]

{ #category : #'instance creation' }
LPRelationship class >> newWith: attributeOne with: attributeTwo [
	"Create a new relationship instance for the given attributes."

	| count indices |
	"Make a dictionary to map tags to their corresponding matrix indices:"
	count := attributeOne tags size.
	indices := Dictionary new.
	
	"Note that tags are unique, even between attributes; matrix indices aren't.
	This is because the truth table is 2D, so the index ranges are the same.
	We'll need to address the truth table with a pair of tags.  There's a 
	1D Dictionary, but not a 2D dictionary, so we'll need the combination 
	of a Dictionary and an Array2D to make the mapping."
	1 to: count do: [ :i | 
		indices add: (attributeOne tags at: i) -> i.
		indices add: (attributeTwo tags at: i) -> i ].
	
	^ self new
		truthTable: (Array2D new: count);
		
		tagIndices: indices;
		truePairs: OrderedCollection new;
		
		isModified: false;
		hasTruesAdded: false;
		
		yourself
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

{ #category : #relationship }
LPRelationship >> relationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #relationship }
LPRelationship >> relationOf: aTagPair is: aBoolean [
	"Set the truth table value for a tag pair: true, false, or nil."
	
	^ self relationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #relationship }
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
