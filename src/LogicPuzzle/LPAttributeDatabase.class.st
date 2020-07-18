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
	#name : #LPAttributeDatabase,
	#superclass : #Object,
	#instVars : [
		'minNumberOfTags',
		'minNumberOfAttributes',
		'attributeSet',
		'tagSet'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #creating }
LPAttributeDatabase >> addAttribute: stringOrSymbol withTags: arrayOfstringOrSymbol [
	"Create a new trait from a given symbol & array of tags."

	| attributeName tagNames thisAttribute theseTags |
	"Validate all the name tokens as String/Symbol and covert them to symbols;
	Ensure that the array of attribute tags has the required number of tags:"
	"attributeName := self validateNewAttributeName: stringOrSymbol."
	attributeName := self validateName: stringOrSymbol.
	tagNames := self validateNewTagArray: arrayOfstringOrSymbol.

	"Create the attribute, name it; we'll insert its tag array shortly:"
	thisAttribute := LPAttribute newNamed: attributeName.

	"Create an array of tags from the array of tag names, inserting the attribute:"
	theseTags := tagNames
		collect: [ :tagName | LPTag newNamed: tagName ofAttribute: thisAttribute ].

	"Now plug the tags array back into the attribute:"
	thisAttribute tags: theseTags.

	"Add the attribute to the attributes dictionary:"
	attributeSet add: attributeName -> thisAttribute.

	"Add the tags in the tag array to the tags dictionary:"
	theseTags do: [ :tag | tagSet add: tag name -> tag ].
	
	^ thisAttribute
]

