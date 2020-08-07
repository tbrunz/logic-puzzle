"
I represent a database of Attributes and Properties that describe 
the subjects of a logic puzzle. 

The Attributes I keep track of have a name, 
e.g., #Nationality, #Color, #Sequence. 

So do the Properties I keep track of, 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

Given an Attribute or Attribute name, I can return the set of 
its Properties.  Given a Property or Property name, I can return 
the Attribute that it belongs to.

As the above implies, every Property must be distinct, independent 
of Attribute.

Every Attribute must have the same number of Properties.

A logic puzzle contains one instance of me, and uses me to relate 
Properties and Attributes.
"
Class {
	#name : #LPAttributeDatabase,
	#superclass : #Object,
	#instVars : [
		'minNumberOfAttributes',
		'primaryAttribute',
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

	| attribute |
	"Validate all the name tokens as String/Symbol and covert them to symbols;
	Ensure that the array of Attribute Properties has the required number of 
	Properties, and if provided as a collection or array, convert it to a Set.
	Then create the Attribute from the validate name set:"
	attribute := LPAttribute 
		newNamed: (self validateName: stringOrSymbol)
		withPropertyNames: (self validateNewPropertySet: arrayOrSetOfstringOrSymbol).

	"Add the Attribute to the Attributes dictionary:"
	attributeDictionary add: attribute name -> attribute.

	"Add the Properties in the PropertySet to the Properties dictionary:"
	attribute propertySet do: [ :property | 
		propertyDictionary add: property name -> property ].
	
	^ attribute
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationTrio: relationshipTrio [
	"Analyze a relationship trio, making inferences."

	relationshipTrio inferRelationships.

	^ relationshipTrio
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationship: relationship [
	"Analyze a relationship, deducing matches & exclusions."

	relationship
		deduceMatchedRelationships;
		deduceExcludedRelationships.
		
	^ relationship 
]

{ #category : #inferencing }
LPAttributeDatabase >> analyzeRelationships [
	"Walk the set of relationships, analyzing, until no modifications 
	have been made to any of the Attribute Relationships."

	| anyIsModified |
	anyIsModified := true.

	"Loop through all relationships until no modifications detected:"
	[ anyIsModified ]
		whileTrue: [ 			
			relationshipDictionary 
				do: [ :relationship | 
					relationship isModified: false.
					self analyzeRelationship: relationship ].
			
			relationshipTrioCollection 
				do: [ :relationshipTrio |
					self analyzeRelationTrio: relationshipTrio ].
			
			anyIsModified := false.
			relationshipDictionary 
				do: [ :relationship | 
					relationship checkConsistency.
					
					relationship isInconsistent ifTrue: [ ^ false ].
					anyIsModified := anyIsModified or: [ relationship isModified ] ]
			].
		
		^ true
]

{ #category : #accessing }
LPAttributeDatabase >> attributeDictionary [
	^ attributeDictionary
]

{ #category : #lookup }
LPAttributeDatabase >> attributeFrom: attributeOrProperty [
	"Return an Attribute after determining what the argument represents."

	| symbol |
	attributeOrProperty class = LPAttribute
		ifTrue: [ ^ attributeOrProperty ].
		
	attributeOrProperty class = LPProperty
		ifTrue: [ ^ attributeOrProperty attribute ].
		
	symbol := self validateName: attributeOrProperty.
	
	^ attributeDictionary
		at: symbol
		ifAbsent: [ propertyDictionary
				at: symbol
				ifAbsent: [ self error: 'Unknown name (' , symbol , ')' ] attribute ]
]

{ #category : #lookup }
LPAttributeDatabase >> attributeNameOfProperty: propertyOrName [
	"Respond with the name of the Attribute the Property/name belongs to."
	
	^ (self attributeOfProperty: propertyOrName) name
]

{ #category : #lookup }
LPAttributeDatabase >> attributeNames [
	^ attributeDictionary keys
]

{ #category : #lookup }
LPAttributeDatabase >> attributeOfProperty: propertyOrName [
	"Respond with the Attribute that the given Property belongs to."

	"You could just ask the Property itself for its Attribute..."
	propertyOrName class = LPProperty
		ifTrue: [ ^ propertyOrName attribute ].

	"Otherwise, all we have is a name, so we do a lookup:"
	^ (self validateExistingPropertyName: propertyOrName) attribute
]

{ #category : #lookup }
LPAttributeDatabase >> attributeRelationshipFor: attributeOrPropertyOne with: attributeOrPropertyTwo [
	"Return the Attribute Relationship of the validated/converted arguments."

	| attributeOne attributeTwo |
	attributeOne := self attributeFrom: attributeOrPropertyOne.
	attributeTwo := self attributeFrom: attributeOrPropertyTwo.

	^ relationshipDictionary
		at: (self attributeRelationshipKeyFor: attributeOne with: attributeTwo)
]

{ #category : #lookup }
LPAttributeDatabase >> attributeRelationshipKeyFor: attributeOne with: attributeTwo [
	"Combine Attribute one and Attribute two to make a single symbol."
	
	attributeOne = attributeTwo 
		ifFalse: [ ^ attributeOne name , attributeTwo name ].
		
	self error: 'Attempt to make relationship key with duplicate attributes'
]

{ #category : #lookup }
LPAttributeDatabase >> attributeRelationships [
	"Create a set of all AttributeRelationships."
	
	^ relationshipDictionary asSet
]

{ #category : #creating }
LPAttributeDatabase >> createAttributeRelationships [
	"Walk the Attributes set to form every pair-wise combination."
	
	| attributeArray relationships |
	"We need the Attribute dictionary as an array for indexing."
	attributeArray := attributeDictionary asArray.
	relationships := Dictionary new.

	"Step through C(n,2) = every combination of Attributes taken 2 at a time:"
	1 to: attributeArray size - 1 do: [ :outerIndex | 
		| attributeOne keyOne |
		attributeOne := attributeArray at: outerIndex.

		"Step through the remaining Attributes to pair up with this one:"
		outerIndex + 1 to: attributeArray size do: [ :innerIndex | 
			| attributeTwo keyTwo relationship |
			attributeTwo := attributeArray at: innerIndex.

			"Form a pair of keys from the Attribute pair for accessing the new 
			relationship. Why two keys? To eliminate ordering issues."
			keyOne := self 
				attributeRelationshipKeyFor: attributeOne 
				with: attributeTwo.
			keyTwo := self 
				attributeRelationshipKeyFor: attributeTwo 
				with: attributeOne.
			
			"Create a new relationship between the Attributes:"
			relationship := LPAttributeRelationship 
				newWith: attributeOne 
				with: attributeTwo.

			"Finally, add the new relationship to our collection.
			We add the same relationship, keyed both ways:"
			relationships add: keyOne -> relationship.
			relationships add: keyTwo -> relationship ] ].

	^ relationships
]

{ #category : #creating }
LPAttributeDatabase >> createRelationshipTrios [
	"Form combinations of Attributes taken 3 at a time."

	| attributeArray relationTrioCollection attributeTrio |
	"We need the Attribute dictionary as an array, for indexing."
	attributeArray := attributeDictionary asArray.
	relationTrioCollection := OrderedCollection new.

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
				| attributeThree |
				attributeThree := attributeArray at: innerIndex.

				"Create a trio combo, then cycle through it to make RelationshipTrios:"
				attributeTrio := { attributeOne . attributeTwo . attributeThree }.

				"Cycle through the Attribute trio, making a new RelationshipTrio 
				from the set, but with each Attribute in turn being the 'common' 
				Attribute; collect the resulting new relationships:"
				attributeTrio
					do: [ :commonAttribute | 
						relationTrioCollection 
							add: (LPRelationshipTrio
								newFrom: attributeTrio
								for: commonAttribute
								using: self) ] ] ] ].
	
	^ relationTrioCollection
]

{ #category : #creating }
LPAttributeDatabase >> createRelationships [
	"Crunch the set of Attributes to create the relationships."

	"Create all the pair-wise permutations of attributes, making 
	a dictionary that points to unique pair-wise combinations:"
	relationshipDictionary := self createAttributeRelationships.

	"Create all the combinations of attributes taken 3 at time:"
	relationshipTrioCollection := self createRelationshipTrios
]

{ #category : #initialization }
LPAttributeDatabase >> initialize [
	"Initialize my collections and constraints."

	super initialize.
	
	"Create the expandable arrays to accumulate the set of 	Attributes 
	and the set of Properties as the user provides them to us."
	attributeDictionary := Dictionary new.
	propertyDictionary := Dictionary new.

	"Set constraints for this puzzle that apply universally."
	minNumberOfAttributes := 3.
	minNumberOfProperties := 2
]

{ #category : #reporting }
LPAttributeDatabase >> listInconsistencies [
	"Create a report of AttributeRelationships that are inconsistent."
	
	^ relationshipDictionary select: [ :attributeRelationship | 
		attributeRelationship isInconsistent ]
]

{ #category : #reporting }
LPAttributeDatabase >> listProperties [
	"Create a report listing the Attribute Properties."

	^ String
		streamContents: [ :stream | 
			"Create a header/title for the report:"
			stream
				nextPutAll: 'List of puzzle attribute properties:';
				cr;
				cr.

			"Add the name of the Primary Attribute:"
			stream
				nextPutAll: 'Primary Attribute: ';
				nextPutAll: (self primaryAttribute ifNil: [ '*Not set*' ]);
				cr;
				cr.

			"Display a list of all the Attributes:"
			attributeDictionary 
				keysAndValuesDo: [ :name :attributeRelationship | 
					"Put the Attribute name on one line:"
					stream
						print: name;
						nextPut: $:;
						cr.

					"Then list its Properties, indented, on separate lines:"
					attributeRelationship propertySet 
						do: [ :property | 
							stream
								tab;
								print: property name;
								cr ].
					stream cr ] ]
]

{ #category : #reporting }
LPAttributeDatabase >> listRelationships [
	"Create a report listing the Attribute Relationships."

	^ String
		streamContents: [ :stream | 
			"Create a header/title for the report:"
			stream
				nextPutAll: 'List of puzzle attribute relationships:';
				cr;
				cr.

			"Display a list of all the Attribute Relationships:"
			relationshipDictionary 
				keysAndValuesDo: [ :name :attributeRelationship | 
					"Put the relationship name on one line:"
					stream
						nextPutAll: name asString;
						nextPut: $:;
						cr.

					"Then display its Truth Table, indented:"
					attributeRelationship renderRelationship.
					stream
						tab;
						nextPutAll: attributeRelationship displayString;
						cr; cr ].
					stream cr ] 
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
LPAttributeDatabase >> primaryAttribute [
	^ primaryAttribute
]

{ #category : #accessing }
LPAttributeDatabase >> primaryAttribute: anAttribute [
	"Validate the argument to look up the attribute to set as primary."

	primaryAttribute := self validateExistingAttributeName: anAttribute
]

{ #category : #accessing }
LPAttributeDatabase >> propertyDictionary [
	^ propertyDictionary
]

{ #category : #lookup }
LPAttributeDatabase >> propertyNames [
	^ propertyDictionary keys
]

{ #category : #lookup }
LPAttributeDatabase >> propertyNamesOfAttribute: attributeOrName [
	"Respond with an array of the names of the Properties of the given Attribute."

	^ (self propertySetOfAttribute: attributeOrName)
		collect: [ :property | property name ]
]

{ #category : #lookup }
LPAttributeDatabase >> propertyRelationshipFor: propertyOrNameOne with: propertyOrNameTwo [
	"Get the PropertyRelationship for the two Properties."

	| propertyOne propertyTwo |
	propertyOne := self validateExistingPropertyName: propertyOrNameOne.
	propertyTwo := self validateExistingPropertyName: propertyOrNameTwo.

	"Look up the relationship between the Attributes, then ask that 
	relationship to tell us the state between the specific Properties:"
	^ (self
			attributeRelationshipFor: propertyOne attribute
			with: propertyTwo attribute)
		relationshipOf: propertyOne
		with: propertyTwo
]

{ #category : #lookup }
LPAttributeDatabase >> propertyRelationshipFor: propertyOrNameOne with: propertyOrNameTwo is: relationshipState [
	"Set the PropertyRelationship for the two Properties."

	| propertyOne propertyTwo |
	propertyOne := self validateExistingPropertyName: propertyOrNameOne.
	propertyTwo := self validateExistingPropertyName: propertyOrNameTwo.

	"Look up the relationship between the Attributes, then ask that 
	relationship to set the state between the specific Properties:"
	^ (self
			attributeRelationshipFor: propertyOne attribute
			with: propertyTwo attribute)
		relationshipOf: propertyOne
		with: propertyTwo
		is: relationshipState 
]

{ #category : #lookup }
LPAttributeDatabase >> propertySetOfAttribute: attributeOrName [
	"Respond with the set of Properties of the given Attribute/name."

	"You could just ask the Attribute itself for its PropertySet..."
	attributeOrName class = LPAttribute
		ifTrue: [ ^ attributeOrName propertySet ].

	"Otherwise, all we have is a name, so we do a lookup:"
	^ (self validateExistingAttributeName: attributeOrName) propertySet
]

{ #category : #accessing }
LPAttributeDatabase >> relationshipDictionary [
	^ relationshipDictionary
]

{ #category : #accessing }
LPAttributeDatabase >> relationshipTrioCollection [
	^ relationshipTrioCollection
]

{ #category : #reporting }
LPAttributeDatabase >> renderAllRelationships [
	"Render all the AttributeRelationships into a string for display."
	
	^ String streamContents: [ :stream | 
		self attributeRelationships do: [ :attributeRelationship | 
			stream nextPutAll: attributeRelationship renderRelationship ] ]
]

{ #category : #reporting }
LPAttributeDatabase >> renderRelationshipOf: attributeOrNameOne with: attributeOrNameTwo [
	"Render an AttributeRelationship into a string for display."

	| attributeOne attributeTwo attributeRelationship |
	attributeOne := self
		validateExistingAttributeName: attributeOrNameOne.
	attributeTwo := self
		validateExistingAttributeName: attributeOrNameTwo.
		
	attributeRelationship := self
		attributeRelationshipFor: attributeOne
		with: attributeTwo.
		
	^ attributeRelationship renderRelationship
]

{ #category : #validation }
LPAttributeDatabase >> validateExistingAttributeName: nameOrSymbol [
	"Validate the Attribute name, convert it to a symbol, 
	and return it if we know it.  Else throw an error."

	| attributeName |
	attributeName := self validateName: nameOrSymbol.

	^ attributeDictionary
		at: attributeName
		ifAbsent: [ self error: 'Unknown attribute name (' , attributeName , ')' ]
]

{ #category : #validation }
LPAttributeDatabase >> validateExistingPropertyName: nameOrSymbol [
	"Validate the Property name, convert it to a symbol, 
	and return it if we know it.  Else throw an error."

	| propertyName |
	propertyName := self validateName: nameOrSymbol.

	^ propertyDictionary
		at: propertyName
		ifAbsent: [ self error: 'Unknown property name (' , propertyName , ')' ]
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
