"
I represent an association between two puzzle traits. 

I use my traits to create a pair of Dictionaries, representing Row and Column.
My Dictionary keys are taken from the set of tags for each of my traits. 

I form a grid, in row-major order, with each cell containing ( true | false | nil ). 
If a cell is ""true"", its row tag is logically associated with its column tag. 
If a cell is ""false"", its row tag is not associated with its column tag. 
If a cell is ""nil"", the associate between the two trait values is unknown. 

I know how to set an association in myself, and I can report the status of an association.
I know how to inspect myself to determine if I am logically complete (all traits are associated).
I know how to inspect myself to determine if I am logically consistent 
 (i.e., every row trait can be associated with only one column trait).

I know how to render myself as a printable string. 
I know how to render an entire row or column of myself as a printable string. 
"
Class {
	#name : #LPAssociation,
	#superclass : #Object,
	#instVars : [
		'trait1',
		'trait2',
		'isComplete',
		'isConsistent',
		'isModified'
	],
	#category : #LogicPuzzle
}
