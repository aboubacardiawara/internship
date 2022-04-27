Class {
	#name : #RunnerTest,
	#superclass : #TestCase,
	#instVars : [
		'runner'
	],
	#category : #'Runner-Tests'
}

{ #category : #tests }
RunnerTest >> setUp [
	super setUp.
	runner := Runner new.
]

{ #category : #tests }
RunnerTest >> testGivingTestToTheRunner [
	"test that a runner has initialy any test to run.
	That ensure it runs only tests added by user.
	"
	
	runner testSuiteFromClass: ExampleSetTest.
	self assert: runner hasTestsToRun.
]

{ #category : #tests }
RunnerTest >> testNewCreatedRunnerHasAnyTestsToRun [
	"test that a runner has initialy any test to run.
	that ensure when running a tests that the result contain
	only the user tests stats.
	"
	runner := Runner new.
	self deny: runner hasTestsToRun.
]

{ #category : #tests }
RunnerTest >> testOnCoverage [
	|uncoveredClass coveredClass|
	uncoveredClass := MyClassCovered50 new.
	coveredClass := MyClassCovered100 new.
	
	self halt. 
	"Is it possible to determine the coverage rate 
	with any precision on some tests"
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithGreenTest [
	|result|
	
	runner testSuiteFromClass: GreenTest.
	result := runner run.
	self 
		assert: result passedCount 
		equals: 2.

	self 
		assert: result failureCount 
		equals: 0.
	
	
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithRedTest [
	|result|
	
	runner testSuiteFromClass: RedTest.
	result := runner run.
	self
		assert: result tests size
		equals: 3.
	
	self
		assert: result passedCount 
		equals: 1.

	self 
		assert: result failureCount 
		equals: 1.

	self 
		assert: result errorCount
		equals: 1.
	
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithYellowTest [
	|result|
	
	runner testSuiteFromClass: YellowTest.
	result := runner run.
	self 
		assert: result tests size
		equals: 2.
		
	self 
		assert: result passedCount 
		equals: 1.

	self 
		assert: result failureCount 
		equals: 1.
	
	
]

{ #category : #tests }
RunnerTest >> testSuiteCreation [

	self assert: runner suites isEmpty.
	
	runner testSuiteFromClass: GreenTest.
	
	self deny: runner suites isEmpty.
]

{ #category : #tests }
RunnerTest >> testSuitePreparator [
	
	self halt.
	"move this kind of test in every suitePreparator"
	runner testSuitesFromClasses: { GreenTest. YellowTest. RedTest }
	
	
]

{ #category : #tests }
RunnerTest >> testSuiteWithMultipleTestCase [
	self assert: runner suites isEmpty.
	
	runner testSuitesFromClasses: (OrderedCollection withAll: {GreenTest. YellowTest. RedTest}).
	self assert: runner suites size equals: 3.
	self assert: runner testsCount equals: 2+2+3.
]
