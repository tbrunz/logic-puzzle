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
LPTraitTable class >> newWith: traitPair [
	"Create a new trait table instance for the given trait pair."

	^ self new
		traitPair: traitPair;
		truthTable: LPTruthTable new;
		"triplets: 
			(LPTraits traits
				reject: [ :each | 
					each = traitPair traitOne or: [ each = traitPair traitTwo ] ]);"
		yourself
]

{ #category : #'instance creation' }
LPTraitTable class >> newWith: traitOne with: traitTwo [
	"Create a new trait table instance for the given traits."

	| traitPair |
	traitPair := LPTraitPair newWith: traitOne with: traitTwo.
	
	^ self newWith: traitPair
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
