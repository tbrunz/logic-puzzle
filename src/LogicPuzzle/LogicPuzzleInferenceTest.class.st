Class {
	#name : #LogicPuzzleInferenceTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleInferenceTest >> testDeduceExclusions [
	"Test that a matched relationship will produce row/column exclusions."
	
	| puzzle relationship database relationships |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 3 Attributes -> 3*2/2 = 3 relationship combinations = 6 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Tea #Coffee ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Make some relationships to test with:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .
	
	"Verify that relations set in the truth table are what we expect:"
	self assert: (puzzle relationshipOf: #Norwegian with: #Zebra) equals: 'matched'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Tea) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Coffee) equals: 'matched'.
	
	"Verify that the rows & columns of a matched relationship are set to excluded:"
	self shouldnt: [ (relationships at: #Nationality , #Pet) deduceExcludedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Pet) isModified equals: true .

self halt.
	"Render the association matrix for printing:"
	relationship := puzzle getAssociationOf: #Nationality with: #Pet .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	"Verify again for another association pair:"
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	self assert: (puzzle getValueFor: #Nationality being: #Norwegian with: #Beverage being: #Coffee) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Japanese with: #Beverage being: #Coffee) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Coffee) equals: true .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Tea) equals: false .
	self assert: (puzzle getValueFor: #Nationality being: #Ukrainian with: #Beverage being: #Water) equals: false .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	"Add another match to an association that already has one:"
	self shouldnt: [ puzzle makeAssociation: 'Nationality' being: 'Japanese' matches: 'Beverage' being: 'Tea' be: true ] raise: Error .
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage.
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> testDeduceMatches [
	"Test that row or column of N-1 exclusions will produce row/column matches."
	
	| puzzle database relationships relationship |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 4 Attributes -> 4*3/2 = 6 relationship combinations = 12 permutations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian #Englishman ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Dog #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Milk #Tea #Coffee ) ] raise: Error .
	
	"Create the relationships for this puzzle:"
	self shouldnt: [ puzzle createRelationships ] raise: Error .
	database := puzzle attributeDatabase .
	relationships := database relationshipDictionary.
	
	"Make some relationships to test with:"
	self shouldnt: [ puzzle relationshipOf: #Norwegian with: #Zebra is: #Matched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Tea' is: #Excluded ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Ukrainian' with: 'Coffee' is: #Matched] raise: Error .
	
	"Verify that relations set in the truth table are what we expect:"
	self assert: (puzzle relationshipOf: #Norwegian with: #Zebra) equals: 'matched'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Tea) equals: 'excluded'.
	self assert: (puzzle relationshipOf: #Ukrainian with: #Coffee) equals: 'matched'.
	
	"Verify that the rows & columns of a matched relationship are set to excluded:"
	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceMatchedRelationships ] raise: Error .
	self assert: (relationships at: #Beverage , #Nationality) isModified equals: true .

	self shouldnt: [ (relationships at: #Nationality , #Pet) deduceMatchedRelationships ] raise: Error .
	self assert: (relationships at: #Nationality , #Pet) isModified equals: true .

self halt.
	self shouldnt: [ (relationships at: #Nationality , #Beverage) renderRelationship ] raise: Error .
	Transcript crShow: (relationships at: #Nationality , #Beverage) tableString .

	self shouldnt: [ (relationships at: #Nationality , #Pet) renderRelationship ] raise: Error .
	Transcript crShow: (relationships at: #Nationality , #Pet) tableString .
	
self halt.
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	self shouldnt: [ puzzle relationshipOf: 'Japanese' with: 'Tea' is: LPRelationshipMatched ] raise: Error .
	self shouldnt: [ puzzle relationshipOf: 'Norwegian' with: 'Water' is: LPRelationshipExcluded ] raise: Error .
	
	self shouldnt: [ (relationships at: #Nationality , #Beverage) deduceMatchedRelationships ] raise: Error .
	self assert: (puzzle getAssociationOf: #Nationality with: #Beverage) isModified equals: true .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	
	"Test for deducing relationship matches:"
	self shouldnt: [ puzzle deduceTrueMatchesIn: relationship ] raise: Error .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	self shouldnt: [ puzzle deduceFalseMatchesOf: #Nationality with: #Beverage ] raise: Error .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	self shouldnt: [ puzzle deduceTrueMatchesIn: relationship ] raise: Error .
	
	relationship := puzzle getAssociationOf: #Nationality with: #Beverage .
	self shouldnt: [ puzzle renderAssociation: relationship ] raise: Error .
	Transcript crShow: relationship matrixString .
	
	Transcript crShow: '------------------------------------'; cr 
	
]

{ #category : #tests }
LogicPuzzleInferenceTest >> testVettingAssociations [
	"Test iterating over all associations, deducing true/false, until no modifications are made."
	
	| puzzle assnNatBev assnNatPet assnBevPet |
	puzzle := LogicPuzzle new .
	
	"Puzzle with 4 traits -> 4*3/2 = 6 associations:"
	self shouldnt: [ puzzle addAttribute: #Nationality withProperties: #( #Norwegian #Japanese #Ukrainian #Englishman ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Pet withProperties: #( #Dog #Snails #Fox #Zebra ) ] raise: Error .
	self shouldnt: [ puzzle addAttribute: #Beverage withProperties: #( #Water #Milk #Tea #Coffee ) ] raise: Error .
	
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
