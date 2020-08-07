Class {
	#name : #BaselineOfLogiPuzzle,
	#superclass : #BaselineOf,
	#category : #BaselineOfLogicPuzzle
}

{ #category : #baselines }
BaselineOfLogiPuzzle >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec package: 'LogicPuzzle' ]
]
