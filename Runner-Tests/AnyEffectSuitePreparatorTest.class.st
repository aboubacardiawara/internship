Class {
	#name : #AnyEffectSuitePreparatorTest,
	#superclass : #TestCaseCopy,
	#instVars : [
		'runner'
	],
	#category : #'Runner-Tests-Preparators'
}

{ #category : #tests }
AnyEffectSuitePreparatorTest >> testSuitePreparator [
	
	|initialSuite initialSuiteCopy|
	initialSuite := GreenTest suite.
	initialSuiteCopy := initialSuite copy.
	self 
		assert: initialSuiteCopy tests
		equals: initialSuite tests.
	
	AnyEffectSuitePreparator applyOn: initialSuite.
	
	self 
		assert: initialSuiteCopy tests
		equals: initialSuite tests.
]
