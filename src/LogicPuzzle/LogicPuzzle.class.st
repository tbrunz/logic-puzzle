"
I represent a logic puzzle (such as the ""Zebra Puzzle""), a type of 
constraint satisfaction problem.

I create puzzle instances and define their top-level behavior.

I keep a dictionary of my subject Attributes; Attributes are comprised 
of multiple Properties. 

I know how to inspect & verify my set of Attributes, and how to create 
sets of Relationships among them. 

I keep a dictionary of Attribute Relationships; I know how to print 
them, vet them, and modify them.  These relationships represent cases 
where Attribute Properties are 'matched', 'excluded', or 'unknown'.

Most importantly, I know how to analyze the relationships to make 
deductions and inferences, ultimately turning 'unknown' relationships 
into 'matched' and 'excluded' relationships.

See the 'Examples' tag for examples on using LogicPuzzle.


Principles of Operation

The class 'LogicPuzzle' is intended to serve as a top-level coordinator of 
the user interface, the core of the puzzle, etc.

The class 'AttributeDatabase' manages the database of puzzle Attributes and 
Properties.  It also performs the analysis of the puzzle state.

The app is meant to be interactive; the first step is create a new puzzle, 
then enter Attributes and their sets of Properties.  User input is checked 
for valid types, etc., and added to AttributeDatabase.

Once all of the Attributes have been added, the second step is to create the 
set of Attribute Relationships that associate the input data.  Initially, 
these relationships are marked ""unknown"".

The third step is also interactive: Enter the set of rules for the puzzle.  
During this phase, the app can also be asked to analyze the puzzle state, 
drawing inferences and deducing new states.

Since the current version of the app cannot solve every puzzle on its own, 
this is necessarily an iterative and interactive process: The user examines 
the output of thepuzzle state analysis, formulates new rules that can be 
inferred from theupdated state, enters those rules, and runs the analysis 
again.

Eventually, the puzzle is solved this way.  A future version, with more 
sophisticated analysis capabilities, should be able to solve the puzzle on 
its own.


Analysis Algorithms

The simplest algorithms make deductions that detect relationship matches 
and exclusions.  A ""matched"" relationship exists between Properties of 
any two Attributes, and represents a case where a Property of the first 
Attribute corresponds to a Property of the second Attribute.  For example, 
the Property ""Norwegian"" of the Attribute ""Nationality"" may correspond to 
the Property ""Yellow"" of the Attribute ""HouseColor"".  This is a ""matched"" 
relationship.

Matched relationships imply ""excluded"" relationships.  Continuing the 
above example, if ""Norwegian"" is matched with ""Yellow"", then ""Norwegian"" 
(as a Property) cannot be matched with any other house color Property 
(""Red"", ""Blue"", etc.).  Therefore, the set of all other color Properties 
is ""excluded"" for ""Norwegian"" in this Attribute Relationship.  Similarly, 
all other ""Nationality"" Properties are excluded for house color ""Yellow"" 
in the same Attribute Relationship.

The above has a corresponding implication: In a puzzle with N Properties 
per Attribute, if an Attribute Relationship has a Property that has N-1 
exclusions and one ""unknown"" relationship state for the Properties of 
its paired Attribute, then it can be deduced that the single ""unknown"" 
state must be ""matched"".

The simplest analysis consists of examining the Attribute Relationships 
to detect the above conditions, then setting the corresponding matches 
and exclusions of the involved Properties.  This suggests a ""truth table"" 
data structure for the Attribute Relationships, a two-dimensional matrix 
where the rows are the Properties of one Attribute in the pair, while 
the columns are the Properties of the other Attribute.

This ""2D truth table"" structure then implies that Attribute Relationships 
need to be created for every pair-wise combination of Attributes in the 
puzzle.  For M Attributes with N Properties each, this means C(M,2), or 
the number of combinations of M elements taken 2 at a time.  For a puzzle 
with 6 Attributes, this equates to 15 Attribute Relationship truth tables.

Further insight reveals a strategy needed for Attribute Relationship 
analysis:  Upon deducing a match in a truth table, one must then deduce 
exclusions, and vice-versa.  So an iterative process is necessary; with 
each successful deduction, the Attribute Relationship will be modified, 
and this modification needs to be tracked.  The analysis must be iterated 
over every Attribute Relationship in the puzzle until no modifications 
have been performed.


Advanced Algorithms

The above deductions are not sufficient to solve any but the most trivial 
logic puzzles, however.  A more sophisticated analysis is needed, involving 
inferences between sets of three Attribute Relationships.

