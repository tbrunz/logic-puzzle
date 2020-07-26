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
	#name : #LPRelationshipTrio,
	#superclass : #Object,
	#instVars : [
		'commonAttribute',
		'leftRelationship',
		'centerRelationship',
		'rightRelationship'
	],
	#category : #'LogicPuzzle-Relationships'
}

{ #category : #'instance creation' }
LPRelationshipTrio class >> newFrom: attributeTrio for: commonAttribute using: attributeDatabase [
	"Form an relationship trio from the given attributes."
	
	^ self new
		initializeFrom: attributeTrio for: commonAttribute using: attributeDatabase;
		yourself
]

{ #category : #accessing }
LPRelationshipTrio >> centerRelationship [
	^ centerRelationship
]

{ #category : #accessing }
LPRelationshipTrio >> commonAttribute [
	^ commonAttribute
]

{ #category : #deductions }
LPRelationshipTrio >> duplicateTruthTableState: propertyRelationshipOne with: propertyRelationshipTwo [
	"One PropertyRelationship is 'unknown', one is 'matched' or 'excluded'; 
	Make the 'unknown' relationship state the same as the other state."

	| stateOne stateTwo |
	stateOne := propertyRelationshipOne relationshipState.
	stateTwo := propertyRelationshipTwo relationshipState.

	"Test either state to decide which direction to copy."
	(stateOne = LPRelationshipUnknown) 
		ifTrue: [ propertyRelationshipOne relationshipState: stateTwo; commit ]
		ifFalse: [ propertyRelationshipTwo relationshipState: stateOne; commit ]
]

{ #category : #deductions }
LPRelationshipTrio >> inferRelationships [
	"Use the matches in the center attribute relationship to infer 
	relationships between the other two attribute relationships."

	| leftPropertyRelationship rightPropertyRelationship |
	"We can only infer associated relationships for matched Properties."
	centerRelationship collectMatchedRelationships
		do: [ :relationship | 
			"Walk the Properties for the Attribute common to left & right:"
			commonAttribute propertySet
				do: [ :property | 
					leftPropertyRelationship := (LPPropertyRelationship 
						newFor: leftRelationship
						with: relationship propertyOne 
						with: property) fetch.
						
					rightPropertyRelationship := (LPPropertyRelationship 
						newFor: rightRelationship
						with: property
						with: relationship propertyTwo) fetch.
					
					self 
						syncTruthTablesFor: centerRelationship 
							with: leftPropertyRelationship 
							with: rightPropertyRelationship ] ]
]

{ #category : #initialization }
LPRelationshipTrio >> initializeFrom: attributeTrio for: aCommonAttribute using: attributeDatabase [
	"Form an relationship trio from the given attributes."

	| leftKey centerKey rightKey relationshipDictionary |
	commonAttribute := aCommonAttribute.
	
	"Collect both Attributes in the trio that are NOT the common Attribute:"
	centerRelationship := attributeTrio
		reject: [ :attribute | attribute = commonAttribute ].

	"The key for the center relationship is made from the collected pair:"
	centerKey := attributeDatabase 
		attributeRelationshipKeyFor: centerRelationship first 
		with: centerRelationship second.

	"The left key uses Attribute one from the center, plus the common:"
	leftKey := attributeDatabase 
		attributeRelationshipKeyFor: centerRelationship first 
		with: commonAttribute.
		
	"The right key uses the common, plus Attribute two from the center:"
	rightKey := attributeDatabase 
		attributeRelationshipKeyFor: commonAttribute
		with: centerRelationship second.

	"Now use the AttributeDatabase once more to reference the Relationship 
	Dictionary to get each of the three Attribute Relationships:"
	relationshipDictionary := attributeDatabase relationshipDictionary.
	
	"And set our relationships by looking up each of the three keys:"
	leftRelationship := relationshipDictionary at: leftKey.
	rightRelationship := relationshipDictionary at: rightKey.
	centerRelationship := relationshipDictionary at: centerKey
]

{ #category : #accessing }
LPRelationshipTrio >> leftRelationship [
	^ leftRelationship
]

{ #category : #accessing }
LPRelationshipTrio >> rightRelationship [
	^ rightRelationship
]

{ #category : #deductions }
LPRelationshipTrio >> syncTruthTablesFor: attributeRelationship with: propertyRelationshipOne with: propertyRelationshipTwo [
	"Compare states of two PropertyRelationships related by a common Attribute."

	| stateOne stateTwo |
	stateOne := propertyRelationshipOne relationshipState.
	stateTwo := propertyRelationshipTwo relationshipState.
	
	"If the two states match, they're consistent, but there's also 
	nothing to do here; return 'nil' to indicate 'nothing done'."
	stateOne = stateTwo
		ifTrue: [ ^ self ].

	"If only one state is 'unknown', replace it with the other state;
	But two non-excluded states that differ is an inconsistency error:"
	(stateOne = LPRelationshipUnknown xor: [ stateTwo = LPRelationshipUnknown ])
		ifFalse: [ attributeRelationship isInconsistent: true ]
		ifTrue: [ self 
			duplicateTruthTableState: propertyRelationshipOne 
			with: propertyRelationshipTwo ]
]
