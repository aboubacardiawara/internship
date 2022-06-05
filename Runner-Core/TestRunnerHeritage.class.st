Class {
	#name : #TestRunnerHeritage,
	#superclass : #BasicTestRunner,
	#instVars : [
		'suites',
		'shouldAccumulate',
		'nextTest',
		'currentResult'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #running }
TestRunnerHeritage class >> example [
	<script>
	TestRunner2 new 
	suitePreparator: ShuffleSuitePreparator;
	run: DependencyTest;
	inspect
]

{ #category : #running }
TestRunnerHeritage class >> run: aTestCase [
	^ self new
		run: aTestCase
]

{ #category : #processing }
TestRunnerHeritage >> accumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: true
]

{ #category : #accessing }
TestRunnerHeritage >> allTestPassed [

	^ result passedCount = result runCount
]

{ #category : #running }
TestRunnerHeritage >> debugFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| debugResult |
	debugResult := failure debug.
	debugResult ifNotNil: [ result removeFailure: failure ].
	self updateResultWith: debugResult
]

{ #category : #accessing }
TestRunnerHeritage >> defaultExecutionEnvironmentClass [

	^ CurrentExecutionEnvironment
]

{ #category : #running }
TestRunnerHeritage >> defaultSuitePreparator [

	"by default any process will be applied on suites.
	You can change the default behavior. See suitePreparator:"

	^ ShuffleSuitePreparator
]

{ #category : #running }
TestRunnerHeritage >> defaultTestResultClass [

	^ TestResult
]

{ #category : #accessing }
TestRunnerHeritage >> doNotAccumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: false
]

{ #category : #initialization }
TestRunnerHeritage >> initialize [

	super initialize.
	self resetSuites.
	self doNotAccumulateResult.
	self resetResult.
]

{ #category : #tests }
TestRunnerHeritage >> resetSuites [

	suites := OrderedCollection new
]

{ #category : #running }
TestRunnerHeritage >> run [

	"run all the suite then return the result"

	self setUp.
	[ self runTestsSuites ] ensure: [ self tearDown ]
]

{ #category : #running }
TestRunnerHeritage >> run: aTestCase [

	currentTest := aTestCase.
	self shouldAccumulate ifFalse: [ self resetResult ].
	self testSuiteFromClass: aTestCase.
	self run.
	^ result
]

{ #category : #running }
TestRunnerHeritage >> runAll: aCollectionOfTestCases [

	self accumulateResult.
	aCollectionOfTestCases do: [ :class | 
		class isAbstract ifFalse: [ self run: class ] ].
	^ result
]

{ #category : #running }
TestRunnerHeritage >> runFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| aResult |
	aResult := failure run.
	aResult hasFailures ifTrue: [ ^ self ].
	result removeFailure: failure.
	self updateResultWith: aResult
]

{ #category : #running }
TestRunnerHeritage >> runFailures [

	"rerun all the failed testcases"

	self result failures do: [ :failure | self runFailure: failure ]
]

{ #category : #runninh }
TestRunnerHeritage >> runPackage: aRPackage [

	self runAll:
		(aRPackage definedClasses reject: [ :class | class isAbstract ])
]

{ #category : #running }
TestRunnerHeritage >> runPackages: aCollection [

	aCollection do: [ :package | self runPackage: package ]
]

{ #category : #running }
TestRunnerHeritage >> runSuite: aTestSuite [

	currentResult := self executionMode executeSuite: aTestSuite.
	result := self result + currentResult
]

{ #category : #running }
TestRunnerHeritage >> runTestsSuites [

	"execute all every collected suite"

	self defaultExecutionEnvironmentClass runTestsBy: [ 
		self suites do: [ :testSuite | self runSuite: testSuite ] ]
]

{ #category : #processing }
TestRunnerHeritage >> setUp [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	super setUp.
	self suitePreparator applyOnSuites: suites
]

{ #category : #tests }
TestRunnerHeritage >> shouldAccumulate [

	^ shouldAccumulate
]

{ #category : #asserting }
TestRunnerHeritage >> shouldAccumulate: aBoolean [

	shouldAccumulate := aBoolean
]

{ #category : #accessing }
TestRunnerHeritage >> someTestCausesError [

	^ result hasErrors
]

{ #category : #accessing }
TestRunnerHeritage >> someTestFailed [

	^ result hasFailures
]

{ #category : #accessing }
TestRunnerHeritage >> suitePreparator [

	^ suitePreparator ifNil: [ 
		  suitePreparator := self defaultSuitePreparator ]
]

{ #category : #adding }
TestRunnerHeritage >> suitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
]

{ #category : #'instance creation' }
TestRunnerHeritage >> suites [

	^ suites ifNil: [ self resetSuites ]
]

{ #category : #counting }
TestRunnerHeritage >> suitesTotal [

	^ suites size
]

{ #category : #running }
TestRunnerHeritage >> switchToDebugMode [

	self executionMode: DebugExecutionMode
]

{ #category : #running }
TestRunnerHeritage >> switchToRunMode [

	self executionMode: RunExecutionMode
]

{ #category : #running }
TestRunnerHeritage >> tearDown [

	super tearDown.
	self resetSuites
]

{ #category : #tests }
TestRunnerHeritage >> testSuiteFromClass: aClass [

	"build a suite from the giving class then add it to the internal collections of suites. 
	The giving class should be a test case"

	(aClass isTestCase and: aClass isAbstract not) ifTrue: [ 
		self suites add: aClass suite ]
]

{ #category : #tests }
TestRunnerHeritage >> testSuitesFromClasses: aColOfTestCase [

	"build a collection of TestSuite and save it"

	aColOfTestCase do: [ :class | self testSuiteFromClass: class ]
]

{ #category : #accessing }
TestRunnerHeritage >> testsCount [

	"return the number of all tests methods from suites"

	^ self result tests size
]

{ #category : #update }
TestRunnerHeritage >> updateResultWith: testResult [

	"updtade the current test result"
	testResult passed do: [ :testCase | result addPass: testCase ].
	testResult failures do: [ :testCase | result addFailure: testCase ]
]
