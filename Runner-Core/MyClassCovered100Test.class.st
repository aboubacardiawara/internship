Class {
	#name : #MyClassCovered100Test,
	#superclass : #TestCase,
	#instVars : [
		'aMyClassCovered100'
	],
	#category : #'Runner-Core-Utilities-Test'
}

{ #category : #initialization }
MyClassCovered100Test >> setUp [
	super setUp.
	aMyClassCovered100 := MyClassCovered100 new.
	
]

{ #category : #tests }
MyClassCovered100Test >> testCoveredMethod [
	
	self assert: aMyClassCovered100 coveredMethod.
]

{ #category : #tests }
MyClassCovered100Test >> testOtherCoveredMethod [
	
	self assert: aMyClassCovered100 anotherCoveredMethod
]
