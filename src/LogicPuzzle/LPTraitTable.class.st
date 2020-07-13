Class {
	#name : #LPTraitTable,
	#superclass : #Object,
	#instVars : [
		'traitPair',
		'truthTable',
		'isModified',
		'hasTruesAdded'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTraitTable class >> newWith: traitPair [
	"Create a new trait table instance for the given trait pair."

	^ self new
		traitPair: traitPair;
		truthTable: (Array2D new: traitPair traitOne tags size);
		isModified: false;
		hasTruesAdded: false;
		yourself
]

{ #category : #'instance creation' }
LPTraitTable class >> newWith: traitOne with: traitTwo [
	"Create a new trait table instance for the given traits."

	| traitPair |
	traitPair := TraitPair newWith: traitOne with: traitTwo.
	
	^ self newWith: traitPair
]

{ #category : #associating }
LPTraitTable >> associationOf: aTagPair [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self associationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #associating }
LPTraitTable >> associationOf: aTagPair is: aBoolean [
	"Look up the truth table value for a tag pair: true, false, or nil."
	
	^ self associationOf: aTagPair tagOne with: aTagPair tagTwo
]

{ #category : #associating }
LPTraitTable >> associationOf: tagOne with: tagTwo [
	"Look up the truth table value for a pair of tags: true, false, or nil."
	
	
]

{ #category : #accessing }
LPTraitTable >> hasTruesAdded [
	^ hasTruesAdded
]

{ #category : #accessing }
LPTraitTable >> hasTruesAdded: aBoolean [
	hasTruesAdded := aBoolean
]

{ #category : #accessing }
LPTraitTable >> isModified [
	^ isModified
]

{ #category : #accessing }
LPTraitTable >> isModified: aBoolean [
	isModified := aBoolean
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
