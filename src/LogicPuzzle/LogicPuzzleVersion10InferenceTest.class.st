Class {
	#name : #LogicPuzzleVersion10InferenceTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleVersion10InferenceTest >> testDeduceFalseMatches [
	"Test that a 'true' match will produce row/column falses."
	
	| puzzle assn |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 traits -> 3*2/2 = 3 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Create the associations for this puzzle:"
	self shouldnt: [ puzzle createAssociations ] raise: Error .
	
	"Make some trait matches to test with:"
	self shouldnt: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Tea' be: false ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Coffee' be: true ] raise: Error .
	
	"Verify that the rows & columns of a matched association are set false:"
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Pet ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Pet) isModified equals: true .

	"Render the association matrix for printing:"
	assn := puzzle getAssociationOf: #Nationality with: #Pet .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	"Verify again for another association pair:"
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	self assert: (puzzle getValueFor: #Nationality being: #Norwegian with: #Beverage being: #Coffee) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Japanese with: #Beverage being: #Coffee) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Coffee) equals: true .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Tea) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Water) equals: false .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	"Add another match to an association that already has one:"
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Japanese' matches: 'Beverage' being: 'Tea' be: true ] raise: Error .
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage.
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleVersion10InferenceTest >> testDeduceTrueMatches [
	"Test that row or column of N-1 'falses' will produce row/column true."
	
	| puzzle assn |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian #Englishman ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Dog #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Milk #Tea #Coffee ) ] raise: Error .
	
	"Make some association matches to test with:"
	self shouldnt: [ puzzle createAssociations ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: #Nationality being: #Norwegian matches: #Pet being: #Zebra be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Tea' be: false ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Coffee' be: true ] raise: Error .
	
	"Verify that the rows & columns of a matched association are set false:"
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Pet ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Pet) isModified equals: true .

	assn := puzzle getAssociationOf: #Nationality with: #Pet .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
		
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Japanese' matches: 'Beverage' being: 'Tea' be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Norwegian' matches: 'Beverage' being: 'Water' be: false ] raise: Error .
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	
	"Test for deducing association matches:"
	self shouldnt: [ puzzle deduceTrueMatchesIn: assn ] raise: Error .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	self shouldnt: [ puzzle deduceTrueMatchesIn: assn ] raise: Error .
	
	assn := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: assn ] raise: Error .
	Transcript crShow: assn matrixString .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleVersion10InferenceTest >> testVettingAssociations [
	"Test iterating over all associations, deducing true/false, until no modifications are made."
	
	| puzzle assnNatBev assnNatPet assnBevPet |
	"Create a test puzzle with some traits:"
	puzzle := LogicPuzzle new .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 associations:"
	self shouldnt: [ puzzle addTrait: #Nationality withTags: #( #Norwegian #Japanese #Ukrainian #Englishman ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Pet withTags: #( #Dog #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addTrait: #Beverage withTags: #( #Water #Milk #Tea #Coffee ) ] raise: Error .
	
	"Create the set of associations:"
	self shouldnt: [ puzzle createAssociations ] raise: Error .
	
	"Retrieve associations created:"
	assnNatBev := puzzle getAssociationOf: #Nationality with: #Beverage .
	assnNatPet := puzzle getAssociationOf: #Nationality with: #Pet .
	assnBevPet := puzzle getAssociationOf: #Beverage with: #Pet .
	
	"Make some association matches to test with:"
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Tea' be: false ] raise: Error .
	self shouldnt: [ puzzle vetSetOfAssociations ] raise: Error .
	Transcript show: puzzle reportLog contents .
	self shouldnt: [ puzzle renderAssociation: assnNatBev ] raise: Error .
	Transcript crShow: assnNatBev matrixString .
	
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Beverage' being: 'Coffee' be: true ] raise: Error .
	self shouldnt: [ puzzle vetSetOfAssociations ] raise: Error .
	Transcript show: puzzle reportLog contents .
	self shouldnt: [ puzzle renderAssociation: assnNatBev ] raise: Error .
	Transcript crShow: assnNatBev matrixString .
	
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Japanese' matches: 'Beverage' being: 'Tea' be: true ] raise: Error .
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Ukrainian' matches: 'Pet' being: 'Snails' be: true ] raise: Error .
	
	self shouldnt: [ puzzle vetSetOfAssociations ] raise: Error .
	Transcript show: puzzle reportLog contents .
	self shouldnt: [ puzzle renderAssociation: assnNatBev ] raise: Error .
	self shouldnt: [ puzzle renderAssociation: assnNatPet ] raise: Error .
	self shouldnt: [ puzzle renderAssociation: assnBevPet ] raise: Error .
	Transcript crShow: assnNatBev matrixString .
	Transcript crShow: assnNatPet matrixString .
	Transcript crShow: assnBevPet matrixString .
	
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Norwegian' matches: 'Beverage' being: 'Water' be: false ] raise: Error .
	self shouldnt: [ puzzle vetSetOfAssociations ] raise: Error .
	Transcript show: puzzle reportLog contents .
	self shouldnt: [ puzzle renderAssociation: assnNatBev ] raise: Error .
	self shouldnt: [ puzzle renderAssociation: assnNatPet ] raise: Error .
	self shouldnt: [ puzzle renderAssociation: assnBevPet ] raise: Error .
	Transcript crShow: assnNatBev matrixString .
	Transcript crShow: assnNatPet matrixString .
	Transcript crShow: assnBevPet matrixString .
	
	Transcript crShow: '------------------------------------'; cr 
	
]
