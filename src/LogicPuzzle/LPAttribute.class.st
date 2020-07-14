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
	#name : #LPAttribute,
	#superclass : #Object,
	#instVars : [
		'name',
		'tags'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPAttribute class >> newNamed: anAttributeName withTags: aTagArray [
	"Create a new attribute object; the name must already be validated."

	^ self new 
		name: anAttributeName;
		tags: aTagArray;
		yourself
]

{ #category : #accessing }
LPAttribute >> name [
	^ name
]

{ #category : #accessing }
LPAttribute >> name: aStringOrSymbol [
	name := aStringOrSymbol asSymbol
]

{ #category : #accessing }
LPAttribute >> tags [
	^ tags
]

{ #category : #accessing }
LPAttribute >> tags: aTagArray [
	tags := aTagArray
]
