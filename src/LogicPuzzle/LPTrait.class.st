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
		'tags'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #accessing }
LPTrait >> name [
	^ name
]

{ #category : #accessing }
LPTrait >> name: traitName [
	"Set the trait name, but validate it first."
	"Accept strings or symbols, else throw an error."
	
	name := self validateTraitLabel: traitName 
]

{ #category : #accessing }
LPTrait >> size: tagArraySize [
	size := tagArraySize
]

{ #category : #accessing }
LPTrait >> tags [
	^ tags
]

{ #category : #adding }
LPTrait >> tags: tagArray [
	"Validate and set an array of tags.  Use an array so we have 'wrap' indexing."
	
	self validateTraitTags: tagArray .
	
	tags := Array ofSize: size .
	
	1 to: size do: [ :index |
		tags at: index put: (self validateTraitLabel: (tagArray at: index)) ] .
	
	^ tags
]

{ #category : #adding }
LPTrait >> validateTraitLabel: traitName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	(traitName className = 'ByteSymbol') 
		ifTrue: [ ^ traitName ] .
	
	((traitName className = 'ByteString') and: [ traitName isNotEmpty ])
		ifTrue: [ ^ traitName asSymbol ] .
	
	self error: 'Symbol required for trait labels'
]

{ #category : #adding }
LPTrait >> validateTraitTags: tagArray [
	"Validate an array of tags.  We require an array because we need 'next' & 'prev' methods."
	
	(tagArray className = 'Array')
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ] .
	
	(tagArray size = size) 
		ifFalse: [ self error: 'This puzzle requires ', size, ' trait tags' ] .
	
	^ tagArray 
]
