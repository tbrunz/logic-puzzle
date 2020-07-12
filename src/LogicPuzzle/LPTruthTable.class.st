Class {
	#name : #LPTruthTable,
	#superclass : #Object,
	#instVars : [
		'traitTable',
		'isModified',
		'hasTruesAdded'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #accessing }
LPTruthTable >> hasTruesAdded [
	^ hasTruesAdded
]

{ #category : #accessing }
LPTruthTable >> hasTruesAdded: aBoolean [
	hasTruesAdded := aBoolean
]

{ #category : #accessing }
LPTruthTable >> isModified [
	^ isModified
]

{ #category : #accessing }
LPTruthTable >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #accessing }
LPTruthTable >> traitTable [
	^ traitTable
]

{ #category : #accessing }
LPTruthTable >> traitTable: aMatrix [
	traitTable := aMatrix
]
