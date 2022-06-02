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
	runner := TestRunner2 new suitePreparator: ShuffleSuitePreparator.
]

{ #category : #tests }
RunnerTest >> testFailedTestFaildWhileRerunningDoesNotChangeTheResult [

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

	self deny: runner hasTestsToRun
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithGreenTest [

	runner run: GreenTest.
	self assert: runner passedCount equals: 2.

	self assert: runner failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testOnRunnerResultWithRedTest [
	
	runner run: RedTest.
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

	runner run: YellowTest.
	self assert: runner testsCount equals: 2.

	self assert: runner passedCount equals: 1.

	self assert: runner failureCount equals: 1
]

{ #category : #tests }
RunnerTest >> testRerunningFailedTest [

	"we will run a test who fail only during the first execution"

	"first execution"

	runner run: FailThenPass.
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

	runner run: RedTest.
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
	runner run: GreenTest. "2 tests"
	firstRunningCount := runner runCount.

	runner run: YellowTest. "2 tests"
	secondRunningCount := runner runCount.
	self assert: secondRunningCount equals: firstRunningCount + 2
]

{ #category : #tests }
RunnerTest >> testRunnerDoesNotAccumulateRsultByDefault [

	| firstRunningCount secondRunningCount |
	firstRunningCount := (runner run: GreenTest) runCount.

	secondRunningCount := (runner run: GreenTest) runCount.
	self assert: secondRunningCount equals: firstRunningCount
]

{ #category : #tests }
RunnerTest >> testRunningACollectionOfTestCases [

	"first execution"

	runner runCases: { 
			GreenTest.
			YellowTest }.
	self assert: runner runCount equals: 4.
	self assert: runner passedCount equals: 3
]

{ #category : #tests }
RunnerTest >> testRunningACollectionOfTestCasesWithSomeAbstractClass [

	runner runCases: { 
			AthensCairoExportSurfaceTest.
			AthensCairoPDFSurfaceTest.
			AthensCairoSVGSurfaceTest }.

	self assert: runner runCount equals: 8
]

{ #category : #tests }
RunnerTest >> testRunningAnEmptyCollectionOfTestCases [

	"first execution"

	runner runCases: {  }.
	self assert: runner runCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRunningFromAnEmptyCollectionOfPackages [

	"first execution"

	| packages |
	packages := OrderedCollection new.
	runner runPackages: packages.
	self assert: runner runCount equals: 0.
	self assert: runner passedCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRunningTestClassSide [

	TestRunner2 run: GreenTest.
	self assert: (TestRunner2 run: GreenTest) passedCount equals: 2.

	self assert: (TestRunner2 run: GreenTest) failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testRunningTestInstanceSide [

	runner run: GreenTest.
	self assert: runner passedCount equals: 2.

	self assert: runner failureCount equals: 0
]

{ #category : #tests }
RunnerTest >> testSuiteCreation [

	self assert: runner suites isEmpty.

	runner testSuiteFromClass: GreenTest.

	self deny: runner suitesTotal equals: 0
]

{ #category : #tests }
RunnerTest >> testSuiteWithMultipleTestCase [

	self assert: runner suites isEmpty.

	runner testSuitesFromClasses: { 
			GreenTest.
			YellowTest.
			RedTest }.
	self assert: runner suitesTotal equals: 3.
]

{ #category : #tests }
RunnerTest >> testSuitesFromANonTestCaseIsEmpty [

	TestRunner2 run: Integer.
	self deny: runner hasTestsToRun
]

{ #category : #tests }
RunnerTest >> testSuitesFromAnAbstractTestCaseIsEmpty [

	TestRunner2 run: AthensCairoExportSurfaceTest.
	self deny: runner hasTestsToRun
]
