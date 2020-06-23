Class {
	#name : #LogicPuzzleCreationTest,
	#superclass : #TestCase,
	#category : #'LogicPuzzle-Tests'
}

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateLogicPuzzle [
	"Test behavior regarding the Logic Puzzle constructor argument."
	
	self should: [ LogicPuzzle traitSize: 1] raise: Error . 
	self should: [ LogicPuzzle traitSize: 'abc' ] raise: Error .
	
	self shouldnt: [ LogicPuzzle traitSize: 5 ] raise: Error .
]

{ #category : #tests }
LogicPuzzleCreationTest >> testCreateTrait [
	"Test the creation of a Logic Puzzle Trait object."
	
	self should: [ LPTrait new name: 1 ] raise: Error .
	self should: [ LPTrait new name: '' ] raise: Error .
	
	self shouldnt: [ LPTrait new name: 'abc' ] raise: Error .
	self shouldnt: [ LPTrait new name: #xyz ] raise: Error .
]
