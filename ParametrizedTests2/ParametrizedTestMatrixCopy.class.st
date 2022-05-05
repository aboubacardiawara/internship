Class {
	#name : #ParametrizedTestMatrixCopy,
	#superclass : #Object,
	#instVars : [
		'selector',
		'options',
		'cases'
	],
	#category : #ParametrizedTests2
}

{ #category : #combination }
ParametrizedTestMatrixCopy >> * aParametrizedTestMatrix [ 

	| newMatrix |
	newMatrix := ParametrizedTestMatrixCopy new.
	self expandMatrix do: [ :subcase1 |
		aParametrizedTestMatrix asTestMatrix expandMatrix do: [ :subcase2 |
			newMatrix addCase: subcase1, subcase2  ] ].
	^ newMatrix
]

{ #category : #comparing }
ParametrizedTestMatrixCopy >> = aMatrix [

	^ self expandMatrix = aMatrix expandMatrix
]

{ #category : #cases }
ParametrizedTestMatrixCopy >> addCase: aCollection [
	"Declare a specific configuration of parameters. See forSelector:addOptions: for matrix combinations."
	
	cases add: (aCollection
		collect: [ :assoc | assoc asTestParameter ]
		as: Array).
		
	^ self
]

{ #category : #converting }
ParametrizedTestMatrixCopy >> asTestMatrix [

	^ self
]

{ #category : #generating }
ParametrizedTestMatrixCopy >> combinationsOf: aCollection [ 
	
	| first expandedParameters inner |
	aCollection ifEmpty: [ ^ #() ].
	
	first := aCollection first.
	expandedParameters := first expand.
	
	inner := self combinationsOf: aCollection allButFirst.
	inner ifEmpty: [ ^ expandedParameters collect: [ :each | { each } ] ].
	
	^ expandedParameters flatCollect: [ :aParameter | inner collect:[:aCase | {aParameter} , aCase ] ]
]

{ #category : #expanding }
ParametrizedTestMatrixCopy >> expandMatrix [
	| combinations |
	combinations := self combinationsOf: self options.
	combinations ifEmpty: [ ^ cases ].
	cases ifEmpty: [ ^ combinations ].
	^ combinations flatCollect: [ :aCase | cases collect: [ :each | aCase , each ] ]
]

{ #category : #addingOptions }
ParametrizedTestMatrixCopy >> forSelector: aSelector addOptions: someOptions [
	"Declare all possible values for a given parameter expressed via a message send aSelector."
	
	options
		add:
			(ParametrizedTestOptionCopy new
				selector: aSelector;
				values: someOptions;
				yourself)
]

{ #category : #comparing }
ParametrizedTestMatrixCopy >> hash [

	^ self expandMatrix hash
]

{ #category : #initialization }
ParametrizedTestMatrixCopy >> initialize [
	super initialize.
	options := OrderedCollection new.
	cases := OrderedCollection new
]

{ #category : #testing }
ParametrizedTestMatrixCopy >> isEmpty [
	
	^ options isEmpty and: [ cases isEmpty ]
]

{ #category : #testing }
ParametrizedTestMatrixCopy >> isNotEmpty [
	
	^ self isEmpty not
]

{ #category : #accessing }
ParametrizedTestMatrixCopy >> options [
	^ options
]

{ #category : #accessing }
ParametrizedTestMatrixCopy >> selector [
	^ selector
]

{ #category : #accessing }
ParametrizedTestMatrixCopy >> selector: aString [ 
	selector := aString
]

{ #category : #accessing }
ParametrizedTestMatrixCopy >> values: aCollection [ 
	options := aCollection collect:[ :aValue | 
		ParametrizedTestExpandedParameterCopy new 
			parameter: self; 
			valuable: aValue;
			yourself]
]
