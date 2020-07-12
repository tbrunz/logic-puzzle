Class {
	#name : #LPTraitAssn,
	#superclass : #Object,
	#instVars : [
		'traitPair',
		'triplets'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTraitAssn class >> newWith: traitOne with: traitTwo [
	"Create a new trait association, with the given ordering."

	^ self new
		traitPair: (LPTraits traitPairWith: traitOne with: traitTwo);
		triplets:
			(LPTraits traits
				reject: [ :each | each = traitOne or: [ each = traitTwo ] ]);
		yourself
]

{ #category : #accessing }
LPTraitAssn >> traitPair [
	^ traitPair
]

{ #category : #accessing }
LPTraitAssn >> traitPair: anObject [
	traitPair := anObject
]

{ #category : #accessing }
LPTraitAssn >> triplets [
	^ triplets
]

{ #category : #accessing }
LPTraitAssn >> triplets: anObject [
	triplets := anObject
]
