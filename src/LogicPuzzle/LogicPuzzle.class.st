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

	| firstIndex secondIndex association row col |
	firstIndex := self getIndexFrom: firstTraitName forTag: firstTag.
	secondIndex := self getIndexFrom: secondTraitName forTag: secondTag.
	
	association := self getAssociationOf: firstTraitName with: secondTraitName.
	association firstTrait name = firstTraitName
		ifTrue: [ row := firstIndex.
			col := secondIndex ]
		ifFalse: [ row := secondIndex.
			col := firstIndex ].
	
	^ association matrix at: row at: col
	
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
	"Given an association of traits, deduce & set 'false' matches."

	| matrix |
	"Walk through each cell of the association matrix, looking for 'true':"
	matrix := anAssociation matrix.
	matrix
		withIndicesDo: [ :value :rowIndex :colIndex | 
			value
				ifNotNil: [ "'true' implies all other cells in the row & column are 'false'."
					value
						ifTrue: [ anAssociation
								setRowFalse: rowIndex;
								setColFalse: colIndex
								] ] ].
	
	^ anAssociation 
]

{ #category : #inferencing }
LogicPuzzle >> deduceFalseMatchesOf: firstTraitName with: secondTraitName [
	"Given a pair of traits, deduce & set false association matches."

	| association |
	association := self
		getAssociationOf: (self verifyTraitExists: firstTraitName)
		with: (self verifyTraitExists: secondTraitName).

	^ self deduceFalseMatchesIn: association 
]

{ #category : #inferencing }
LogicPuzzle >> deduceTrueMatchesIn: anAssociation [
	"Given an association of traits, deduce & set 'true' matches."

	| matrix coords |
	"Walk through each row/column of the association matrix, looking for N-1 'falses':"
	matrix := anAssociation matrix.
	coords := anAssociation matchCoords.
	
	matrix
		withIndicesDo: [ :value :rowIndex :colIndex | 
			value
				ifNil: [ ((anAssociation isRowAllFalse: rowIndex)
						or: [ anAssociation isColAllFalse: colIndex ])
						ifTrue: [ matrix at: rowIndex at: colIndex put: true.
							anAssociation isModified: true.
							coords add: (Point x: rowIndex y: colIndex)
							 ] ] ].
	
	^ anAssociation 
]

{ #category : #retrieval }
LogicPuzzle >> getAssociationOf: firstTraitName with: secondTraitName [
	"Verify that we have an associtaion with these names & return it."

	| name |
	"Create an association name from trait names in the order given:"
	name := LPAssociation nameWith: firstTraitName with: secondTraitName.
	
	"See if we have an association with this form of the name:"
	setOfAssociations ifNil: [ self error: 'The set of trait associations has yet to be created' ].
	setOfAssociations at: name ifPresent: [ :value | ^ value ].

	"That didn't work, so create the name using the other order:"
	name := LPAssociation nameWith: secondTraitName with: firstTraitName.
	
	"Now try to retrieve the association with this form:"
	setOfAssociations at: name ifPresent: [ :value | ^ value ].

	"Neither form of the name worked, so we must not know this one:"
	self
		error:
			'Unknown association between ' , firstTraitName , ' and '
				, secondTraitName
]

{ #category : #retrieval }
LogicPuzzle >> getIndexFrom: aTrait forTag: aTag [
	"Get the tag index number, given a trait and one of its tags."

	| tag |
	tag := self verifyTrait: aTrait containsTag: aTag .
	
	"If the above tag validation succeeds, then 'aTrait' is a valid trait, too."
	^ (setOfTraits	at: aTrait) indices at: tag
]

{ #category : #inferencing }
LogicPuzzle >> inferThirdTraitMatchesFor: anAssociation [
	"Find all other associations sharing the traits of this one, and match common tag states."

	| thisFirstTrait thisSecondTrait setOfOtherAssociations setOfMatchingAssociations |
	"If this association currently has no trait matches, don't bother trying to infer anything:"
	anAssociation matchCoords isEmpty ifTrue: [ ^ anAssociation ].
	
	"Extract the names of my two traits, for convenience:"
	thisFirstTrait := anAssociation firstTrait name.
	thisSecondTrait := anAssociation secondTrait name.

	"Copy the set of associations, removing me so that I don't match myself:"
	setOfOtherAssociations := setOfAssociations
		reject: [ :association | association name = anAssociation name ].

	"Now collect all associations containing traits that match one of my traits:"
	"Note that it is impossible for any to match both of my traits!"
	setOfMatchingAssociations := setOfOtherAssociations
		select: [ :association | 
			association firstTrait name = thisFirstTrait
				or: [ association firstTrait name = thisSecondTrait
						or: [ association secondTrait name = thisSecondTrait
								or: [ association secondTrait name = thisSecondTrait ] ] ] ].
					
	"Finally, with this set of associations, infer all the common trait matches:"
	^ self inferTraitMatchesIn: setOfMatchingAssociations impliedBy: anAssociation
]

{ #category : #inferencing }
LogicPuzzle >> inferTraitMatchesIn: setOfMatchingAssociations impliedBy: anAssociation [
	"Infer trait matches in the set of matching associations based on a given association."

	| firstTrait secondTrait firstSet secondSet associationPairs |
	"Extract the names of my two traits, for convenience:"
	firstTrait := anAssociation firstTrait name.
	secondTrait := anAssociation secondTrait name.
	
	"Create all sets of association pairs matching one trait each:"
	firstSet := setOfMatchingAssociations select: [ :association |
		association name = firstTrait ].
	secondSet := setOfMatchingAssociations select: [ :association |
		association name = secondTrait ].
	
	"These sets have to be the same size..."
	self assert: firstSet size = secondSet size.
	
	"Pair up each association in the first set with one in the second set:"
	associationPairs := nil.
	
	"Find the trait/tag combinations that are true in the given association:"
	
	
	"For each matching association, "
	
	^ anAssociation 
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

	| firstIndex secondIndex association row col match |
	firstIndex := self getIndexFrom: firstTrait forTag: firstTag.
	secondIndex := self getIndexFrom: secondTrait forTag: secondTag.
	
	association := self getAssociationOf: firstTrait with: secondTrait.
	association firstTrait name = firstTrait
		ifTrue: [ row := firstIndex.
			col := secondIndex ]
		ifFalse: [ row := secondIndex.
			col := firstIndex ].
		
	match := association matrix at: row at: col.
	match
		ifNil: [ association matrix at: row at: col put: aBoolean ]
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

{ #category : #reporting }
LogicPuzzle >> renderAssociation: anAssociation [
	"Render the matrix of an association."

	| matrix rowTraitTags colTraitTags |
	rowTraitTags := (self setOfTraits at: anAssociation firstTrait name) tags.
	colTraitTags := (self setOfTraits at: anAssociation secondTrait name) tags.
	
	matrix := anAssociation matrix.
	
	anAssociation
		matrixString:
			(String
				streamContents: [ :stream | 
					stream cr.
					colTraitTags
						do: [ :tag | 
							stream
								nextPutAll:
									(String
										streamContents: [ :s | s nextPutAll: tag asString ]
										limitedTo: 3);
								space ].
					1 to: matrix numberOfRows do: [ :row | 
						stream cr.
						1 to: matrix numberOfColumns do: [ :col | 
							stream
								nextPutAll:
									((matrix at: row at: col)
										ifNil: [ ' .  ' ]
										ifNotNil: [ (matrix at: row at: col)
												ifTrue: [ ' @  ' ]
												ifFalse: [ ' x  ' ] ]) ].
						stream
							space;
							nextPutAll: (rowTraitTags at: row) ].
					stream cr ])
]

{ #category : #reporting }
LogicPuzzle >> renderAssociationOf: firstTrait with: secondTrait [
	"Render the matrix of an association of two traits."

	| traitOne traitTwo association |
	traitOne := self verifyTraitExists: firstTrait. 
	traitTwo := self verifyTraitExists: secondTrait.
	
	association := self getAssociationOf: traitOne with: traitTwo .
	self renderAssociation: association 
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

{ #category : #inferencing }
LogicPuzzle >> vetSetOfAssociations [
	"Walk the set of associations, applying each check, until no other modifications are needed."

	| anyIsModified |
	anyIsModified := true.

	"Loop through all associations until no modifications detected:"
	[ anyIsModified ]
		whileTrue: [ anyIsModified := false.
			setOfAssociations
				do: [ :association | 
					association isModified: false.
					self
						inferThirdTraitMatchesFor:
							(self deduceFalseMatchesIn: 
								(self deduceTrueMatchesIn: association)).
					anyIsModified := anyIsModified or: [ association isModified ] ] ]
]
