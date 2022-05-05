Class {
	#name : #AbstractEnvironmentTestCaseCopy,
	#superclass : #TestCaseCopy,
	#instVars : [
		'testingEnvironment'
	],
	#category : #'SUnit-Core2'
}

{ #category : #testing }
AbstractEnvironmentTestCaseCopy class >> isAbstract [

	^self = AbstractEnvironmentTestCase
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
