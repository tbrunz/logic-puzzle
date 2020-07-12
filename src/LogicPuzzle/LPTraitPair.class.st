Class {
	#name : #LPTraitPair,
	#superclass : #Object,
	#instVars : [
		'traitOne',
		'traitTwo'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTraitPair class >> newWith: traitOne with: traitTwo [
	"Create a new trait pair, in the given order."
	
	^ self new
		traitOne: traitOne;
		traitTwo: traitTwo
]

{ #category : #accessing }
LPTraitPair >> traitOne [
	^ traitOne
]

{ #category : #accessing }
LPTraitPair >> traitOne: aTrait [
	traitOne := aTrait
]

{ #category : #accessing }
LPTraitPair >> traitTwo [
	^ traitTwo
]

{ #category : #accessing }
LPTraitPair >> traitTwo: aTrait [
	traitTwo := aTrait
]