In this case, we form triplet sets of Attributes, say A, B, and C.  From 
this set, we can choose one Attribute, say 'C', to be a ""common"" attribute 
between two Attribute Relationship pairs, B+C and C+A; call these Attribute 
Relationships ""Left"" and ""Right"".  There is a third Attribute Relationship, 
A+B, we can refer to as ""Center"".

Then for each Property pair in Center that is matched, the following 3-way 
relationship must always hold for a fully-constrained puzzle:  If Property 
A[i] x B[j] is matched, then for each k in the set {1..N} for N Properties 
per Attribute, A[i] x C[k] == C[k] x B[j].

Which means, if the state A[i] x C[k] does *not* equal C[k] x B[j], then 
we have two possible cases: The first is if one of these mis-matched states 
is ""unknown""; in this case, the ""unknown"" state can be modified to match 
the other state (which is necessarily known to be either ""matched"" or 
""excluded"").

The second case is where one state is ""matched"" and the other is ""excluded""; 
this indicates an inconsistency in the rules of the puzzle, and no solution 
is therefore possible.

It should be noted that for each triplet set of Attributes, 3 of these 
""Relationship Trios"" described above can be created and analyzed, with each 
of the 3 Attributes serving as the ""common"" Attribute in turn.

In the case where we have M Attributes, we end up with C(M,3) Attribute 
triplets, which then lead to creating 3*C(M,3), or (M-2)*C(M,2) Relationship 
Trios.  For a puzzle with 6 Attributes, we will end up with 3*20, or 4*15,
which is 60 Relationship Trios to be analyzed.

And as with the deductions discussed earlier, any modification made to any 
Attribute Relationship in the course of analyzing Relationship Trios means 
that the matched & excluded deduction analyses must be repeated until no 
modifications have been made by earlier analyses.

Additional advanced algorithms have yet to be developed and added to the 
application...
"
Class {
	#name : #LogicPuzzle,
	#superclass : #Object,
	#instVars : [
		'primaryAttribute',
		'attributeDatabase'
	],
	#category : #'LogicPuzzle-Base'
}

{ #category : #creating }
LogicPuzzle >> addAttribute: attributeName withProperties: propertyNameSet [
	"Create a new Attribute and add it to the puzzle attribute dictionary."
	
	attributeDatabase addAttribute: attributeName withProperties: propertyNameSet 
]

{ #category : #inferencing }
LogicPuzzle >> analyzeRelationships [ 
	"Perform an analysis pass on the current relationship states."
	
	attributeDatabase analyzeRelationships 
]

{ #category : #accessing }
LogicPuzzle >> attributeDatabase [
	^ attributeDatabase
]

{ #category : #creating }
LogicPuzzle >> createRelationships [
	"Tell the attribute database to get busy..."
	
	^ attributeDatabase createRelationships
]

{ #category : #initialization }
LogicPuzzle >> initialize [
	"Initialize my collections and constraints."

	super initialize.
	
	attributeDatabase := LPAttributeDatabase new
]

{ #category : #accessing }
LogicPuzzle >> primaryAttribute [
	^ attributeDatabase primaryAttribute
]

{ #category : #accessing }
LogicPuzzle >> primaryAttribute: attributeOrName [
	
	^ attributeDatabase primaryAttribute: attributeOrName 
]

{ #category : #lookup }
LogicPuzzle >> relationshipOf: propertyOrNameOne with: propertyOrNameTwo [
	"Get the relationship between the two Properties."

	^ (attributeDatabase
			propertyRelationshipFor: propertyOrNameOne
			with: propertyOrNameTwo) 
		relationshipState printString
]

{ #category : #lookup }
LogicPuzzle >> relationshipOf: propertyOrNameOne with: propertyOrNameTwo is: relationship [
	"Set the relationship between the two Properties."
	
	| relationshipState |
	relationshipState := self stateNameToClass: relationship.

	"Setting a Property Relationship returns the relationship."
	^ attributeDatabase
		propertyRelationshipFor: propertyOrNameOne
		with: propertyOrNameTwo
		is: relationshipState
]

{ #category : #reporting }
LogicPuzzle >> renderAllRelationships [
	"Render arr AttributeRelationship as a string for display."
	
	^ attributeDatabase renderAllRelationships
]

{ #category : #reporting }
LogicPuzzle >> renderRelationshipOf: attributeOrNameOne with: attributeOrNameTwo [
	"Render an AttributeRelationship into a string for display."
	
	^ attributeDatabase 
		renderRelationshipOf: attributeOrNameOne 
		with: attributeOrNameTwo
]

{ #category : #lookup }
LogicPuzzle >> stateNameToClass: relationshipName [
	"Validate & convert a text reference to a RelationshipState."
	
	| relationship |
	relationship := attributeDatabase validateName: relationshipName.
	
	^ LPRelationshipState stateNameToClass: relationship 
]
