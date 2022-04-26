Class {
	#name : #AbstractEnvironmentTestCaseCopy,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'testingEnvironment'
	],
	#category : #'SUnit-Core2'
}

{ #category : #testing }
AbstractEnvironmentTestCaseCopy class >> isAbstract [

	^self = AbstractEnvironmentTestCaseCopy
]

{ #category : #tests }
AbstractEnvironmentTestCaseCopy class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase: {  };
		yourself 
]

{ #category : #accessing }
AbstractEnvironmentTestCaseCopy >> environmentOfTest [
	^ testingEnvironment
]

{ #category : #running }
AbstractEnvironmentTestCaseCopy >> setUp [
	super setUp.
	testingEnvironment := Smalltalk globals.
]

{ #category : #accessing }
AbstractEnvironmentTestCaseCopy >> testingEnvironment: anObject [
	testingEnvironment := anObject
]
