Class {
	#name : #CoverageRunnerTest,
	#superclass : #TestCase,
	#instVars : [
		'coverageRunner'
	],
	#category : #'Runner-Tests-Core'
}

{ #category : #running }
CoverageRunnerTest >> setUp [
	super setUp.
	coverageRunner := CoverageRunner new
]

{ #category : #tests }
CoverageRunnerTest >> testCoverageOnPackage [

	self assert: false description: 'Not implemented yet'
]

{ #category : #tests }
CoverageRunnerTest >> testOnClassCoveredHalf [

	coverageRunner addTestCase: MyClassCovered50Test.
	coverageRunner addClass: MyClassCovered50.
	self assert: coverageRunner coverage equals: 50
]

{ #category : #tests }
CoverageRunnerTest >> testOnClassFullyCovered [

	coverageRunner addTestCase: MyClassCovered100Test.
	coverageRunner addClass: MyClassCovered100.
	self assert: coverageRunner coverage equals: 100
]

{ #category : #tests }
CoverageRunnerTest >> testOnNotCoveredClass [

	coverageRunner addTestCase: MyClassCovered100Test.
	coverageRunner addClass: MyClassCovered50.
	self assert: coverageRunner coverage equals: 0
]

{ #category : #tests }
CoverageRunnerTest >> testOnNotCoveredClass2 [

	coverageRunner addTestCase: MyClassCovered50Test.
	coverageRunner addClass: MyClassCovered100.
	self assert: coverageRunner coverage equals: 0
]
