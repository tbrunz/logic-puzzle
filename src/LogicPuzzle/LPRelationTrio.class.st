"
I represent a higher-level relationship between three attribute 
Relationships ('left', 'right', and 'center') of a logic puzzle. 

I know how to conduct inference analyses using my trio of 
Relationships, using the set of 'true' matches in one of them 
('center') to propagate known relations between the other two.  
I can have these Relationships update themselves accordingly, 
and track when I have them make modifications and when the detect 
logical inconsistencies.

A logic puzzle contains (m-2)*C(m,2) or 3*C(m,3) instances of me, 
(where 'm' is the number of attributes in the puzzle), in the form 
of a dictionary keyed by an AttributePair.  And since the ordering 
of attributes is important for how my truth table is stored, my 
dictionary has twice as many elements; half its elements are for 
(a,b) ordering, and half are for (b,a) ordering, but both point to 
the (a,b) Relationship.
"
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
