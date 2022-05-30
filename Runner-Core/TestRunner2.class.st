"
I represent a runner supposed to execute unit test.
I can take a TestCase in order to run then restituate the result.

Public API and Key Messages

- Runner >> runCase:
- Runner class >> runCase:
- Runner >> accumulateResult
- Runner >> result
- Runner >> run
- Runner >> suitePreparator:

## Example
Let create a simple runner and run some test with.
`Warning:` By default, i do not accumulate results, but i can do it if you want. 
```smalltalk
|aRunner|
aRunner := Runner new.

aRunner runCase: MyClassTest >> ""a TestResult"" ""(1)""
""if we run a second test case, the first result will be overwritten""
""we can prevent that by sending the message accumulateResult to the runner""

aRunner accumulateResult.
aRunner runCase: AnotherClassTest >> ""a TestResult"" ""(2)""
this last result contains the accumulation of the two last result (1) and (2)
```
 
Internal Representation and Key Implementation Points.

    Instance Variables
	result:		a test execution result
	shouldAccumulate:		indicate either the futur execution result should be add to the previous result or not.
	suitePreparator:		before test execution, this object apply some operation on test suite (e.g shuffle).
	suites:		a test suites

"
Class {
	#name : #TestRunner2,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result',
		'suitePreparator',
		'shouldAccumulate',
		'executionMode'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #running }
TestRunner2 class >> example [
	<script>
	TestRunner2 new 
	suitePreparator: ShuffleSuitePreparator;
	runCase: DependencyTest;
	inspect
]

{ #category : #running }
TestRunner2 class >> runCase: aTestCase [
	^ self new
		runCase: aTestCase
]

{ #category : #processing }
TestRunner2 >> accumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: true
]

{ #category : #accessing }
TestRunner2 >> allTestPassed [

	^ result passedCount = result runCount
]

{ #category : #running }
TestRunner2 >> debugFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| debugResult |
	debugResult := failure debug.
	debugResult ifNotNil: [ result removeFailure: failure ].
	self updateResultForFailure: debugResult
]

{ #category : #accessing }
TestRunner2 >> defaultExecutionEnvironmentClass [

	^ CurrentExecutionEnvironment
]

{ #category : #running }
TestRunner2 >> defaultExecutionModeClass [

	^ RunMode
]

{ #category : #running }
TestRunner2 >> defaultSuitePreparator [

	"by default any process will be applied on suites.
	You can change the default behavior. See suitePreparator:"

	^ ShuffleSuitePreparator
]

{ #category : #running }
TestRunner2 >> defaultTestResultClass [

	^ TestResult
]

{ #category : #accessing }
TestRunner2 >> doNotAccumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: false
]

{ #category : #accessing }
TestRunner2 >> errorCount [

	^ result errorCount
]

{ #category : #initialization }
TestRunner2 >> executionMode [

	^ executionMode ifNil: [ 
		  executionMode := self defaultExecutionModeClass]
]

{ #category : #running }
TestRunner2 >> executionMode: anExecutionMode [

	executionMode := anExecutionMode
]

{ #category : #accessing }
TestRunner2 >> failureCount [

	^ self result failureCount
]

{ #category : #testing }
TestRunner2 >> hasTestsToRun [

	"check either the runner has test to run or not.
	If any test has not been added, there nothing to run"

	"Example of usages:"

	"Runner new hasTestsToRun >>> false
	(Runner new testSuiteFromClass: GreenTest) hasTestsToRun >>> true"

	^ self suites isNotEmpty
]

{ #category : #initialization }
TestRunner2 >> initialize [

	super initialize.
	self resetSuites.
	self doNotAccumulateResult.
	self resetResult.
]

{ #category : #accessing }
TestRunner2 >> passedCount [

	^ self result passedCount
]

{ #category : #tests }
TestRunner2 >> raiseAbstractTestCaseException: aClass [

	AnAbstractTestCaseException signal:
		aClass name , ' is abstract. Run its subclassees instead'
]

{ #category : #tests }
TestRunner2 >> raiseNotTestCaseException: aClass [

	ANoTestCaseException signal: aClass name , ' is not a testCase'
]

{ #category : #running }
TestRunner2 >> resetResult [

	"reset the runner result"

	result := self defaultTestResultClass new
]

{ #category : #tests }
TestRunner2 >> resetSuites [

	suites := OrderedCollection new
]

{ #category : #accessing }
TestRunner2 >> result [

	^ result
]

{ #category : #running }
TestRunner2 >> run [

	"run all the suite then return the result"

	self setUp.
	[ self runTestsSuites ] ensure: [ self tearDown ]
]

{ #category : #running }
TestRunner2 >> runCase: aTestCase [

	self shouldAccumulate ifFalse: [ self resetResult ].
	self testSuiteFromClass: aTestCase.
	self run.
	^ result
]

{ #category : #running }
TestRunner2 >> runCases: aCollectionOfTestCases [

	self accumulateResult.
	aCollectionOfTestCases do: [ :class | 
		class isAbstract ifFalse: [ self runCase: class ] ].
	^ result
]

{ #category : #accessing }
TestRunner2 >> runCount [

	^ self result runCount
]

{ #category : #running }
TestRunner2 >> runFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| aResult |
	aResult := failure run.
	aResult hasFailures ifTrue: [ ^ self ].
	result removeFailure: failure.
	self updateResultForFailure: aResult
]

{ #category : #running }
TestRunner2 >> runFailures [

	"rerun all the failed testcases"

	self result failures do: [ :failure | self runFailure: failure ]
]

{ #category : #runninh }
TestRunner2 >> runPackage: aRPackage [

	self runCases:
		(aRPackage definedClasses reject: [ :class | class isAbstract ])
]

{ #category : #running }
TestRunner2 >> runSuite: aTestSuite [

	result := result + (self executionMode executeSuite: aTestSuite)
]

{ #category : #running }
TestRunner2 >> runTestsSuites [

	"execute all every collected suite"

	self defaultExecutionEnvironmentClass runTestsBy: [ 
		self suites do: [ :testSuite | self runSuite: testSuite ] ]
]

{ #category : #processing }
TestRunner2 >> setUp [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	self suitePreparator applyOnSuites: suites
]

{ #category : #tests }
TestRunner2 >> shouldAccumulate [

	^ shouldAccumulate
]

{ #category : #asserting }
TestRunner2 >> shouldAccumulate: aBoolean [

	shouldAccumulate := aBoolean
]

{ #category : #accessing }
TestRunner2 >> someTestCausesError [

	^ result hasErrors
]

{ #category : #accessing }
TestRunner2 >> someTestFailed [

	^ result hasFailures
]

{ #category : #accessing }
TestRunner2 >> suitePreparator [

	^ suitePreparator ifNil: [ 
		  suitePreparator := self defaultSuitePreparator ]
]

{ #category : #adding }
TestRunner2 >> suitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
]

{ #category : #'instance creation' }
TestRunner2 >> suites [

	^ suites ifNil: [ self resetSuites ]
]

{ #category : #'as yet unclassified' }
TestRunner2 >> suitesTotal [

	^ suites size
]

{ #category : #running }
TestRunner2 >> switchToDebugMode [

	self executionMode: DebugMode
]

{ #category : #running }
TestRunner2 >> switchToRunMode [

	self executionMode: RunMode
]

{ #category : #running }
TestRunner2 >> tearDown [

	self resetSuites
]

{ #category : #tests }
TestRunner2 >> testSuiteFromClass: aClass [

	"build a suite from the giving class then add it to the internal collections of suites. 
	The giving class should be a test case"

	(aClass isTestCase and: aClass isAbstract not) ifTrue: [ 
		self suites add: aClass suite ]
]

{ #category : #tests }
TestRunner2 >> testSuitesFromClasses: aColOfTestCase [

	"build a collection of TestSuite and save it"

	aColOfTestCase do: [ :class | self testSuiteFromClass: class ]
]

{ #category : #accessing }
TestRunner2 >> testsCount [

	"return the number of all tests methods from suites"

	^ self result tests size
]

{ #category : #update }
TestRunner2 >> updateResultForFailure: testResult [

	"updtade the current test result"
	testResult passed do: [ :testCase | result addPass: testCase ].
	testResult failures do: [ :testCase | result addFailure: testCase ]
]
