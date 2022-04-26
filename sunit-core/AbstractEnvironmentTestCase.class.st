Class {
	#name : #AbstractEnvironmentTestCase,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'testingEnvironment'
	],
	#category : #'SUnit-Core-Kernel'
}

{ #category : #testing }
AbstractEnvironmentTestCase class >> isAbstract [

	^self = AbstractEnvironmentTestCase
]

{ #category : #tests }
AbstractEnvironmentTestCase class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase: {  };
		yourself 
]

{ #category : #accessing }
AbstractEnvironmentTestCase >> environmentOfTest [
	^ testingEnvironment
]

{ #category : #running }
AbstractEnvironmentTestCase >> setUp [
	super setUp.
	testingEnvironment := Smalltalk globals.
]

{ #category : #accessing }
AbstractEnvironmentTestCase >> testingEnvironment: anObject [
	testingEnvironment := anObject
]
