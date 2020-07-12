"
I represent a trait that describes the subjects of a logic puzzle. 

The traits I keep track of have a name, 
e.g., #Nationality, #Color, #Sequence. 

For each of my traits, I define its set of tags. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I can return my array of tags, or one of my tags, given its name.
I can also return a boolean that indicates if a given tag is one 
of my tags or not.

A logic puzzle contains many instances of me, as I am the focus 
of all elements of a puzzle.
"
Class {
	#name : #LPTrait,
	#superclass : #Object,
	#instVars : [
		'name',
		'tags'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTrait class >> newNamed: aTraitName withTags: aTagArray [
	"Create a new trait object; the names must already be validated."

	^ self new 
		name: aTraitName;
		tags: aTagArray;
		yourself
]

{ #category : #accessing }
LPTrait >> name [
	^ name
]

{ #category : #accessing }
LPTrait >> name: aStringOrSymbol [
	name := aStringOrSymbol asSymbol
]

{ #category : #accessing }
LPTrait >> tags [
	^ tags
]

{ #category : #accessing }
LPTrait >> tags: aTagArray [
	tags := aTagArray
]
