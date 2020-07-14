"
I represent a trait tag that describes a trait of the subjects of 
a logic puzzle. 

The traits in a logic puzzle have names, 
e.g., #Nationality, #Color, #Sequence. 

For each of these traits, I define one of its tags. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I can return the name of the trait I belong to, which can then 
be used to look up my trait object.  (I don't keep my trait 
object in me, in order to prevent lookup looping.)

I can also return a boolean that indicates if a given trait is 
my trait or not.

A logic puzzle contains many instances of me, as I am the focus 
of all elements of a puzzle.
"
Class {
	#name : #LPTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'attribute'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTag class >> newNamed: aTagName ofAttribute: anAttribute [
	"Create a new tag object; the name must already be validated."

	^ self new 
		name: aTagName;
		traitName: anAttribute;
		yourself
]

{ #category : #accessing }
LPTag >> attribute [
	^ attribute
]

{ #category : #accessing }
LPTag >> attribute: anAttribute [
	attribute := anAttribute 
]

{ #category : #accessing }
LPTag >> name [
	^ name
]

{ #category : #accessing }
LPTag >> name: aStringOrSymbol [
	name := aStringOrSymbol asSymbol
]
