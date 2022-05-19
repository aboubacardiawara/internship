Class {
	#name : #RunnerTest,
	#superclass : #TestCase,
	#instVars : [
		'runner'
	],
	#category : #'Runner-Tests-Core'
}

{ #category : #tests }
RunnerTest >> setUp [
	super setUp.
	runner := Runner new suitePreparator: ShuffleSuitePreparator.
]

{ #category : #tests }
RunnerTest >> testFailedTestFaildWhileRerunningDoesNotChangeTheResult [

	| firstRunningResult secondRunningResult |
	"first execution"
	firstRunningResult := runner runCase: YellowTest.
	self assert: firstRunningResult runCount equals: 2.
	self assert: firstRunningResult failureCount equals: 1.

	"second execution"
	runner runFailures.
	secondRunningResult := runner result.
	self assert: secondRunningResult runCount equals: 2.
	self assert: secondRunningResult failureCount equals: 1.
]

{ #category : #tests }
RunnerTest >> testGivingANonTestcaseDoesNotThrowsException [

	self
		shouldnt: (Runner runCase: GreenTest)
		raise: ANoTestCaseException
]

{ #category : #tests }
RunnerTest >> testGivingANonTestcaseThrowsException [

	self
		should: [Runner new runCase: Integer]
		raise: ANoTestCaseException
]

{ #category : #tests }
RunnerTest >> testGivingTestToTheRunner [

	"test that a runner has initialy any test to run.
	That ensure it runs only tests added by user.
	"

	runner testSuiteFromClass: ExampleSetTest.
	self assert: runner hasTestsToRun
]

{ #category : #tests }
RunnerTest >> testNewCreatedRunnerHasAnyTestsToRun [

	"test that a runner has initialy any test to run.
	that ensure when running a tests that the result contain
	only the tests added by user.
	"

	runner := Runner new.
	self deny: runner hasTestsToRun
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithGreenTest [

	| result |
	result := runner runCase: GreenTest.
	self assert: result passedCount equals: 2.

	self assert: result failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithRedTest [
	|result|
	result := runner runCase: RedTest.
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

	| result |
	result := runner runCase: YellowTest.
	self assert: result tests size equals: 2.

	self assert: result passedCount equals: 1.

	self assert: result failureCount equals: 1
]

{ #category : #tests }
RunnerTest >> testRerunningFailedTest [

	"we will run a test who fail only during the first execution"

	| firstRunningResult secondRunningResult |
	"first execution"
	firstRunningResult := runner runCase: FailThenPass.
	self assert: firstRunningResult runCount equals: 2.
	self assert: firstRunningResult failureCount equals: 1.

	"second execution"
	runner runFailures.
	secondRunningResult := runner result.
	self assert: secondRunningResult runCount equals: 2.
	self assert: secondRunningResult failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRerunningFailedTest2 [

	"we will run a test who fail only during the first execution"

	| firstRunningResult secondRunningResult |
	"first execution"
	firstRunningResult := runner runCase: RedTest.
	self assert: firstRunningResult runCount equals: 3.
	self assert: firstRunningResult failureCount equals: 1.
	self assert: firstRunningResult errorCount equals: 1.

	"second execution"
	runner runFailures.
	secondRunningResult := runner result.
	self assert: secondRunningResult runCount equals: 3.
	self assert: secondRunningResult failureCount equals: 1.
	self assert: secondRunningResult errorCount equals: 1
]

{ #category : #tests }
RunnerTest >> testRunnerCanAccumulateResult [

	| result firstRunningCount secondRunningCount |
	runner accumulateResult.
	result := runner runCase: GreenTest. "2 tests"
	firstRunningCount := result runCount.

	result := runner runCase: YellowTest. "2 tests"
	secondRunningCount := result runCount.
	self assert: secondRunningCount equals: firstRunningCount + 2
]

{ #category : #tests }
RunnerTest >> testRunnerDoesNotAccumulateRsultByDefault [

	| result firstRunningCount secondRunningCount |
	result := Runner runCase: GreenTest.
	firstRunningCount := result runCount.

	result := Runner runCase: GreenTest.
	secondRunningCount := result runCount.
	self assert: secondRunningCount equals: firstRunningCount
]

{ #category : #tests }
RunnerTest >> testRunningTestClassSide [
	| result |
	result := Runner runCase: GreenTest.
	self assert: result passedCount equals: 2.

	self assert: result failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRunningTestInstanceSide [
	| result |
	result := runner runCase: GreenTest.
	self assert: result passedCount equals: 2.

	self assert: result failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testSuiteCreation [

	self assert: runner suites isEmpty.
	
	runner testSuiteFromClass: GreenTest.
	
	self deny: runner suites isEmpty.
]

{ #category : #tests }
RunnerTest >> testSuiteWithMultipleTestCase [

	self assert: runner suites isEmpty.

	runner testSuitesFromClasses: { 
			GreenTest.
			YellowTest.
			RedTest }.
	self assert: runner suites size equals: 3.
	self assert: runner testsCount equals: 2 + 2 + 3
]