{ #category : #lookup }
LPAttributeDatabase >> attributeNameOfTag: tagOrName [
	"Respond with the name of the attribute that the given tag belongs to."
	
	^ (self attributeOfTag: tagOrName) name
]

{ #category : #lookup }
LPAttributeDatabase >> attributeNames [
	^ attributeSet keys
]

{ #category : #lookup }
LPAttributeDatabase >> attributeOfTag: tagOrName [
	"Respond with the trait that the given tag belongs to."

	| tagName theTag |
	"You could just ask the tag itself for its attribute..."
	tagOrName class = LPTag
		ifTrue: [ ^ tagOrName attribute ].

	"Otherwise, all we have is a name, so we do a lookup:"
	tagName := self validateName: tagOrName.

	theTag := tagSet 
		at: tagName
		ifAbsent: [ self error: 'Unknown trait tag (' , tagName , ')' ].
		
	^ theTag attribute
]

{ #category : #accessing }
LPAttributeDatabase >> attributeSet [
	^ attributeSet
]

{ #category : #initialization }
LPAttributeDatabase >> initialize [
	"Initialize my collections and constraints."

	super initialize.
	
	"Create the expandable arrays to accumulate the set of 
	Attributes and the set of Tags as the user provides them."
	attributeSet := Dictionary new.
	tagSet := Dictionary new.

	"Set constraints for this puzzle that apply universally."
	minNumberOfAttributes := 3.
	minNumberOfTags := 2
]

{ #category : #accessing }
LPAttributeDatabase >> minNumberOfAttributes [
	^ minNumberOfAttributes
]

{ #category : #accessing }
LPAttributeDatabase >> minNumberOfTags [
	^ minNumberOfTags
]

{ #category : #normalization }
LPAttributeDatabase >> normalizeTagPair: aTagPair [
	"Validate & check the order of the trait pair elements.
	Swap the order of the elements as necessary."
	
	^ self 
		normalizeTagPairWith: aTagPair tagOne 
		with: aTagPair tagTwo
]

{ #category : #normalization }
LPAttributeDatabase >> normalizeTagPairWith: nameOne with: nameTwo [
	"Validate & check the names, form a corresponding normalized 
	trait 	pair, then return the corresponding 	normalized tag pair."

	| tagOne tagTwo tagPairs traitPair |
	"Extract the elements, validate them, and convert to symbols:"
	tagOne := self validateName: nameOne.
	tagTwo := self validateName: nameTwo.

	"Make a set of candidate tag pairs to evaluate:"
	tagPairs := Array
		with: (LPTagPair newWith: tagOne with: tagTwo)
		with: (LPTagPair newWith: tagTwo with: tagOne).

	"Loop through the candidate tag pairs, making a corresponding 
	trait pair from each; if the trait pair is in the trait pairs 
	list, return the corresponding tag pair:"
	tagPairs
		do: [ :tagPair | 
			traitPair := self traitPairFrom: tagPair.
			(tagSet anySatisfy: [ :pair | pair = traitPair ])
				ifTrue: [ ^ tagPair ] ].
			
	self
		error: 'Cannot find a trait pair for ' , tagOne , ' and ' , tagTwo
]

{ #category : #normalization }
LPAttributeDatabase >> normalizeTraitPair: aTraitPair [
	"Validate & check the order of the trait pair elements.
	Swap the order of the elements as necessary."

	^ self
		normalizeTraitPairWith: aTraitPair traitOne
		with: aTraitPair traitTwo
]

{ #category : #normalization }
LPAttributeDatabase >> normalizeTraitPairWith: traitOne with: traitTwo [
	"Validate & check the names, form a trait pair from them,
	verify the trait pair exists, and return it normalized."

	| traitPairs |
	"Make a set of candidate trait pairs to evaluate:"
	traitPairs := Array
		with: (LPAttributePair newWith: traitOne with: traitTwo)
		with: (LPAttributePair newWith: traitTwo with: traitOne).

	"Loop through the candidate trait pairs; if the trait pair 
	is in the trait pairs list, return it:"
	traitPairs
		do: [ :traitPair | 
			(tagSet anySatisfy: [ :pair | pair = traitPair ])
				ifTrue: [ ^ traitPair ] ].
	
	"If neither orientation is recognized, one/both arguments are bad:"
	self error: 'Cannot find a trait pair for ', traitOne, ' and ', traitTwo
]

{ #category : #lookup }
LPAttributeDatabase >> tagNames [
	^ tagSet keys
]

{ #category : #lookup }
LPAttributeDatabase >> tagNamesOfAttribute: attributeOrName [
	"Respond with an array of the names of the tags of the given attribute."

	^ (self tagsOfAttribute: attributeOrName) collect: [ :tag | tag name ]
]

{ #category : #deprecated }
LPAttributeDatabase >> tagPairWith: nameOne with: nameTwo [
	"Create a normalized tag pair object from the given tags."
	
	| traitNameOne traitNameTwo |
	traitNameOne := self validateNewAttributeName: nameOne.
	traitNameTwo := self validateNewAttributeName: nameTwo.
		
	^ self
		normalizeTraitPairWith: traitNameOne
		with: traitNameTwo
]

{ #category : #accessing }
LPAttributeDatabase >> tagSet [
	^ tagSet
]

{ #category : #lookup }
LPAttributeDatabase >> tagsOfAttribute: attributeOrName [
	"Respond with the array of tags of the given trait."

	| attributeName theAttribute |
	"You could just ask the attribute itself for its tags..."
	attributeOrName class = LPAttribute
		ifTrue: [ ^ attributeOrName tags ].

	"Otherwise, all we have is a name, so we do a lookup:"
	attributeName := self validateName: attributeOrName.
	
	theAttribute := attributeSet 
		at: attributeName
		ifAbsent: [ self error: 'Unknown attribute (' , attributeName , ')' ].
		
	^ theAttribute tags
]

{ #category : #deprecated }
LPAttributeDatabase >> traitPairFrom: aTagPair [
	"Promote the tags in a tag pair to traits & return the trait pair."
	
	| tagOne tagTwo traitOne traitTwo |
	"Extract the elements, validate them, and convert to symbols:"
	tagOne := self validateName: aTagPair tagOne.
	tagTwo := self validateName: aTagPair tagTwo.
	
	"Promote the tags to their respective traits:"
	traitOne := self attributeOfTag: tagOne.
	traitTwo := self attributeOfTag: tagTwo.
	
	"Form a trait pair and normalize it:"
	^ self normalizeTraitPairWith: traitOne with: traitTwo
	
]

{ #category : #deprecated }
LPAttributeDatabase >> traitPairWith: nameOne with: nameTwo [
	"Create a normalized trait pair object.  Interpret the arguments 
	as either trait objects or trait names (string or symbol)."
	
	| traitNameOne traitNameTwo |
	traitNameOne := self validateNewAttributeName: nameOne.
	traitNameTwo := self validateNewAttributeName: nameTwo.
		
	^ self
		normalizeTraitPairWith: traitNameOne
		with: traitNameTwo
]

{ #category : #validation }
LPAttributeDatabase >> validateName: tokenName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	tokenName isSymbol 
		ifTrue: [ ^ tokenName ] .
	
	(tokenName isString and: [ tokenName isNotEmpty ])
		ifTrue: [ ^ tokenName asSymbol ] .
	
	self error: 'Symbol required for identifiers'
]

{ #category : #validation }
LPAttributeDatabase >> validateNewAttributeName: name [
	"Validate the attribute name, convert it to a symbol, verify that it's unique."

	| attributeName |
	attributeName := self validateName: name.

	"Verify that it's not the name of an attribute we already know about."
	attributeSet 
		do: [ :attribute | 
			attributeName = attribute name
				ifTrue: [ self error: 'Duplicate attribute name (' , attributeName , ')' ] ].
			
	^ attributeName
]

{ #category : #validation }
LPAttributeDatabase >> validateNewTagArray: tagArray [
	"Validate a collection of attribute tags."

	| size tagsPerAttribute |
	tagArray isArray
		ifFalse: [ self error: 'Attribute tags must be an array of symbols' ].
	size := tagArray size.
	
	tagsPerAttribute := attributeSet isEmpty
		ifTrue: [ size ]
		ifFalse: [ attributeSet anyOne tags size ].
		
	size = tagsPerAttribute
		ifFalse: [ self
				error: 'Attributes must have ' , tagsPerAttribute printString , ' tags' ].
			
	size < minNumberOfTags
		ifTrue: [ self
				error:
					'Attributes must have at least ' , minNumberOfTags printString
						, ' tags' ].
					
	^ tagArray collect: [ :tag | self validateNewTagName: tag ]
]

{ #category : #validation }
LPAttributeDatabase >> validateNewTagName: name [
	"Validate the tag name, convert it to a symbol, verify that it's unique."

	| tagName |
	tagName := self validateName: name.

	"Verify that it's not the name of a tag we already know about."
	tagSet
		do: [ :tag | 
			tagName = tag name
				ifTrue: [ self error: 'Duplicate tag name (' , tagName , ')' ] ].
	^ tagName
]
