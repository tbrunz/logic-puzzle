Class {
	#name : #LogicPuzzleInferenceTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleInferenceTest >> testDeduceFalseMatches [
	"Test that a 'true' match will produce row/column falses."
	
	| puzzle matrix |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle newWithTraitSize: 3 .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	self should: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self assert: (puzzle createAssociations) size equals: 3 .
	
	"Can refer to traits & their tags with strings or symbols:"
	self shouldnt: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Tea' be: false ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Water' be: true ] raise: Error .
	
	"Verify that the rows & columns of a matched association are set false:"
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Pet . ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Pet) isModified equals: true .

	matrix := (puzzle getAssociationOf: #Nationality with: #Pet) matrix .
	1 to: matrix numberOfRows do: [ :row |  
		Transcript cr.
		1 to: matrix numberOfColumns do: [ :col |
			Transcript show: ((matrix at: row at: col) 
				ifNil: [ 'N  ' ] ifNotNil: [ 
					(matrix at: row at: col) ifTrue: [ 'T  ' ] ifFalse: [ 'F  ' ] ]
					) ]] .
	Transcript cr; cr.
	
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage . ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	matrix := (puzzle getAssociationOf: #Nationality with: #Beverage) matrix .
	1 to: matrix numberOfRows do: [ :row |  
		Transcript cr.
		1 to: matrix numberOfColumns do: [ :col |
			Transcript show: ((matrix at: row at: col) 
				ifNil: [ 'N  ' ] ifNotNil: [ 
					(matrix at: row at: col) ifTrue: [ 'T  ' ] ifFalse: [ 'F  ' ] ]
					) ]] .
	Transcript cr; cr.
	
	
	"Associations should report the value they were set with; unset associations should report nil:"
	self assert: (puzzle associationValueFor: #Nationality being: #Norwegian with: #Pet being: #Zebra) equals: true .
	self assert: (puzzle associationValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Tea) equals: false .
	self assert: (puzzle associationValueFor: #Nationality being: #Japanese with: #Pet being: #Snails) equals: nil .
]
