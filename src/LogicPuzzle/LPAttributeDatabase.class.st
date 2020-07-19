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
		'minNumberOfAttributes',
		'attributeDictionary',
		'relationshipDictionary',
		'relationTrioDictionary',
		'minNumberOfProperties',
		'propertyDictionary'
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
	tagNames := self validateNewPropertySet: arrayOfstringOrSymbol.

	"Create the attribute, name it; we'll insert its tag array shortly:"
	thisAttribute := LPAttribute newNamed: attributeName.

	"Create an array of tags from the array of tag names, inserting the attribute:"
	theseTags := tagNames
		collect: [ :tagName | LPProperty newNamed: tagName ofAttribute: thisAttribute ].

	"Now plug the tags array back into the attribute:"
	thisAttribute propertySet: theseTags.

	"Add the attribute to the attributes dictionary:"
	attributeDictionary add: attributeName -> thisAttribute.

	"Add the tags in the tag array to the tags dictionary:"
	theseTags do: [ :tag | propertyDictionary add: tag name -> tag ].
	
	^ thisAttribute
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationTrio: relationTrio [
	"Analyze a relationship trio, making inferences."

	relationTrio
		isModified: false;
		inferRelations.
		
	^ relationTrio
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationship: relationship [
	"Analyze a relationship, making deductions for matches & exclusions."

	relationship
		isModified: false;
		deduceMatchedRelationships;
		deduceExcludedRelationships.
		
	^ relationship 
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationships [
	"Walk the set of relationships, analyzing, until no modifications are made."

	| anyIsModified |
	anyIsModified := true.

	"Loop through all relationships until no modifications detected:"
	[ anyIsModified ]
		whileTrue: [ anyIsModified := false.
			relationshipDictionary 
				do: [ :relationship | 
					relationship isModified: false.
					self analyzeRelationship: relationship ].
			relationTrioDictionary 
				do: [ :relationTrio |
					self analyzeRelationTrio: relationTrio ].
			relationshipDictionary 
				do: [ :relationship | 
					anyIsModified := anyIsModified or: [ relationship isModified ] ]
			] 
]

{ #category : #accessing }
LPAttributeDatabase >> attributeDictionary [
	^ attributeDictionary
]

{ #category : #lookup }
LPAttributeDatabase >> attributeNameOfTag: tagOrName [
	"Respond with the name of the attribute that the given tag belongs to."
	
	^ (self attributeOfTag: tagOrName) name
]

{ #category : #lookup }
LPAttributeDatabase >> attributeNames [
	^ attributeDictionary keys
]

{ #category : #lookup }
LPAttributeDatabase >> attributeOfTag: tagOrName [
	"Respond with the trait that the given tag belongs to."

	| tagName theTag |
	"You could just ask the tag itself for its attribute..."
	tagOrName class = LPProperty
		ifTrue: [ ^ tagOrName attribute ].

	"Otherwise, all we have is a name, so we do a lookup:"
	tagName := self validateName: tagOrName.

	theTag := propertyDictionary 
		at: tagName
		ifAbsent: [ self error: 'Unknown trait tag (' , tagName , ')' ].
		
	^ theTag attribute
]

{ #category : #creating }
LPAttributeDatabase >> createRelationTrios [
	"Form combinations of attributes taken 3 at a time."

	| attributeArray relationTrioCollection |
	"We need a new dictionary and we need the attribute dictionary as an array."
	relationTrioCollection := OrderedCollection new.
	attributeArray := attributeDictionary asArray.

	"Step through C(n,3) = every combination of attributes taken 3 at a time:"
	1 to: attributeArray size - 2 do: [ :outerIndex | 
		| attributeOne |
		attributeOne := attributeArray at: outerIndex.

		"Step through all but one of the remaining attributes to pair with this one:"
		outerIndex + 1 to: attributeArray size - 1 do: [ :middleIndex | 
			| attributeTwo |
			attributeTwo := attributeArray at: middleIndex.

			"Step through the remaining attributes in the array to make a trio:"
			middleIndex + 1 to: attributeArray size do: [ :innerIndex | 
				| attributeThree attributeTrio relationTrio |
				attributeThree := attributeArray at: innerIndex.

				"Create a trio combo, then cycle through it to make RelationTrios:"
				attributeTrio := {attributeOne. attributeTwo. attributeThree}.

				"Cycle through the trio, making each attribute the common attribute:"
				attributeTrio
					do: [ :commonAttribute | 
						relationTrio := LPRelationshipTrio
							newFrom: attributeTrio
							for: commonAttribute
							using: relationshipDictionary ].

				"Finally, add the new relationship to our collection:"
				relationTrioCollection add: relationTrio ] ] ].
	
	^ relationTrioCollection
]

{ #category : #creating }
LPAttributeDatabase >> createRelationshipPairs [
	"Walk the attributes set to form every pair-wise permutation."
	
	| attributeArray relationships |
	"We need a new dictionary and we need the attribute dictionary as an array."
	relationships := Dictionary new.
	attributeArray := attributeDictionary asArray.

	"Step through C(n,2) = every combination of attributes taken 2 at a time:"
	1 to: attributeArray size - 1 do: [ :outerIndex | 
		| attributeOne pairOne |
		attributeOne := attributeArray at: outerIndex.

		"Step through the remaining attributes in the array to pair with this one:"
		outerIndex + 1 to: attributeArray size do: [ :innerIndex | 
			| attributeTwo pairTwo relationship |
			attributeTwo := attributeArray at: innerIndex.

			"Form a pair of keys from the attribute pair for accessing the new 
			relationship. Why two keys? To eliminate ordering issues."
			pairOne := LPAttributePair newWith: attributeOne with: attributeTwo.
			pairTwo := LPAttributePair newWith: attributeTwo with: attributeOne.
			
			"Make the relationship between the attributes:"
			relationship := LPAttributeRelationship newWith: pairOne.

			"Finally, add the new relationship to our collection:"
			relationships add: pairOne dictionaryKey -> relationship.
			relationships add: pairTwo dictionaryKey -> relationship ] ].

	^ relationships
]

{ #category : #creating }
LPAttributeDatabase >> createRelationships [
	"Crunch the set of attributes to create the relationships."

	"Create all the pair-wise permutations of attributes, making 
	a dictionary that points to unique pair-wise combinations:"
	relationshipDictionary := self createRelationshipPairs.

	"Create all the combinations of attributes taken 3 at time:"
	"relationTrioDictionary := self createRelationTrios"

	"Do something..."
]

{ #category : #initialization }
LPAttributeDatabase >> initialize [
	"Initialize my collections and constraints."

	super initialize.
	
	"Create the expandable arrays to accumulate the set of 
	Attributes and the set of Tags as the user provides them."
	attributeDictionary := Dictionary new.
	propertyDictionary := Dictionary new.

	"Set constraints for this puzzle that apply universally."
	minNumberOfAttributes := 3.
	minNumberOfProperties := 2
]

{ #category : #accessing }
LPAttributeDatabase >> minNumberOfAttributes [
	^ minNumberOfAttributes
]

{ #category : #accessing }
LPAttributeDatabase >> minNumberOfProperties [
	^ minNumberOfProperties
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
			(propertyDictionary anySatisfy: [ :pair | pair = traitPair ])
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
			(propertyDictionary anySatisfy: [ :pair | pair = traitPair ])
				ifTrue: [ ^ traitPair ] ].
	
	"If neither orientation is recognized, one/both arguments are bad:"
	self error: 'Cannot find a trait pair for ', traitOne, ' and ', traitTwo
]

{ #category : #accessing }
LPAttributeDatabase >> propertyDictionary [
	^ propertyDictionary
]

{ #category : #accessing }
LPAttributeDatabase >> relationTrioDictionary [
	^ relationTrioDictionary
]

{ #category : #accessing }
LPAttributeDatabase >> relationshipDictionary [
	^ relationshipDictionary
]

{ #category : #lookup }
LPAttributeDatabase >> tagNames [
	^ propertyDictionary keys
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

{ #category : #lookup }
LPAttributeDatabase >> tagsOfAttribute: attributeOrName [
	"Respond with the array of tags of the given trait."

	| attributeName theAttribute |
	"You could just ask the attribute itself for its tags..."
	attributeOrName class = LPAttribute
		ifTrue: [ ^ attributeOrName propertySet ].

	"Otherwise, all we have is a name, so we do a lookup:"
	attributeName := self validateName: attributeOrName.
	
	theAttribute := attributeDictionary 
		at: attributeName
		ifAbsent: [ self error: 'Unknown attribute (' , attributeName , ')' ].
		
	^ theAttribute propertySet
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
LPAttributeDatabase >> validateExistingAttributeName: nameOrSymbol [
	"Validate the Attribute name, convert it to a symbol, verify we know it."

	| attributeName |
	attributeName := self validateName: nameOrSymbol.

	"Verify that it is the name of an Attribute we already know."
	(attributeDictionary
		anySatisfy: [ :attribute | attribute name = attributeName ])
		ifTrue: [ ^ attributeName ].
		
	self error: 'Unknown attribute name (' , attributeName , ')'
]

{ #category : #validation }
LPAttributeDatabase >> validateExistingPropertyName: nameOrSymbol [
	"Validate the Property name, convert it to a symbol, verify we know it."

	| propertyName |
	propertyName := self validateName: nameOrSymbol.

	"Verify that it is the name of a Property we already know."
	(propertyDictionary
		anySatisfy: [ :property | property name = propertyName ])
		ifTrue: [ ^ propertyName ].
		
	self error: 'Unknown property name (' , propertyName , ')'
]

{ #category : #validation }
LPAttributeDatabase >> validateName: tokenName [ 
	"Validate the parameter as being a symbol or a string."
	
	tokenName isSymbol 
		ifTrue: [ ^ tokenName ] .
	
	"If a string, render it as a valid symbol."
	(tokenName isString and: [ tokenName isNotEmpty ])
		ifTrue: [ ^ tokenName asSymbol ] .
	
	self error: 'Symbol required for identifiers'
]

{ #category : #validation }
LPAttributeDatabase >> validateNewAttributeName: nameOrSymbol [
	"Validate the Attribute name, convert it to a symbol, verify it's unique."

	| attributeName |
	attributeName := self validateName: nameOrSymbol.

	"Verify that it's not the name of an Attribute we already know."
	(attributeDictionary
		anySatisfy: [ :attribute | attribute name = attributeName ])
		ifFalse: [ ^ attributeName ].
			
	self error: 'Duplicate attribute name (' , attributeName , ')'
]

{ #category : #validation }
LPAttributeDatabase >> validateNewPropertyName: nameOrSymbol [
	"Validate the Property name, convert it to a symbol, verify it's unique."

	| propertyName |
	propertyName := self validateName: nameOrSymbol.

	"Verify that it's not the name of a Property we already know."
	(propertyDictionary
		anySatisfy: [ :property | property name = propertyName ])
		ifFalse: [ ^ propertyName ].
		
	self error: 'Duplicate property name (' , propertyName , ')'
]

{ #category : #validation }
LPAttributeDatabase >> validateNewPropertySet: propertyCollection [
	"Validate a collection of Attribute Properties."

	| propertySet size propertyCount |
	propertySet := propertyCollection.
	
	propertyCollection isArray
		ifTrue: [ propertySet := propertyCollection asSet ]
	
	propertySet class = Set
		ifFalse: [ self error: 'Attribute properties must be a set of symbols' ].
	
	size := propertySet size.
	
	propertyCount := attributeDictionary isEmpty
		ifTrue: [ size ]
		ifFalse: [ attributeDictionary anyOne propertySet size ].
		
	size = propertyCount
		ifFalse: [ self
				error: 'Attributes must have ' , propertyCount printString , ' properties' ].
			
	size < minNumberOfProperties
		ifTrue: [ self
				error:
					'Attributes must have at least ' , minNumberOfProperties printString
						, ' properties' ].
					
	^ propertySet collect: [ :property | self validateNewPropertyName: property ]
]
