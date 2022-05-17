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
CoverageRunnerTest >> testCoverageOn1ClassesAnd2Test [

	coverageRunner addTestCase: MyClassCovered50Test.
	coverageRunner addTestCase: MyClassCovered100Test.

	coverageRunner addClass: MyClassCovered100.

	coverageRunner run.
	self assert: coverageRunner coverage equals: 100
]

{ #category : #tests }
CoverageRunnerTest >> testCoverageOn1ClassesAnd2Test2 [

	coverageRunner addTestCase: MyClassCovered50Test.
	coverageRunner addTestCase: MyClassCovered100Test.

	coverageRunner addClass: MyClassCovered50.

	coverageRunner run.
	self assert: coverageRunner coverage equals: 50
]

{ #category : #tests }
CoverageRunnerTest >> testCoverageOn2ClassesAnd1Test [

	coverageRunner addTestCase: MyClassCovered100Test.

	coverageRunner addClass: MyClassCovered100.
	coverageRunner addClass: MyClassCovered50.

	coverageRunner run.
	self assert: coverageRunner coverage equals: 50
]

{ #category : #tests }
CoverageRunnerTest >> testCoverageOn2ClassesAnd1Test2 [

	coverageRunner addTestCase: MyClassCovered50Test.

	coverageRunner addClass: MyClassCovered100.
	coverageRunner addClass: MyClassCovered50.

	coverageRunner run.
	self assert: coverageRunner coverage equals: 25
]

{ #category : #tests }
CoverageRunnerTest >> testCoverageOn2ClassesAnd2Tests [

	coverageRunner addTestCase: MyClassCovered100Test.
	coverageRunner addTestCase: MyClassCovered50Test.

	coverageRunner addClass: MyClassCovered100.
	coverageRunner addClass: MyClassCovered50.

	coverageRunner run.
	self assert: coverageRunner coverage equals: 75
]

{ #category : #tests }
CoverageRunnerTest >> testOnClassCoveredHalf [

	coverageRunner addTestCase: MyClassCovered50Test.
	coverageRunner addClass: MyClassCovered50.
	coverageRunner run.
	self assert: coverageRunner coverage equals: 50
]

{ #category : #tests }
CoverageRunnerTest >> testOnClassFullyCovered [

	coverageRunner addTestCase: MyClassCovered100Test.
	coverageRunner addClass: MyClassCovered100.
	coverageRunner run.
	self assert: coverageRunner coverage equals: 100
]

{ #category : #tests }
CoverageRunnerTest >> testOnNotCoveredClass [

	coverageRunner addTestCase: MyClassCovered100Test.
	coverageRunner addClass: MyClassCovered50.
	coverageRunner run.
	self assert: coverageRunner coverage equals: 0
]

{ #category : #tests }
CoverageRunnerTest >> testOnNotCoveredClass2 [

	coverageRunner addTestCase: MyClassCovered50Test.
	coverageRunner addClass: MyClassCovered100.
	coverageRunner run.
	self assert: coverageRunner coverage equals: 0
]
