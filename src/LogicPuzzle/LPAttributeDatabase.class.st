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
		'minNumberOfProperties',
		'propertyDictionary',
		'relationshipTrioCollection'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #creating }
LPAttributeDatabase >> addAttribute: stringOrSymbol withProperties: arrayOrSetOfstringOrSymbol [
	"Create a new Attribute from a given symbol & set of Property names."

	| attributeName propertyNames attribute propertySet |
	"Validate all the name tokens as String/Symbol and covert them to symbols;
	Ensure that the array of Attribute Properties has the required number of 
	Properties, and if provided as a collection or array, convert to a Set:"
	attributeName := self validateName: stringOrSymbol.
	propertyNames := self validateNewPropertySet: arrayOrSetOfstringOrSymbol.

	"Create the Attribute, name it; we'll insert its PropertySet shortly:"
	attribute := LPAttribute newNamed: attributeName propertySet: nil.

	"Create a PropertySet from the set of Property names, 
	inserting the owning Attribute into each:"
	propertySet := propertyNames
		collect: [ :propertyName | 
			LPProperty newNamed: propertyName ofAttribute: attribute ].

	"Now plug the actual PropertySet into the Attribute:"
	attribute propertySet: propertySet.

	"Add the Attribute to the Attributes dictionary:"
	attributeDictionary add: attribute name -> attribute.

	"Add the Properties in the PropertySet to the Properties dictionary:"
	propertySet do: [ :property | 
		propertyDictionary add: property name -> property ].
	
	^ attribute
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationTrio: relationshipTrio [
	"Analyze a relationship trio, making inferences."

	relationshipTrio
		isModified: false;
		inferRelationships.
		
	^ relationshipTrio
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
				
			relationshipTrioCollection 
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

{ #category : #lookup }
LPAttributeDatabase >> attributeRelationshipKeyFor: attributeOne with: attributeTwo [
	"Combine Attribute one and Attribute two to make a single symbol."
	
	^ attributeOne name , attributeTwo name
]

{ #category : #creating }
LPAttributeDatabase >> createAttributeRelationships [
	"Walk the Attributes set to form every pair-wise permutation."
	
	| attributeArray relationships |
	"We need a new dictionary and we need the Attribute dictionary as an array."
	relationships := Dictionary new.
	attributeArray := attributeDictionary asArray.

	"Step through C(n,2) = every combination of attributes taken 2 at a time:"
	1 to: attributeArray size - 1 do: [ :outerIndex | 
		| attributeOne keyOne |
		attributeOne := attributeArray at: outerIndex.

		"Step through the remaining attributes to pair with this one:"
		outerIndex + 1 to: attributeArray size do: [ :innerIndex | 
			| attributeTwo keyTwo relationship |
			attributeTwo := attributeArray at: innerIndex.

			"Form a pair of keys from the attribute pair for accessing the new 
			relationship. Why two keys? To eliminate ordering issues."
			keyOne := self 
				attributeRelationshipKeyFor: attributeOne 
				with: attributeTwo.
			keyTwo := self 
				attributeRelationshipKeyFor: attributeTwo 
				with: attributeOne.
			
			"Make the relationship between the attributes:"
			relationship := LPAttributeRelationship 
				newWith: attributeOne 
				with: attributeTwo.

			"Finally, add the new relationship to our collection:"
			relationships add: keyOne dictionaryKey -> relationship.
			relationships add: keyTwo dictionaryKey -> relationship ] ].

	^ relationships
]

{ #category : #creating }
LPAttributeDatabase >> createRelationshipTrios [
	"Form combinations of Attributes taken 3 at a time."

	| attributeArray relationTrioCollection |
	"We need a new dictionary and we need the Attribute dictionary as an array."
	relationTrioCollection := OrderedCollection new.
	attributeArray := attributeDictionary asArray.

	"Step through C(n,3) = every combination of Attributes taken 3 at a time:"
	1 to: attributeArray size - 2 do: [ :outerIndex | 
		| attributeOne |
		attributeOne := attributeArray at: outerIndex.

		"Step through all but one of the remaining Attributes to pair with this one:"
		outerIndex + 1 to: attributeArray size - 1 do: [ :middleIndex | 
			| attributeTwo |
			attributeTwo := attributeArray at: middleIndex.

			"Step through the remaining Attributes in the array to make a trio:"
			middleIndex + 1 to: attributeArray size do: [ :innerIndex | 
				| attributeThree attributeTrio relationshipTrio |
				attributeThree := attributeArray at: innerIndex.

				"Create a trio combo, then cycle through it to make RelationshipTrios:"
				attributeTrio := {attributeOne. attributeTwo. attributeThree}.

				"Cycle through the trio, making each Attribute the common Attribute:"
				attributeTrio
					do: [ :commonAttribute | 
						relationshipTrio := LPRelationshipTrio
							newFrom: attributeTrio
							for: commonAttribute
							using: relationshipDictionary ].

				"Finally, add the new relationship to our collection:"
				relationTrioCollection add: relationshipTrio ] ] ].
	
	^ relationTrioCollection
]

{ #category : #creating }
LPAttributeDatabase >> createRelationships [
	"Crunch the set of attributes to create the relationships."

	"Create all the pair-wise permutations of attributes, making 
	a dictionary that points to unique pair-wise combinations:"
	relationshipDictionary := self createAttributeRelationships.

	"Create all the combinations of attributes taken 3 at time:"
	relationshipTrioCollection := self createRelationshipTrios

	"Now do something useful..."
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

{ #category : #accessing }
LPAttributeDatabase >> propertyDictionary [
	^ propertyDictionary
]

{ #category : #accessing }
LPAttributeDatabase >> relationshipDictionary [
	^ relationshipDictionary
]

{ #category : #accessing }
LPAttributeDatabase >> relationshipTrioCollection [
	^ relationshipTrioCollection
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
	
	propertyCollection isCollection 
		ifTrue: [ propertySet := propertyCollection asSet ]
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
