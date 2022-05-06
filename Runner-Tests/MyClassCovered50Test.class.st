Class {
	#name : #MyClassCovered50Test,
	#superclass : #TestCase,
	#instVars : [
		'aMyClassCovered50'
	],
	#category : #'Runner-Tests-Utilities-Test'
}

{ #category : #running }
MyClassCovered50Test >> setUp [
	super setUp.
	
	aMyClassCovered50 := MyClassCovered50 new.
]

{ #category : #tests }
MyClassCovered50Test >> testCoveredMethod [
	
	self assert: aMyClassCovered50 coveredMethod.
]
