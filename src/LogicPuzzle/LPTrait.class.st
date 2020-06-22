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
		'size',
		'tagSet'
	],
	#category : #LogicPuzzle
}

{ #category : #accessing }
LPTrait >> name [
	^ name
]

{ #category : #accessing }
LPTrait >> name: traitName [
	"Set the trait name, but validate it first."
	"Accept strings or symbols, else throw an error."
	
	name := self validateTraitName: traitName 
]

{ #category : #accessing }
LPTrait >> size: anObject [
	size := anObject
]

{ #category : #accessing }
LPTrait >> tagSet [
	^ tagSet
]

{ #category : #accessing }
LPTrait >> tagSet: anObject [
	tagSet := anObject
]

{ #category : #adding }
LPTrait >> tags: tagArray [
	"Validate and set an array of tags."
	
	| trait |
		
	"Create a new trait from the parameters."	
	
	(tagArray className = 'Array')
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ] .
	
	tagArray isEmpty 
		ifTrue: [ self error: 'Cannot add a trait with no tags!' ] .
	
	(tagArray at: 1 className = 'Array')
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ] .
	
	"Ensure that the number of tags equals the required size."
	(tagArray size = self numberOfTraitTags) 
		ifFalse: [  ]
]

{ #category : #adding }
LPTrait >> validateTraitName: traitName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	(traitName className = 'ByteSymbol') 
		ifTrue: [ ^ traitName ] .
	
	((traitName className = 'ByteString') and: [ traitName isNotEmpty ])
		ifTrue: [ ^ traitName asSymbol ] .
	
	self error: 'Symbol required for trait names'
]
