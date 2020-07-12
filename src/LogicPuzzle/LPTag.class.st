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
		'traitName'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LPTag class >> newNamed: aTagName ofTrait: aTraitName [
	"Create a new tag object; the names must already be validated."

	^ self new 
		name: aTagName;
		traitName: aTraitName;
		yourself
]

{ #category : #accessing }
LPTag >> name [
	^ name
]

{ #category : #accessing }
LPTag >> name: aStringOrSymbol [
	name := aStringOrSymbol asSymbol
]

{ #category : #accessing }
LPTag >> traitName [
	^ traitName
]

{ #category : #accessing }
LPTag >> traitName: aTraitName [
	traitName := aTraitName
]
