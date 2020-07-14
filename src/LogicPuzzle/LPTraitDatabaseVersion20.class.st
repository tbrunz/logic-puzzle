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
	#name : #LPTraitDatabaseVersion20,
	#superclass : #Object,
	#instVars : [
		'minNumberOfTraits',
		'minNumberOfTags',
		'traitsOfTags',
		'tagsOfTraits',
		'numberOfTags',
		'allTraits',
		'allTraitPairs'
	],
	#category : #'LogicPuzzle-Version20'
}

{ #category : #creating }
LPTraitDatabaseVersion20 >> addTrait: stringOrSymbol withTags: stringOrSymbolArray [
	"Create a new trait from a given symbol & array of tags."

	| traitName thisTrait traitTagNames traitTags |
	"Validate all the name tokens as String/Symbol and covert them to symbols;
	Ensure that the array of trait tags has the required number of tags:"
	traitName := self validateName: stringOrSymbol.
	traitTagNames := self validateTagArray: stringOrSymbolArray.

	"Verify that none of the tags in the array duplicate any that we already know:"
	self tagNames
		do: [ :tagName | 
			| tagTraitName |
			tagTraitName := self traitOfTag: tagName.
			(traitTagNames
				anySatisfy: [ :each | each = tagName and: [ traitName ~= tagTraitName ] ])
				ifTrue: [ self
						error:
							'Duplicate tags not allowed (' , tagName , ' belongs to trait '
								, tagTraitName , ')' ] ].

	"We want the array of tags that the trait holds to be tag objects, not just their names:"
	traitTags := traitTagNames
		collect: [ :tagName | LPTag newNamed: tagName ofTrait: traitName ].

	"Create the trait, name it, and insert its tag array:"
	thisTrait := LPAttribute newNamed: traitName withTags: traitTags.

	"Add the tag array to the tags dictionary, keyed by the name of their trait; 
	Reusing an existing trait name is okay -- it just will overwrite the previous:"
	tagsOfTraits add: traitName -> traitTags.

	"For each tag, create an entry in the traits dictionary, pointing to the trait:"
	traitTagNames do: [ :tagName | traitsOfTags add: tagName -> thisTrait ].
	
	^ allTraits add: thisTrait  "Yes, return 'thisTrait', not the collection..."
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> allTags [
	^ tagsOfTraits asArray 
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> allTraitPairs [
	^ allTraitPairs
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> allTraits [
	^ allTraits
]

{ #category : #initialization }
LPTraitDatabaseVersion20 >> initialize [
	"I need a pair of complementary dictionaries, so that 
	I can refer to my data symbolically (as my user does)."

	super initialize.
	
	"Create the expandable arrays to hold the set of traits 
	and the set of trait pairs.  We need the first to create 
	the second, and the second to normalize trait pair objects.  
	Why do trait pairs need to be normalized?  Logically, the 
	order of traits in a trait pair is irrelevlant; only the 
	combination of the two traits matters.  However, the 
	implementation cares: one trait has to be stored ahead of 
	the other, one of them addresses table rows, etc."
	allTraits := OrderedCollection new.
	allTraitPairs := OrderedCollection new.

	"Create the dictionaries for the traits and tags of this puzzle.
	Their elements will be provided later by the user."
	traitsOfTags := Dictionary new.
	tagsOfTraits := Dictionary new.

	"I don't know yet what the number of tags per trait will be.
	As traits and tags are provided to me, I need to compare the
	size of their tag array to something, so I'll start with a 
	value that is obviously too low.  The first set of tags will 
	replace my value with its size."
	numberOfTags := -1.

	"Set constraints for this puzzle that apply universally."
	minNumberOfTraits := 3.
	minNumberOfTags := 2
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> minNumberOfTags [
	^ minNumberOfTags
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> minNumberOfTags: anInteger [
	minNumberOfTags := anInteger
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> minNumberOfTraits [
	^ minNumberOfTraits
]

{ #category : #accessing }
LPTraitDatabaseVersion20 >> minNumberOfTraits: anInteger [
	minNumberOfTraits := anInteger
]

{ #category : #normalization }
LPTraitDatabaseVersion20 >> normalizeTagPair: aTagPair [
	"Validate & check the order of the trait pair elements.
	Swap the order of the elements as necessary."
	
	^ self 
		normalizeTagPairWith: aTagPair tagOne 
		with: aTagPair tagTwo
]

{ #category : #normalization }
LPTraitDatabaseVersion20 >> normalizeTagPairWith: nameOne with: nameTwo [
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
			(allTraitPairs anySatisfy: [ :pair | pair = traitPair ])
				ifTrue: [ ^ tagPair ] ].
			
	self
		error: 'Cannot find a trait pair for ' , tagOne , ' and ' , tagTwo
]

{ #category : #normalization }
LPTraitDatabaseVersion20 >> normalizeTraitPair: aTraitPair [
	"Validate & check the order of the trait pair elements.
	Swap the order of the elements as necessary."

	^ self
		normalizeTraitPairWith: aTraitPair traitOne
		with: aTraitPair traitTwo
]

{ #category : #normalization }
LPTraitDatabaseVersion20 >> normalizeTraitPairWith: traitOne with: traitTwo [
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
			(allTraitPairs anySatisfy: [ :pair | pair = traitPair ])
				ifTrue: [ ^ traitPair ] ].
	
	"If neither orientation is recognized, one/both arguments are bad:"
	self error: 'Cannot find a trait pair for ', traitOne, ' and ', traitTwo
]

{ #category : #lookup }
LPTraitDatabaseVersion20 >> tagNames [
	"The 'traits' collection is a dictionary; 
	Its values are trait objects; therefore, 
	its keys are the tag names.  Return them."
	^ traitsOfTags keys
]

{ #category : #lookup }
LPTraitDatabaseVersion20 >> tagNamesOfTrait: aTraitOrTraitName [
	"Respond with an array of the names of the tags of the given trait."

	^ (self tagsOfTrait: aTraitOrTraitName) collect: [ :tag | tag name ]
]

{ #category : #creating }
LPTraitDatabaseVersion20 >> tagPairWith: nameOne with: nameTwo [
	"Create a normalized tag pair object from the given tags."
	
	| traitNameOne traitNameTwo |
	traitNameOne := self validateTraitName: nameOne.
	traitNameTwo := self validateTraitName: nameTwo.
		
	^ self
		normalizeTraitPairWith: traitNameOne
		with: traitNameTwo
]

{ #category : #lookup }
LPTraitDatabaseVersion20 >> tagsOfTrait: aTraitOrTraitName [
	"Respond with the array of tags of the given trait."

	| traitName |
	"You could just ask the trait itself for its tags..."
	aTraitOrTraitName class = LPAttribute
		ifTrue: [ ^ aTraitOrTraitName tags ].

	"Otherwise, all we have is a name, so we do a lookup:"
	traitName := self validateName: aTraitOrTraitName.
	
	^ tagsOfTraits
		at: traitName
		ifAbsent: [ self error: 'Unknown trait (' , traitName , ')' ]
]

{ #category : #lookup }
LPTraitDatabaseVersion20 >> traitNameOfTag: aTagOrTagName [
	"Respond with the name of the trait that the given tag belongs to."
	
	^ (self traitOfTag: aTagOrTagName) name
]

{ #category : #lookup }
LPTraitDatabaseVersion20 >> traitNames [
	"The 'tags' collection is a dictionary; 
	Its values are tag objects; therefore, 
	its keys are the trait names.  Return them."
	^ tagsOfTraits keys
]

{ #category : #lookup }
LPTraitDatabaseVersion20 >> traitOfTag: aTagOrTagName [
	"Respond with the trait that the given tag belongs to."

	| tagName |
	"A tag object does *not* store its trait object, only its name.
	Therefore, we will have to do a lookup whether we're given a 
	tag object or a tag name.  Tag objects store both names."
	tagName := aTagOrTagName class = LPTag
		ifTrue: [ aTagOrTagName name ]
		ifFalse: [ self validateName: aTagOrTagName ].

	^ traitsOfTags
		at: tagName
		ifAbsent: [ self error: 'Unknown trait tag (' , tagName , ')' ]
]

{ #category : #creating }
LPTraitDatabaseVersion20 >> traitPairFrom: aTagPair [
	"Promote the tags in a tag pair to traits & return the trait pair."
	
	| tagOne tagTwo traitOne traitTwo |
	"Extract the elements, validate them, and convert to symbols:"
	tagOne := self validateName: aTagPair tagOne.
	tagTwo := self validateName: aTagPair tagTwo.
	
	"Promote the tags to their respective traits:"
	traitOne := self traitOfTag: tagOne.
	traitTwo := self traitOfTag: tagTwo.
	
	"Form a trait pair and normalize it:"
	^ self normalizeTraitPairWith: traitOne with: traitTwo
	
]

{ #category : #creating }
LPTraitDatabaseVersion20 >> traitPairWith: nameOne with: nameTwo [
	"Create a normalized trait pair object.  Interpret the arguments 
	as either trait objects or trait names (string or symbol)."
	
	| traitNameOne traitNameTwo |
	traitNameOne := self validateTraitName: nameOne.
	traitNameTwo := self validateTraitName: nameTwo.
		
	^ self
		normalizeTraitPairWith: traitNameOne
		with: traitNameTwo
]

{ #category : #validation }
LPTraitDatabaseVersion20 >> validateName: tokenName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	tokenName isSymbol 
		ifTrue: [ ^ tokenName ] .
	
	(tokenName isString and: [ tokenName isNotEmpty ])
		ifTrue: [ ^ tokenName asSymbol ] .
	
	self error: 'Symbol required for identifiers'
]

{ #category : #validation }
LPTraitDatabaseVersion20 >> validateTagArray: tagArray [
	"Validate an array of trait tags."

	| size |
	tagArray isArray
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ].
	size := tagArray size.
	
	numberOfTags < 0
		ifTrue: [ size < minNumberOfTags
				ifTrue: [ self
						error: 'Traits must have at least ' , minNumberOfTags printString , ' tags' ]
				ifFalse: [ numberOfTags := size ] ]
			
		ifFalse: [ size = numberOfTags
				ifFalse: [ self error: 'Traits must have ' , numberOfTags printString , ' tags' ] ].
			
	^ tagArray collect: [ :tag | self validateName: tag ]
]

{ #category : #validation }
LPTraitDatabaseVersion20 >> validateTagName: name [
	"Validate the argument as being a symbol or a string.
	If a string, render it as a valid symbol."

	| tagName |
	tagName := self validateName: name.
	
	"Verify that it's the name of a tag we know about."
	(traitsOfTags keys includes: tagName)
		ifTrue: [ ^ tagName ].
	
	self error: 'Unknown tag name (' , tagName , ')'
]

{ #category : #validation }
LPTraitDatabaseVersion20 >> validateTraitName: name [
	"Validate the argument as being a symbol or a string.
	If a string, render it as a valid symbol."

	| traitName |
	traitName := self validateName: name.
	
	"Verify that it's the name of a trait we know about."
	(tagsOfTraits keys includes: traitName)
		ifTrue: [ ^ traitName ].
	
	self error: 'Unknown trait name (' , traitName , ')'
]
