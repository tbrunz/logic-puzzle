"
I represent a particular trait of the subjects of a logic puzzle. 

I have a name, e.g., #Nationality, #Color, or #Sequence. 
I define the set of tags for my trait, e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Given one of my tags, I know how to return its successor or predecessor. 

A logic puzzle contains a collection of all my instances, which it inspects for consistency & completeness. 
Each Association in a puzzle is composed of two of my instances.  My tags serve as its dictionary keys. 
"
Class {
	#name : #LPTraitVersion10,
	#superclass : #Object,
	#instVars : [
		'name',
		'tags',
		'indices'
	],
	#category : #'LogicPuzzle-Version10'
}

{ #category : #'instance creation' }
LPTraitVersion10 class >> newNamed: traitName with: tagArray [
	"Create a new trait with the given name and tag array."
	
	^ self new
		name: traitName;
		tags: tagArray;
		yourself
]

{ #category : #validation }
LPTraitVersion10 class >> validateNewAttributeName: traitName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	traitName isSymbol 
		ifTrue: [ ^ traitName ] .
	
	(traitName isString and: [ traitName isNotEmpty ])
		ifTrue: [ ^ traitName asSymbol ] .
	
	self error: 'Symbol required for trait labels'
]

{ #category : #accessing }
LPTraitVersion10 >> indices [
	^ indices
]

{ #category : #accessing }
LPTraitVersion10 >> indices: anIndexDictionary [
	indices := anIndexDictionary
]

{ #category : #accessing }
LPTraitVersion10 >> name [
	^ name
]

{ #category : #accessing }
LPTraitVersion10 >> name: aTraitName [
	name := aTraitName 
]

{ #category : #accessing }
LPTraitVersion10 >> tags [
	^ tags
]

{ #category : #accessing }
LPTraitVersion10 >> tags: tagArray [
	"Validate and set an array of tags, plus a dictionary of their indices."

	| index |
	"Copy tagArray, validating/converting each tag in turn:"
	tags := tagArray collect: [ :tag | self class validateNewAttributeName: tag ].
	
	"Create a dictionary mapping the tags to their corresponding index:"
	indices := Dictionary new.
	index := 0.
	tags do: [ :tag | index := index + 1. indices add: tag -> index ].
	
	^ tags
]
