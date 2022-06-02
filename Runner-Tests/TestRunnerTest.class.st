Class {
	#name : #TestRunnerTest,
	#superclass : #BasicTestRunnerTest,
	#category : #'Runner-Tests-Core'
}

{ #category : #testing }
TestRunnerTest class >> shouldInheritSelectors [

	^ self == TestRunnerTest
]

{ #category : #tests }
TestRunnerTest >> classForRunner [

	^ TestRunner3
]

{ #category : #tests }
TestRunnerTest >> setUp [
	super setUp.
	runner := self classForRunner new suitePreparator: ShuffleSuitePreparator.
]

{ #category : #tests }
TestRunnerTest >> testRunnerCanAccumulateResult [

	| firstRunningCount secondRunningCount |
	runner accumulateResult.
	runner run: GreenTest. "2 tests"
	firstRunningCount := runner runCount.

	runner run: YellowTest. "2 tests"
	secondRunningCount := runner runCount.
	self assert: secondRunningCount equals: firstRunningCount + 2
]

{ #category : #tests }
TestRunnerTest >> testRunningACollectionOfTestCases [

	"first execution"

	runner runCases: { 
			GreenTest.
			YellowTest }.
	self assert: runner runCount equals: 4.
	self assert: runner passedCount equals: 3
]

{ #category : #tests }
TestRunnerTest >> testRunningACollectionOfTestCasesWithSomeAbstractClass [

	runner runCases: { 
			AthensCairoExportSurfaceTest.
			AthensCairoPDFSurfaceTest.
			AthensCairoSVGSurfaceTest }.

	self assert: runner runCount equals: 8
]

{ #category : #tests }
TestRunnerTest >> testRunningAnEmptyCollectionOfTestCases [

	"first execution"

	runner runCases: {  }.
	self assert: runner runCount equals: 0
]

{ #category : #tests }
TestRunnerTest >> testRunningFromAnEmptyCollectionOfPackages [

	"first execution"

	| packages |
	packages := OrderedCollection new.
	runner runPackages: packages.
	self assert: runner runCount equals: 0.
	self assert: runner passedCount equals: 0
]

{ #category : #tests }
TestRunnerTest >> testRunningTestClassSide [

	"/!\ check others ways to run tests in class side (packages, collection of tests) "

	self classForRunner run: GreenTest.
	self
		assert: (self classForRunner run: GreenTest) passedCount
		equals: 2.

	self
		assert: (self classForRunner run: GreenTest) failureCount
		equals: 0
]

{ #category : #tests }
TestRunnerTest >> testSuiteCreation [

	self assert: runner suites isEmpty.

	runner testSuiteFromClass: GreenTest.

	self deny: runner suitesTotal equals: 0
]

{ #category : #tests }
TestRunnerTest >> testSuiteWithMultipleTestCase [

	self assert: runner suites isEmpty.

	runner testSuitesFromClasses: { 
			GreenTest.
			YellowTest.
			RedTest }.
	self assert: runner suitesTotal equals: 3.
]
