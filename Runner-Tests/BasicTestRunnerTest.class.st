Class {
	#name : #BasicTestRunnerTest,
	#superclass : #TestCase,
	#instVars : [
		'runner'
	],
	#category : #'Runner-Tests-Core'
}

{ #category : #tests }
BasicTestRunnerTest >> classForRunner [

	^ BasicTestRunner
]

{ #category : #running }
BasicTestRunnerTest >> setUp [

	super setUp.
	runner := self classForRunner new
]

{ #category : #tests }
BasicTestRunnerTest >> testDefaultSuitePreparatorOfTheRunner [

	self assert: runner suitePreparator equals: ShuffleSuitePreparator
]

{ #category : #tests }
BasicTestRunnerTest >> testFailedTestFaildWhileRerunningDoesNotChangeTheResult [

	"first execution"
	
	runner run: YellowTest.
	self assert: runner runCount equals: 2.
	self assert: runner failureCount equals: 1.

	"second execution"
	runner runFailures.
	self assert: runner runCount equals: 2.
	self assert: runner failureCount equals: 1
]

{ #category : #tests }
BasicTestRunnerTest >> testGivingTestToTheRunner [

	"test that a runner has initialy any test to run.
	That ensure it runs only tests added by user.
	"

	runner testSuiteFromClass: ExampleSetTest.
	self assert: runner hasTestsToRun
]

{ #category : #tests }
BasicTestRunnerTest >> testNewCreatedRunnerHasAnyTestsToRun [

	"test that a runner has initialy any test to run.
	that ensure when running a tests that the result contain
	only the tests added by user.
	"

	self deny: runner hasTestsToRun
]

{ #category : #tests }
BasicTestRunnerTest >> testOnRunnerResultWithGreenTest [

	runner run: GreenTest.
	self assert: runner passedCount equals: 2.

	self assert: runner failureCount equals: 0
]

{ #category : #tests }
BasicTestRunnerTest >> testOnRunnerResultWithRedTest [

	runner run: RedTest.

	self assert: runner passedCount equals: 1.

	self assert: runner failureCount equals: 1.

	self assert: runner errorCount equals: 1
]

{ #category : #tests }
BasicTestRunnerTest >> testOnRunnerResultWithYellowTest [

	runner run: YellowTest.

	self assert: runner passedCount equals: 1.

	self assert: runner failureCount equals: 1
]

{ #category : #tests }
BasicTestRunnerTest >> testRunnerDoesNotAccumulateRsult [

	| firstRunningCount secondRunningCount |
	firstRunningCount := (runner run: GreenTest) runCount.

	secondRunningCount := (runner run: GreenTest) runCount.
	self assert: secondRunningCount equals: firstRunningCount
]

{ #category : #tests }
BasicTestRunnerTest >> testRunningTestClassSide [

	self
		assert: (self classForRunner run: GreenTest) passedCount
		equals: 2.

	self
		assert: (self classForRunner run: GreenTest) failureCount
		equals: 0
]

{ #category : #tests }
BasicTestRunnerTest >> testSuitesFromANonTestCaseIsEmpty [

	self classForRunner run: Integer.
	self deny: runner hasTestsToRun
]

{ #category : #tests }
BasicTestRunnerTest >> testSuitesFromAnAbstractTestCaseIsEmpty [

	self classForRunner run: AthensCairoExportSurfaceTest.
	self deny: runner hasTestsToRun
]
