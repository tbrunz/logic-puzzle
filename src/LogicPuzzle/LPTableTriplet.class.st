Class {
	#name : #LPTableTriplet,
	#superclass : #Object,
	#instVars : [
		'commonTrait',
		'leftTable',
		'centerTable',
		'rightTable'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #accessing }
LPTableTriplet >> centerTable [
	^ centerTable
]

{ #category : #accessing }
LPTableTriplet >> centerTable: anObject [
	centerTable := anObject
]

{ #category : #accessing }
LPTableTriplet >> commonTrait [
	^ commonTrait
]

{ #category : #accessing }
LPTableTriplet >> commonTrait: anObject [
	commonTrait := anObject
]

{ #category : #accessing }
LPTableTriplet >> leftTable [
	^ leftTable
]

{ #category : #accessing }
LPTableTriplet >> leftTable: anObject [
	leftTable := anObject
]

{ #category : #accessing }
LPTableTriplet >> rightTable [
	^ rightTable
]

{ #category : #accessing }
LPTableTriplet >> rightTable: anObject [
	rightTable := anObject
]
