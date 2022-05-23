Class {
	#name : #ParametrizedTestCaseCopy,
	#superclass : #TestCaseCopy,
	#instVars : [
		'parametersToUse'
	],
	#category : #ParametrizedTests2
}

{ #category : #'building suites' }
ParametrizedTestCaseCopy class >> buildSuite [

	| expandedMatrix suite |
	
	expandedMatrix := self testParameters expandMatrix.

	expandedMatrix ifEmpty: [ ^ self buildSuiteFromSelectors].

	suite := self suiteClass named: self name.
	expandedMatrix do: [ :expandedParameters | |internalSuite|
		internalSuite := self buildSuiteFromSelectors.
		internalSuite tests do: [ :aTest | aTest parametersToUse: expandedParameters ].
		suite addTests: internalSuite tests.
	].

	^ suite
]

{ #category : #private }
ParametrizedTestCaseCopy class >> isAbstract [
	^ self name = #ParametrizedTestCaseCopy
]

{ #category : #'building suites' }
ParametrizedTestCaseCopy class >> testParameters [
	"I'm the main hook to define configuration.
	See addCase and forSelector:addOptions: on ParametrizedTestMatrix."
	
	^ ParametrizedTestMatrixCopy new
]

{ #category : #private }
ParametrizedTestCaseCopy >> instanceVariablesToKeep [

	^ super instanceVariablesToKeep, #('testSelector' 'parametersToUse')
]

{ #category : #accessing }
ParametrizedTestCaseCopy >> nameForReport [

	parametersToUse ifNil: [ ^ super nameForReport ].

	^ String streamContents: [ :s |
		s nextPutAll: self selector asString.
		parametersToUse printElementsOn: s ]
]

{ #category : #accessing }
ParametrizedTestCaseCopy >> parametersToUse [
	^ parametersToUse ifNil: [#()]
]

{ #category : #accessing }
ParametrizedTestCaseCopy >> parametersToUse: anObject [
	parametersToUse := anObject
]

{ #category : #printing }
ParametrizedTestCaseCopy >> printOn: aStream [

	super printOn: aStream.
	parametersToUse ifNotNil: [ parametersToUse printElementsOn: aStream.]
]

{ #category : #running }
ParametrizedTestCaseCopy >> setUp [
	super setUp.
	self parametersToUse do: [ :aParameter | aParameter applyTo: self ].
	
	"If I am executed without calling buildSuite in the class. I will use the first set of options.
	This is a workaround to work when running from Calypso"
	(self parametersToUse isEmpty and: [self class testParameters isNotEmpty]) 
		ifTrue: [ 
				self class 
						testParameters expandMatrix first 
						do: [ :aParameter | aParameter applyTo: self ] ]
]
