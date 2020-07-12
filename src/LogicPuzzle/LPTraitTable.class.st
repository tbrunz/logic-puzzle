Class {
	#name : #LPTraitTable,
	#superclass : #Object,
	#instVars : [
		'traitPair',
		'truthTable'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTraitTable class >> newWith: traitOne with: traitTwo [
	"Create a new trait association, with the given ordering."

	^ self new
		traitPair: (LPTraits traitPairWith: traitOne with: traitTwo);
		triplets:
			(LPTraits traits
				reject: [ :each | each = traitOne or: [ each = traitTwo ] ]);
		yourself
]

{ #category : #accessing }
LPTraitTable >> traitPair [
	^ traitPair
]

{ #category : #accessing }
LPTraitTable >> traitPair: aTraitPair [
	traitPair := aTraitPair
]

{ #category : #accessing }
LPTraitTable >> truthTable [
	^ truthTable
]

{ #category : #accessing }
LPTraitTable >> truthTable: aTruthTable [
	truthTable := aTruthTable
]
