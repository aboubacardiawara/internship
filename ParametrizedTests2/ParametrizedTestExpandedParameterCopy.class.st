Class {
	#name : #ParametrizedTestExpandedParameterCopy,
	#superclass : #Object,
	#instVars : [
		'selector',
		'valuable'
	],
	#category : #ParametrizedTests2
}

{ #category : #comparing }
ParametrizedTestExpandedParameterCopy >> = anOption [

	^ self selector = anOption selector
		and: [ self valuable = anOption valuable ]
]

{ #category : #applying }
ParametrizedTestExpandedParameterCopy >> applyTo: aTest [

	| anObject |
	anObject := self valuable isBlock
		ifTrue: [ self valuable cull: aTest ]
		ifFalse: [ self valuable ].

	aTest perform: selector asMutator with: anObject
]

{ #category : #converting }
ParametrizedTestExpandedParameterCopy >> asTestParameter [

	^ self
]

{ #category : #comparing }
ParametrizedTestExpandedParameterCopy >> hash [

	^ self selector hash + self valuable hash
]

{ #category : #accessing }
ParametrizedTestExpandedParameterCopy >> key [
	self shouldBeImplemented.
]

{ #category : #printing }
ParametrizedTestExpandedParameterCopy >> printOn: aStream [
	aStream print: (selector -> valuable)
]

{ #category : #accessing }
ParametrizedTestExpandedParameterCopy >> selector [
	^ selector
]

{ #category : #accessing }
ParametrizedTestExpandedParameterCopy >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
ParametrizedTestExpandedParameterCopy >> suiteName [
	^ selector , ' -> ' , valuable printString
]

{ #category : #accessing }
ParametrizedTestExpandedParameterCopy >> valuable [
	^ valuable
]

{ #category : #accessing }
ParametrizedTestExpandedParameterCopy >> valuable: aValuable [ 
	valuable := aValuable
]
