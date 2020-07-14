Class {
	#name : #LPRelationTrio,
	#superclass : #Object,
	#instVars : [
		'commonAttribute',
		'leftRelation',
		'centerRelation',
		'rightRelation'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #accessing }
LPRelationTrio >> centerRelation [
	^ centerRelation
]

{ #category : #accessing }
LPRelationTrio >> centerRelation: aRelationship [
	centerRelation := aRelationship
]

{ #category : #accessing }
LPRelationTrio >> commonAttribute [
	^ commonAttribute
]

{ #category : #accessing }
LPRelationTrio >> commonAttribute: anAttribute [
	commonAttribute := anAttribute
]

{ #category : #accessing }
LPRelationTrio >> leftRelation [
	^ leftRelation
]

{ #category : #accessing }
LPRelationTrio >> leftRelation: aRelationship [
	leftRelation := aRelationship
]

{ #category : #'as yet unclassified' }
LPRelationTrio >> makeTriplet [

		"triplets: 
			(LPTraits traits
				reject: [ :each | 
					each = traitPair traitOne or: [ each = traitPair traitTwo ] ]);"
]

{ #category : #accessing }
LPRelationTrio >> rightRelation [
	^ rightRelation
]

{ #category : #accessing }
LPRelationTrio >> rightRelation: aRelationship [
	rightRelation := aRelationship
]
