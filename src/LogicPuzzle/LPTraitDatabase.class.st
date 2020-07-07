"
I represent a database of traits that describe the subjects of a logic puzzle. 

The traits I keep track of have a name, 
e.g., #Nationality, #Color, #Sequence. 

For each of my traits, I define its set of tags. 
e.g., #( #Yellow, #Blue, #Red ), or #( #1, #2, #3 ). 

I can also return the array of tags for one of my traits, given its name.
Given one of my tags, I can return the name of the trait it belongs to. 
As the above implies, every tag must be distinct, independent of trait.

Every trait must have the same number of tags.
The object that owns me tells me what this number is when I'm created.

A logic puzzle contains an instance of me, and uses me to relate tags & traits.
"
Class {
	#name : #LPTraitDatabase,
	#superclass : #Object,
	#instVars : [
		'tags',
		'traits',
		'width'
	],
	#classVars : [
		'MinimumNumberOfTags',
		'MinimumNumberOfTraits'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'class initialization' }
LPTraitDatabase class >> initialize [
	"Set universal size constraints."

	MinimumNumberOfTraits := 3.
	MinimumNumberOfTags := 2
]

{ #category : #'instance creation' }
LPTraitDatabase class >> newWithTraitSize: numberOfTags [
	"Create a new trait database with the given number of trait tags."

	"Validiate the parameter for type and range:"
	self validateTraitSize: numberOfTags.

	"Create a new database instance & initialize it:"
	^ self new
		numberOfTraitTags: numberOfTags;
		yourself
]

{ #category : #validation }
LPTraitDatabase class >> validateTraitSize: numberOfTags [
	"Validate the parameter that specifies the required number of trait tags."

	numberOfTags isInteger
		ifFalse: [ self error: 'Argument must be an integer' ].

	numberOfTags >= MinimumNumberOfTags
		ifFalse: [ self
				error:
					'Traits must have at least ' , MinimumNumberOfTags printString
						, ' tags' ].
	^ numberOfTags
]

{ #category : #adding }
LPTraitDatabase >> addTrait: stringOrSymbol withTags: tagArray [
	"Create a new trait from a given symbol & array of tags."

	| traitName traitTags |
	"Accept strings or symbols for the name; convert strings to symbols."
	traitName := LPTraitVersion10 validateTraitName: stringOrSymbol.

	"Validate the trait tags for type and number; convert all to symbols:"
	traitTags := self validateTraitTags: tagArray.

	"Verify that none of the tags in the array duplicates any we already know:"
	tags
		do: [ :tag | 
			(traitTags anySatisfy: [ :each | each = tag ])
				ifTrue: [ self error: 'Duplicate tags not allowed (' , tag , ')' ] ].

	"We disallow duplicate trait names, but replacing an existing trait is okay:"
	tags add: traitName -> tagArray.
	traitTags do: [ :tag | traits add: tag -> traitName ].
	
	^ traitName
]

{ #category : #initialization }
LPTraitDatabase >> initialize [
	"I need a pair of complementary dictionaries, so that 
	I can refer to my data symbolically (as my user does)."

	traits := Dictionary new.
	tags := Dictionary new.
	
	"I don't know yet what my width (number of tags per trait) will be.
	As traits and tags are provided to me, I need to compare their number 
	to something, so start with a value that is obviously too low.
	The first set of tags will replace my value with its size."
	width := -1
]

{ #category : #initialization }
LPTraitDatabase >> numberOfTraitTags: numberOfTags [
	"Initialize myself, creating new empty collections."

	width := numberOfTags.
	traits := Dictionary new.
	tags := Dictionary new.
]

{ #category : #accessing }
LPTraitDatabase >> tags [
	"The 'traits' collection is a dictionary; 
	Its values are trait names; therefore, 
	its keys are the tag names.  Return them."
	^ traits keys
]

{ #category : #accessing }
LPTraitDatabase >> tags: aTraitName [
	"Respond with the array of tags of the given trait."
	
	^ tags at: aTraitName ifAbsent: [ Array ofSize: 0 ]
]

{ #category : #accessing }
LPTraitDatabase >> trait: aTag [
	"Respond with the trait that the given tag belongs to."
	
	^ traits at: aTag ifAbsent: [ #'' ]
]

{ #category : #accessing }
LPTraitDatabase >> traits [
	"The 'tags' collection is a dictionary; 
	Its values are trait tags; therefore, 
	its keys are the trait names.  Return them."
	^ tags keys
]

{ #category : #validation }
LPTraitDatabase >> validateTraitName: traitName [ 
	"Validate the parameter as being a symbol or a string."
	"If a string, render it as a valid symbol."
	
	traitName isSymbol 
		ifTrue: [ ^ traitName ] .
	
	(traitName isString and: [ traitName isNotEmpty ])
		ifTrue: [ ^ traitName asSymbol ] .
	
	self error: 'Symbol required for trait tags'
]

{ #category : #validation }
LPTraitDatabase >> validateTraitTags: tagArray [
	"Validate an array of trait tags."

	tagArray isArray
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ].
		
	tagArray size = width
		ifFalse: [ width < 0
				ifTrue: [ width := tagArray size ]
				ifFalse: [ self error: 'Traits must have ' , width printString , ' tags' ] ].
			
	^ tagArray
		collect: [ :tag | 
			tag isSymbol ifTrue: [ tag ] ifFalse: [ 
			(tag isString and: [ tag isNotEmpty ])
				ifTrue: [ tag asSymbol ]
				ifFalse: [ self error: 'Trait tags must be strings or symbols' ] ] ]
]
