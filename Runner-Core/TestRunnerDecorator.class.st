Class {
	#name : #TestRunnerDecorator,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result',
		'suitePreparator',
		'shouldAccumulate',
		'runner',
		'currentTest',
		'currentResult'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #running }
TestRunnerDecorator class >> example [
	<script>
	self new 
	suitePreparator: ShuffleSuitePreparator;
	run: DependencyTest;
	inspect
]

{ #category : #running }
TestRunnerDecorator class >> run: aTestCase [
	^ self new
		run: aTestCase
]

{ #category : #processing }
TestRunnerDecorator >> accumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: true
]

{ #category : #accessing }
TestRunnerDecorator >> debugFailure: failure [

	self runner debugFailure: failure
]

{ #category : #accessing }
TestRunnerDecorator >> defaultRunner [

	^ BasicTestRunner new
]

{ #category : #running }
TestRunnerDecorator >> defaultTestResultClass [

	^ TestResult
]

{ #category : #accessing }
TestRunnerDecorator >> doNotAccumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: false
]

{ #category : #accessing }
TestRunnerDecorator >> errorCount [

	^ result errorCount
]

{ #category : #accessing }
TestRunnerDecorator >> failureCount [

	^ self result failureCount
]

{ #category : #testing }
TestRunnerDecorator >> hasTestsToRun [

	"check either the runner has test to run or not.
	If any test has not been added, there nothing to run"

	"Example of usages:"

	"TestRunnerDecorator new hasTestsToRun >>> false
	TestRunnerDecorator new testSuiteFromClass: GreenTest; hasTestsToRun >>> true"

	^ self suites isNotEmpty
]

{ #category : #initialization }
TestRunnerDecorator >> initialize [

	super initialize.
	self doNotAccumulateResult
]

{ #category : #accessing }
TestRunnerDecorator >> passedCount [

	^ self result passedCount
]

{ #category : #running }
TestRunnerDecorator >> resetResult [

	"reset the runner result"

	result := self defaultTestResultClass new
]

{ #category : #accessing }
TestRunnerDecorator >> result [

	^ result ifNil: [ result := self defaultTestResultClass new]
]

{ #category : #running }
TestRunnerDecorator >> run: aTestCase [

	currentTest := aTestCase.
	self shouldAccumulate ifFalse: [ self resetResult ].
	currentResult := self runner run: aTestCase.

	^ result := self result + currentResult
]

{ #category : #running }
TestRunnerDecorator >> runAll: aCollectionOfTestCases [

	self accumulateResult.
	aCollectionOfTestCases do: [ :class | 
		class isAbstract ifFalse: [ self run: class ] ].
	^ result
]

{ #category : #accessing }
TestRunnerDecorator >> runCount [

	^ self result runCount
]

{ #category : #running }
TestRunnerDecorator >> runFailure: aTestCase [

	| rerunningResult |
	rerunningResult := self runner runCase: aTestCase.
	rerunningResult hasPassed ifTrue: [ result removeFailure: aTestCase ].
	self updateResultWith: rerunningResult
]

{ #category : #running }
TestRunnerDecorator >> runFailures [

	result failures do: [ :testCase | self runFailure: testCase ]
]

{ #category : #runninh }
TestRunnerDecorator >> runPackage: aRPackage [

	self runAll:
		(aRPackage definedClasses reject: [ :class | class isAbstract ])
]

{ #category : #running }
TestRunnerDecorator >> runPackages: aCollection [

	aCollection do: [ :package | self runPackage: package ]
]

{ #category : #running }
TestRunnerDecorator >> runSuite: aTestSuite [

	currentResult := self executionMode executeSuite: aTestSuite.
	result := result + currentResult
]

{ #category : #running }
TestRunnerDecorator >> runTestsSuites [

	"execute all every collected suite"

	self defaultExecutionEnvironmentClass runTestsBy: [ 
		self suites do: [ :testSuite | self runSuite: testSuite ] ]
]

{ #category : #accessing }
TestRunnerDecorator >> runner [
	 ^ runner ifNil: [ runner := self defaultRunner ]
]

{ #category : #accessing }
TestRunnerDecorator >> runner: aRunner [

	runner := aRunner
]

{ #category : #processing }
TestRunnerDecorator >> setUp [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	self suitePreparator applyOnSuites: suites
]

{ #category : #tests }
TestRunnerDecorator >> shouldAccumulate [

	^ shouldAccumulate
]

{ #category : #asserting }
TestRunnerDecorator >> shouldAccumulate: aBoolean [

	shouldAccumulate := aBoolean
]

{ #category : #accessing }
TestRunnerDecorator >> someTestCausesError [

	^ result hasErrors
]

{ #category : #accessing }
TestRunnerDecorator >> someTestFailed [

	^ self result hasFailures
]

{ #category : #accessing }
TestRunnerDecorator >> suitePreparator [

	^ suitePreparator ifNil: [ 
		  suitePreparator := self defaultSuitePreparator ]
]

{ #category : #adding }
TestRunnerDecorator >> suitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
]

{ #category : #'instance creation' }
TestRunnerDecorator >> suites [

	^ suites ifNil: [ suites := OrderedCollection new ]
]

{ #category : #counting }
TestRunnerDecorator >> suitesTotal [

	^ suites size
]

{ #category : #running }
TestRunnerDecorator >> switchToDebugMode [

	self runner switchToDebugMode
]

{ #category : #running }
TestRunnerDecorator >> switchToRunMode [

	self runner switchToRunMode
]

{ #category : #running }
TestRunnerDecorator >> tearDown [

	self resetSuites
]

{ #category : #tests }
TestRunnerDecorator >> testSuiteFromClass: aClass [

	"build a suite from the giving class then add it to the internal collections of suites. 
	The giving class should be a test case"

	(aClass isTestCase and: aClass isAbstract not) ifTrue: [ 
		self suites add: aClass suite ]
]

{ #category : #tests }
TestRunnerDecorator >> testSuitesFromClasses: aColOfTestCase [

	"build a collection of TestSuite and save it"

	aColOfTestCase do: [ :class | self testSuiteFromClass: class ]
]

{ #category : #accessing }
TestRunnerDecorator >> testsCount [

	"return the number of all tests methods from suites"

	^ self result tests size
]

{ #category : #tests }
TestRunnerDecorator >> updateResultWith: testResult [

	"updtade the current test result then return it"

	self result + testResult.
	^ result
]
