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

	"first execution"

	runner runCase: YellowTest.
	self assert: runner runCount equals: 2.
	self assert: runner failureCount equals: 1.

	"second execution"
	runner runFailures.
	self assert: runner runCount equals: 2.
	self assert: runner failureCount equals: 1
]

{ #category : #tests }
RunnerTest >> testGivingANonTestcaseThrowsException [

	self
		should: [Runner new runCase: Integer]
		raise: ANoTestCaseException
]

{ #category : #tests }
RunnerTest >> testGivingATestcaseDoesNotThrowsException [

	self
		shouldnt: (Runner runCase: GreenTest)
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

	runner runCase: GreenTest.
	self assert: runner passedCount equals: 2.

	self assert: runner failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithRedTest [
	
	runner runCase: RedTest.
	self
		assert: runner testsCount
		equals: 3.
	
	self
		assert: runner passedCount 
		equals: 1.

	self 
		assert: runner failureCount 
		equals: 1.

	self 
		assert: runner errorCount
		equals: 1.
	
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithYellowTest [

	runner runCase: YellowTest.
	self assert: runner testsCount equals: 2.

	self assert: runner passedCount equals: 1.

	self assert: runner failureCount equals: 1
]

{ #category : #tests }
RunnerTest >> testRerunningFailedTest [

	"we will run a test who fail only during the first execution"

	"first execution"

	runner runCase: FailThenPass.
	self assert: runner runCount equals: 2.
	self assert: runner failureCount equals: 1.

	"second execution"
	runner runFailures.
	runner result.
	self assert: runner runCount equals: 2.
	self assert: runner failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRerunningFailedTest2 [

	"we will run a test who fail only during the first execution"

	"first execution"

	runner runCase: RedTest.
	self assert: runner runCount equals: 3.
	self assert: runner failureCount equals: 1.
	self assert: runner errorCount equals: 1.

	"second execution"
	runner runFailures.
	runner result.
	self assert: runner runCount equals: 3.
	self assert: runner failureCount equals: 1.
	self assert: runner errorCount equals: 1
]

{ #category : #tests }
RunnerTest >> testRunnerCanAccumulateResult [

	| firstRunningCount secondRunningCount |
	runner accumulateResult.
	runner runCase: GreenTest. "2 tests"
	firstRunningCount := runner runCount.

	runner runCase: YellowTest. "2 tests"
	secondRunningCount := runner runCount.
	self assert: secondRunningCount equals: firstRunningCount + 2
]

{ #category : #tests }
RunnerTest >> testRunnerDoesNotAccumulateRsultByDefault [

	| firstRunningCount secondRunningCount |
	firstRunningCount := (Runner runCase: GreenTest) runCount.

	secondRunningCount := (Runner runCase: GreenTest) runCount.
	self assert: secondRunningCount equals: firstRunningCount
]

{ #category : #tests }
RunnerTest >> testRunningACollectionOfTestCases [

	"first execution"

	runner runCases: { GreenTest }.
	self assert: runner runCount equals: 2.
	self assert: runner passedCount equals: 2
]

{ #category : #tests }
RunnerTest >> testRunningAnEmptyCollectionOfTestCases [

	"first execution"

	runner runCases: {  }.
	self assert: runner runCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRunningTestClassSide [

	Runner runCase: GreenTest.
	self assert: (Runner runCase: GreenTest) passedCount equals: 2.

	self assert: (Runner runCase: GreenTest) failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRunningTestInstanceSide [

	runner runCase: GreenTest.
	self assert: runner passedCount equals: 2.

	self assert: runner failureCount equals: 0
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
]
