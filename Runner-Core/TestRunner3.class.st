Class {
	#name : #TestRunner3,
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
TestRunner3 class >> example [
	<script>
	TestRunner2 new 
	suitePreparator: ShuffleSuitePreparator;
	run: DependencyTest;
	inspect
]

{ #category : #running }
TestRunner3 class >> run: aTestCase [
	^ self new
		run: aTestCase
]

{ #category : #processing }
TestRunner3 >> accumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: true
]

{ #category : #accessing }
TestRunner3 >> allTestPassed [

	^ result passedCount = result runCount
]

{ #category : #running }
TestRunner3 >> debugFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| debugResult |
	debugResult := failure debug.
	debugResult ifNotNil: [ result removeFailure: failure ].
	self updateResultForFailure: debugResult
]

{ #category : #accessing }
TestRunner3 >> defaultExecutionEnvironmentClass [

	^ CurrentExecutionEnvironment
]

{ #category : #running }
TestRunner3 >> defaultSuitePreparator [

	"by default any process will be applied on suites.
	You can change the default behavior. See suitePreparator:"

	^ ShuffleSuitePreparator
]

{ #category : #running }
TestRunner3 >> defaultTestResultClass [

	^ TestResult
]

{ #category : #accessing }
TestRunner3 >> doNotAccumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: false
]

{ #category : #initialization }
TestRunner3 >> initialize [

	super initialize.
	self resetSuites.
	self doNotAccumulateResult.
	self resetResult.
]

{ #category : #tests }
TestRunner3 >> resetSuites [

	suites := OrderedCollection new
]

{ #category : #running }
TestRunner3 >> run [

	"run all the suite then return the result"

	self setUp.
	[ self runTestsSuites ] ensure: [ self tearDown ]
]

{ #category : #running }
TestRunner3 >> run: aTestCase [

	currentTest := aTestCase.
	self shouldAccumulate ifFalse: [ self resetResult ].
	self testSuiteFromClass: aTestCase.
	self run.
	^ result
]

{ #category : #running }
TestRunner3 >> runCases: aCollectionOfTestCases [

	self accumulateResult.
	aCollectionOfTestCases do: [ :class | 
		class isAbstract ifFalse: [ self run: class ] ].
	^ result
]

{ #category : #running }
TestRunner3 >> runFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| aResult |
	aResult := failure run.
	aResult hasFailures ifTrue: [ ^ self ].
	result removeFailure: failure.
	self updateResultForFailure: aResult
]

{ #category : #running }
TestRunner3 >> runFailures [

	"rerun all the failed testcases"

	self result failures do: [ :failure | self runFailure: failure ]
]

{ #category : #runninh }
TestRunner3 >> runPackage: aRPackage [

	self runCases:
		(aRPackage definedClasses reject: [ :class | class isAbstract ])
]

{ #category : #running }
TestRunner3 >> runPackages: aCollection [

	aCollection do: [ :package | self runPackage: package ]
]

{ #category : #running }
TestRunner3 >> runSuite: aTestSuite [

	currentResult := self executionMode executeSuite: aTestSuite.
	result := self result + currentResult
]

{ #category : #running }
TestRunner3 >> runTestsSuites [

	"execute all every collected suite"

	self defaultExecutionEnvironmentClass runTestsBy: [ 
		self suites do: [ :testSuite | self runSuite: testSuite ] ]
]

{ #category : #processing }
TestRunner3 >> setUp [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	super setUp.
	self suitePreparator applyOnSuites: suites
]

{ #category : #tests }
TestRunner3 >> shouldAccumulate [

	^ shouldAccumulate
]

{ #category : #asserting }
TestRunner3 >> shouldAccumulate: aBoolean [

	shouldAccumulate := aBoolean
]

{ #category : #accessing }
TestRunner3 >> someTestCausesError [

	^ result hasErrors
]

{ #category : #accessing }
TestRunner3 >> someTestFailed [

	^ result hasFailures
]

{ #category : #accessing }
TestRunner3 >> suitePreparator [

	^ suitePreparator ifNil: [ 
		  suitePreparator := self defaultSuitePreparator ]
]

{ #category : #adding }
TestRunner3 >> suitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
]

{ #category : #'instance creation' }
TestRunner3 >> suites [

	^ suites ifNil: [ self resetSuites ]
]

{ #category : #counting }
TestRunner3 >> suitesTotal [

	^ suites size
]

{ #category : #running }
TestRunner3 >> switchToDebugMode [

	self executionMode: DebugExecutionMode
]

{ #category : #running }
TestRunner3 >> switchToRunMode [

	self executionMode: RunExecutionMode
]

{ #category : #running }
TestRunner3 >> tearDown [

	super tearDown.
	self resetSuites
]

{ #category : #tests }
TestRunner3 >> testSuiteFromClass: aClass [

	"build a suite from the giving class then add it to the internal collections of suites. 
	The giving class should be a test case"

	(aClass isTestCase and: aClass isAbstract not) ifTrue: [ 
		self suites add: aClass suite ]
]

{ #category : #tests }
TestRunner3 >> testSuitesFromClasses: aColOfTestCase [

	"build a collection of TestSuite and save it"

	aColOfTestCase do: [ :class | self testSuiteFromClass: class ]
]

{ #category : #accessing }
TestRunner3 >> testsCount [

	"return the number of all tests methods from suites"

	^ self result tests size
]

{ #category : #update }
TestRunner3 >> updateResultForFailure: testResult [

	"updtade the current test result"
	testResult passed do: [ :testCase | result addPass: testCase ].
	testResult failures do: [ :testCase | result addFailure: testCase ]
]
