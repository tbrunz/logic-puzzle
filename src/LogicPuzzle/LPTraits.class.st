"
I represent a database of traits and tags that describe the subjects 
of a logic puzzle. 

The traits I keep track of have a name, 
e.g., #Nationality, #Color, #Sequence. 

So do the tags I keep track of, 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Given a trait or trait name, I can return the array of its tags.
Given a tag or tag name, I can return the trait that it belongs to.

As the above implies, every tag must be distinct, independent of trait.

Every trait must have the same number of tags.

A logic puzzle contains one instance of me, and uses me to relate 
tags & traits.
"
Class {
	#name : #LPTraits,
	#superclass : #Object,
	#instVars : [
		'tags',
		'traits',
		'triplets',
		'width',
		'minNumberOfTraits',
		'minNumberOfTags'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #adding }
LPTraits >> addTrait: stringOrSymbol withTags: tagArray [
	"Create a new trait from a given symbol & array of tags."

	| traitName traitTagNames traitTags |
	"Accept strings or symbols for the name; convert strings to symbols."
	traitName := self validateName: stringOrSymbol.

	"Validate the trait tags for type and number; convert all to symbols:"
	traitTagNames := self validateTagArray: tagArray.

	"Verify that none of the tags in the array duplicates any we already know:"
	self tagNames
		do: [ :tagName | 
			| tagTraitName |
			tagTraitName := self traitOfTag: tagName.
			(traitTagNames anySatisfy: [ :each | each = tagName and: [ traitName ~= tagTraitName ] ])
				ifTrue: [ 
					self
						error:
							'Duplicate tags not allowed (' , tagName , ' belongs to trait '
								, tagTraitName , ')' ] ].

	"We want the array of tags that the trait holds to be tag objects, not just names:"
	traitTags := tagArray
		collect: [ :each | LPTag newNamed: each ofTrait: traitName ].

	"We disallow duplicate trait names, but replacing an existing trait is okay."
	tags add: traitName -> traitTags.

	"Add each of its tags to the traits dictionary, but pointing to a trait name, not an object:"
	traitTagNames do: [ :tagName | traits add: tagName -> traitName ].
	
	^ traitName
]

{ #category : #initialization }
LPTraits >> initialize [
	"I need a pair of complementary dictionaries, so that 
	I can refer to my data symbolically (as my user does)."

	super initialize.

	"Create the dictionaries for the traits and tags of this puzzle.
	Their elements will be provided later by the user."
	traits := Dictionary new.
	tags := Dictionary new.

	"I don't know yet what my width (number of tags per trait) will be.
	As traits and tags are provided to me, I need to compare their number 
	to something, so start with a value that is obviously too low.
	The first set of tags will replace my value with its size."
	width := -1.

	"Set constraints for this puzzle that apply universally."
	minNumberOfTraits := 3.
	minNumberOfTags := 2
]

{ #category : #accessing }
LPTraits >> minNumberOfTags [
	^ minNumberOfTags
]

{ #category : #accessing }
LPTraits >> minNumberOfTags: anInteger [
	minNumberOfTags := anInteger
]

{ #category : #accessing }
LPTraits >> minNumberOfTraits [
	^ minNumberOfTraits
]

{ #category : #accessing }
LPTraits >> minNumberOfTraits: anInteger [
	minNumberOfTraits := anInteger
]

{ #category : #accessing }
LPTraits >> tagNames [
	"The 'traits' collection is a dictionary; 
	Its values are trait objects; therefore, 
	its keys are the tag names.  Return them."
	^ traits keys
]

{ #category : #accessing }
LPTraits >> tags [
	^ tags asArray 
]

{ #category : #accessing }
LPTraits >> tagsOfTrait: aTraitOrTraitName [
	"Respond with the array of tags of the given trait."
	
	| traitName |
	"You could just ask the trait itself for its tags..."
	aTraitOrTraitName class = LPTrait
		ifTrue: [ ^ aTraitOrTraitName tags ].
	
	"Otherwise, all we have is a name, so we do a lookup:"
	traitName := self validateName: aTraitOrTraitName.
	
	^ tags at: traitName ifAbsent: [ Array ofSize: 0 ]
]

{ #category : #accessing }
LPTraits >> traitNames [
	"The 'tags' collection is a dictionary; 
	Its values are tag objects; therefore, 
	its keys are the trait names.  Return them."
	^ tags keys
]

{ #category : #accessing }
LPTraits >> traitOfTag: aTagOrTagName [
	"Respond with the trait that the given tag belongs to."

	| tagName |
	"A tag object does *not* store its trait object, only its name.
	Therefore, we will have to do a lookup whether we're given a 
	tag object or a tag name.  Tag objects store both names."
	tagName := aTagOrTagName class = LPTag
		ifTrue: [ aTagOrTagName name ]
		ifFalse: [ self validateName: aTagOrTagName ].
		
	^ traits at: tagName ifAbsent: [ #'' ]
]

{ #category : #accessing }
LPTraits >> traits [
	^ traits asArray 
]

{ #category : #accessing }
LPTraits >> triplets [
	^ triplets
]

{ #category : #accessing }
LPTraits >> triplets: aTableTriplet [
	triplets := aTableTriplet
]

{ #category : #validation }
LPTraits >> validateName: tokenName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	tokenName isSymbol 
		ifTrue: [ ^ tokenName ] .
	
	(tokenName isString and: [ tokenName isNotEmpty ])
		ifTrue: [ ^ tokenName asSymbol ] .
	
	self error: 'Symbol required for identifiers'
]

{ #category : #validation }
LPTraits >> validateTagArray: tagArray [
	"Validate an array of trait tags."

	| size |
	tagArray isArray
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ].
	size := tagArray size.
	
	width < 0
		ifTrue: [ size < minNumberOfTags
				ifTrue: [ self
						error: 'Traits must have at least ' , minNumberOfTags printString , ' tags' ]
				ifFalse: [ width := size ] ]
			
		ifFalse: [ size = width
				ifFalse: [ self error: 'Traits must have ' , width printString , ' tags' ] ].
			
	^ tagArray collect: [ :tag | self validateName: tag ]
]
