"
I represent a logic puzzle (such as the ""Zebra Puzzle""), a type of constraint satisfaction problem.

I create puzzle instances and define their top-level behavior.

I keep a dictionary of my subject traits; I know how many tags each trait must have. 
I know how to inspect & verify my set of traits, and how to create a set of associations from them. 

I keep a dictionary of trait associations; I know how to print them, vet them, and modify them. 

Example:

	zebraPuzzle := LogicPuzzle traitSize: 5 .
	
	zebraPuzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian #Englishman #Spaniard ) .
	zebraPuzzle addTrait: #Pet withTags: #( #Dog #Horse #Snails #Fox #Zebra ) .
	
	zebraPuzzle createAssociations .
	--> 15 associations created
	
	zebraPuzzle primaryTrait: #Nationality .
	
	zebraPuzzle makeAssociation: #Nationality being: #Spaniard matches: #Pet being: #Snails be: true.
	
	zebraPuzzle printAssociation: #Nationality vs: #Pet .
"
Class {
	#name : #LogicPuzzle,
	#superclass : #Object,
	#instVars : [
		'numberOfTraitTags',
		'nameSeparator',
		'primaryTrait',
		'setOfTraits',
		'setOfAssociations'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #'instance creation' }
LogicPuzzle class >> newWithTraitSize: numberOfTags [
	"Create a new logic puzzle with a given number of trait tags."

	"Validiate the parameter for type and range:"
	self validateTraitSize: numberOfTags.

	"Set a string in LPAssociation used to separate trait names:"
	"This couples LPAssociation into this class...  
	How best to initialize a class instance variable?  
	Doing it here at least makes it explicit & visible..."
	LPAssociation nameSeparator: ' =(vs)= '.

	"Create a new puzzle instance & initialize it:"
	^ self new
		numberOfTraitTags: numberOfTags;
		setOfTraits: Dictionary new;
		"setOfAssociations: Dictionary new;"
		yourself
]

{ #category : #validation }
LogicPuzzle class >> validateTraitSize: numberOfTags [
	"Validate the parameter that specifies the required number of trait tags."
	"The number of tags must be an integer greater than 1."

	numberOfTags isInteger 
		ifFalse: [ self error: 'Argument must be an integer > 1' ] .
	
	(numberOfTags > 1)
		ifFalse: [ self error: 'Traits must have at least 2 tags' ] .
		
	^ numberOfTags 
]

{ #category : #adding }
LogicPuzzle >> addTrait: stringOrSymbol withTags: tagArray [
	"Create a new trait from a given symbol & array of tags."

	| trait traitName traitTags |
	"Accept strings or symbols for the name, convert to symbols."
	traitName := LPTrait validateTraitName: stringOrSymbol.
	
	"Validate the trait tags for type and number, also converted to symbols:"
	traitTags := self validateTraitTags: tagArray.
	
	trait := LPTrait newNamed: traitName with: traitTags.

	"We disallow duplicate trait names, but replacing an existing is okay:"
	setOfTraits add: traitName -> trait.
	
	^ trait
]

{ #category : #inferencing }
LogicPuzzle >> associationValueFor: firstTraitName being: firstTag with: secondTraitName being: secondTag [
	"Retrieve the association value for a pair of trait/tags."

	| firstTagIndex secondTagIndex association |
	firstTagIndex := self getIndexFrom: firstTraitName forTag: firstTag.
	secondTagIndex := self getIndexFrom: secondTraitName forTag: secondTag.
	
	association := self getAssociationOf: firstTraitName with: secondTraitName.
	
	^ association matrix at: firstTagIndex at: secondTagIndex
	
]

{ #category : #adding }
LogicPuzzle >> createAssociations [
	"Create the set of trait associations for the puzzle."

	| arrayOfTraitKeys firstSymbol secondSymbol association |
	setOfAssociations := Dictionary new .
	
	"Create an array of trait keys so that we can step through them systematically:"
	arrayOfTraitKeys := setOfTraits keys.

	"Step through C(n,2) = every combination of traits taken 2 at a time:"
	1 to: arrayOfTraitKeys size - 1 do: [ :outerIndex | 
		firstSymbol := arrayOfTraitKeys at: outerIndex.

		"Step through the remaining traits in the array to pair with this one:"
		outerIndex + 1 to: arrayOfTraitKeys size do: [ :innerIndex | 
			secondSymbol := arrayOfTraitKeys at: innerIndex.

			"Form a new name & a new association using the two traits:"
			association := LPAssociation
				newWith: (setOfTraits at: firstSymbol)
				with: (setOfTraits at: secondSymbol).

			"Finally, add the new association to our set:"
			setOfAssociations add: (association name) -> association ] ].
	^ setOfAssociations
]

{ #category : #inferencing }
LogicPuzzle >> deduceFalseMatchesIn: anAssociation [
	"Given an association of traits, deduce & set false matches."

	| matrix |
	"Walk through each cell of the association matrix, looking for 'true':"
	matrix := anAssociation matrix.
	matrix
		withIndicesDo: [ :value :rowIndex :colIndex | 
			value
				"'true' implies all other cells in the row & column are 'false':"
				ifTrue: [ anAssociation setRowFalse: rowIndex.
					anAssociation setColFalse: colIndex ] ]
]

{ #category : #inferencing }
LogicPuzzle >> deduceFalseMatchesOf: firstTraitName with: secondTraitName [
	"Given a pair of traits, deduce & set false association matches."

	| association |
	association := self
		getAssociationOf: (self verifyTraitExists: firstTraitName)
		with: (self verifyTraitExists: secondTraitName).

	self deduceFalseMatchesIn: association 
]

{ #category : #retrieval }
LogicPuzzle >> getAssociationOf: firstTraitName with: secondTraitName [
	"Verify that we have an associtaion with these names & return it."

	| associationName |
	associationName := LPAssociation
		nameWith: firstTraitName
		with: secondTraitName.

	"See if we have an association named with '1+2'; if not, try '2+1' instead."
	^ setOfAssociations
		at: associationName
		ifAbsent: [ associationName := LPAssociation
				nameWith: secondTraitName
				with: firstTraitName.
			setOfAssociations
				at: associationName
				ifAbsent: [ self
						error:
							'Unknown assocation between ' , firstTraitName , ' and '
								, secondTraitName ] ]
]

{ #category : #retrieval }
LogicPuzzle >> getIndexFrom: aTrait forTag: aTag [
	"Get the tag index number, given a trait and one of its tags."

	| tag |
	tag := self verifyTrait: aTrait containsTag: aTag .
	
	"If the above tag validation succeeds, then the trait is a valid trait, too."
	^ (setOfTraits	at: aTrait) indices at: tag
]

{ #category : #reporting }
LogicPuzzle >> listAssociations [
	"Create a report listing the associations."

	^ String
		streamContents: [ :stream | 
			"Create a header/title for the report:"
			stream
				nextPutAll: 'List of puzzle associations:';
				cr;
				cr.

			"Display a list of all the associations:"
			setOfAssociations 
				keysAndValuesDo: [ :name :traitAssociation | 
					"Put the association name on one line:"
					stream
						print: name asString;
						nextPut: $:;
						cr.

					"Then display its grid, indented:"
					stream
						tab;
						print: '<trait association grid>';
						cr ].
					stream cr ] 
]

{ #category : #reporting }
LogicPuzzle >> listTraits [
	"Create a report listing the traits."

	^ String
		streamContents: [ :stream | 
			"Create a header/title for the report:"
			stream
				nextPutAll: 'List of puzzle traits:';
				cr;
				cr.

			"Add the name of the primary trait:"
			stream
				nextPutAll: 'Primary Trait: ';
				nextPutAll: (self primaryTrait ifNil: [ '*Not set*' ]);
				cr;
				cr.

			"Display a list of all the traits:"
			setOfTraits
				keysAndValuesDo: [ :traitName :trait | 
					"Put the trait name on one line:"
					stream
						print: traitName;
						nextPut: $:;
						cr.

					"Then list its tags, indented, on separate lines:"
					trait tags 
						do: [ :tag | 
							stream
								tab;
								print: tag;
								cr ].
					stream cr ] ]
]

{ #category : #adding }
LogicPuzzle >> makeAssociation: firstTrait being: firstTag matches: secondTrait being: secondTag be: aBoolean [
	"Create and validate a new trait association."

	| firstIndex secondIndex association match |
	firstIndex := self getIndexFrom: firstTrait forTag: firstTag.
	secondIndex := self getIndexFrom: secondTrait forTag: secondTag.
	
	association := self getAssociationOf: firstTrait with: secondTrait.
	
	match := association matrix at: firstIndex at: secondIndex.
	match
		ifNil: [ association matrix at: firstIndex at: secondIndex put: aBoolean ]
		ifNotNil: [ self
				error:
					'Association "' , association name , '" is already known to be '
						, match asString ]
]

{ #category : #accessing }
LogicPuzzle >> numberOfTraitTags [
	^ numberOfTraitTags
]

{ #category : #accessing }
LogicPuzzle >> numberOfTraitTags: anInteger [
	numberOfTraitTags := anInteger
]

{ #category : #accessing }
LogicPuzzle >> primaryTrait [
	^ primaryTrait
]

{ #category : #accessing }
LogicPuzzle >> primaryTrait: traitName [
	"Given a trait tag name, set the primary trait."

	| name traitKeys |
	"Argument must be a trait name -- string or symbol:"
	name := LPTrait validateTraitName: traitName.

	"Get an array of traits keys that match the given name:"
	traitKeys := setOfTraits keys select: [ :key | key = name ].
	
	"Three cases can result: 0, 1, or many.  Only '1' is good."
	"Make the error messages specific to the problem encountered:"
	traitKeys isEmpty
		ifTrue: [ self error: 'Unknown trait "' , name , '"' ].
	traitKeys size > 1
		ifTrue: [ self
				error: 'Program failure: Found more than one trait named "' , name , '"!' ].
	
	"If we find exactly one instance, then we're good:"
	primaryTrait := name.
	^ name
]

{ #category : #accessing }
LogicPuzzle >> setOfAssociations [
	^ setOfAssociations
]

{ #category : #accessing }
LogicPuzzle >> setOfAssociations: aDictionary [
	setOfAssociations := aDictionary
]

{ #category : #accessing }
LogicPuzzle >> setOfTraits [
	^ setOfTraits
]

{ #category : #accessing }
LogicPuzzle >> setOfTraits: aDictionary [
	setOfTraits := aDictionary
]

{ #category : #validation }
LogicPuzzle >> validateTraitTags: tagArray [
	"Validate an array of tags."

	tagArray isArray 
		ifFalse: [ self error: 'Trait tags must be an array of symbols' ].
		
	tagArray size = numberOfTraitTags
		ifFalse: [ self
				error:
					'Traits for this puzzle require ' , numberOfTraitTags printString , ' tags' ].
					
	^ tagArray
]

{ #category : #validation }
LogicPuzzle >> verifyTrait: aTraitName containsTag: aTag [
	"Verify that we know about a trait, and that it includes the tag."

	| traitName tagName |
	traitName := self verifyTraitExists: aTraitName.
		
	tagName := aTag.
	tagName isString
		ifTrue: [ tagName := aTag asSymbol ].
	tagName isSymbol
		ifFalse: [ self error: 'Trait tags must be referred to with their names' ].
		
	((setOfTraits at: traitName) tags includes: aTag)
		ifFalse:
			[ self error: 'Unknown tag ' , aTag , ' for trait ' , aTraitName ].
		
	^ tagName

]

{ #category : #validation }
LogicPuzzle >> verifyTraitExists: aTraitName [
	"Verify that the argument is a name of a trait we know about."

	| traitName |
	traitName := aTraitName.
	traitName isString
		ifTrue: [ traitName := aTraitName asSymbol ].
	traitName isSymbol
		ifFalse: [ self error: 'Traits must be referred to with their names' ].
		
	setOfTraits
		at: traitName
		ifAbsent: [ self error: 'Unknown trait named ' , traitName ].
		
	^ traitName

]
