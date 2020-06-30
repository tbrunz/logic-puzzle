"
I represent a particular trait of the subjects of a logic puzzle. 

I have a name, e.g., #Nationality, #Color, or #Sequence. 
I define the set of tags for my trait, e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Given one of my tags, I know how to return its successor or predecessor. 

A logic puzzle contains a collection of all my instances, which it inspects for consistency & completeness. 
Each Association in a puzzle is composed of two of my instances.  My tags serve as its dictionary keys. 
"
Class {
	#name : #LPTrait,
	#superclass : #Object,
	#instVars : [
		'name',
		'tags',
		'indices'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTrait class >> newNamed: traitName with: tagArray [
	"Create a new trait with the given name and tag array."
	
	^ self new
		name: traitName;
		tags: tagArray;
		yourself
]

{ #category : #validation }
LPTrait class >> validateTraitName: traitName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	traitName isSymbol 
		ifTrue: [ ^ traitName ] .
	
	(traitName isString and: [ traitName isNotEmpty ])
		ifTrue: [ ^ traitName asSymbol ] .
	
	self error: 'Symbol required for trait labels'
]

{ #category : #accessing }
LPTrait >> indices [
	^ indices
]

{ #category : #accessing }
LPTrait >> indices: anIndexDictionary [
	indices := anIndexDictionary
]

{ #category : #accessing }
LPTrait >> name [
	^ name
]

{ #category : #accessing }
LPTrait >> name: aTraitName [
	name := aTraitName 
]

{ #category : #accessing }
LPTrait >> tags [
	^ tags
]

{ #category : #accessing }
LPTrait >> tags: tagArray [
	"Validate and set an array of tags, plus a dictionary of their indices."

	| index |
	"Copy tagArray, validating/converting each tag in turn:"
	tags := tagArray collect: [ :tag | self class validateTraitName: tag ].
	
	"Create a dictionary mapping the tags to their corresponding index:"
	indices := Dictionary new.
	index := 0.
	tags do: [ :tag | index := index + 1. indices add: tag -> index ].
	
	^ tags
]
