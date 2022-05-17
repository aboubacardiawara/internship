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
	#name : #Runner,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result',
		'suitePreparator',
		'shouldAccumulate'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #running }
Runner class >> example [
	<script>
	Runner new 
	suitePreparator: ShuffleSuitePreparator;
	runCase: DependencyTest;
	inspect
]

{ #category : #running }
Runner class >> runCase: aTestCase [
	^ self new
		runCase: aTestCase
]

{ #category : #'as yet unclassified' }
Runner >> accumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: true
]

{ #category : #accessing }
Runner >> allTestPassed [
	^ result passedCount = result runCount
]

{ #category : #running }
Runner >> debugFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| debugResult |
	debugResult := failure debug.
	debugResult ifNotNil: [ result removeFailure: failure ].
	self updateResultForFailure: debugResult
]

{ #category : #'as yet unclassified' }
Runner >> defaultExecutionEnvironmentClass [

	^ CurrentExecutionEnvironment
]

{ #category : #running }
Runner >> defaultSuitePreparator [

	"by default any process will be applied on suites.
	You can change the default behavior. See suitePreparator:"

	^ AnyEffectSuitePreparator
]

{ #category : #running }
Runner >> defaultTestResultClass [

	^ TestResult
]

{ #category : #'as yet unclassified' }
Runner >> doNotAccumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: false
]

{ #category : #processing }
Runner >> executeSuite: aTestSuite as: aBlock [

	" The block defines how to interact with the suite. run with a result or debug"

	[ aBlock cull: aTestSuite cull: result ] ensure: [ 
		aTestSuite unsubscribe: TestAnnouncement ]
]

{ #category : #testing }
Runner >> hasTestsToRun [

	"check either the runner has test to run or not.
	If any test has not been added, there nothing to run"

	"Example of usages:"

	"Runner new hasTestsToRun >>> false
	(Runner new testSuiteFromClass: GreenTest) hasTestsToRun >>> true"

	^ self suites isNotEmpty
]

{ #category : #initialization }
Runner >> initialize [

	super initialize.
	self resetSuites.
	self doNotAccumulateResult.
	self resetResult.
	suitePreparator := self defaultSuitePreparator
]

{ #category : #running }
Runner >> postExecution [

	self resetSuites
]

{ #category : #'as yet unclassified' }
Runner >> preExecution [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	self suitePreparator applyOnSuites: suites
]

{ #category : #tests }
Runner >> raiseNotTestCaseException: aClass [

	ANoTestCaseException signal: aClass name , ' is not a testCase'
]

{ #category : #running }
Runner >> resetResult [

	"reset the runner result"

	result := self defaultTestResultClass new
]

{ #category : #tests }
Runner >> resetSuites [

	suites := OrderedCollection new
]

{ #category : #accessing }
Runner >> result [

	^ result
]

{ #category : #running }
Runner >> run [

	"run all the suite then return the result"

	self preExecution.
	self runTestsSuites.
	self postExecution
]

{ #category : #running }
Runner >> runCase: aTestCase [

	self shouldAccumulate ifFalse: [ self resetResult ].
	self testSuiteFromClass: aTestCase.
	self run.
	^ result
]

{ #category : #running }
Runner >> runFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| aResult |
	aResult := failure run.
	aResult hasFailures ifTrue: [ ^ self ].
	result removeFailure: failure.
	self updateResultForFailure: aResult
]

{ #category : #running }
Runner >> runFailures [

	"rerun all the failed testcases"

	self result failures do: [ :failure | self runFailure: failure ]
]

{ #category : #running }
Runner >> runSuite: aTestSuite [

	self
		executeSuite: aTestSuite
		as: [ :aSuite :aResult | aSuite run: aResult ]
]

{ #category : #running }
Runner >> runTestsSuites [

	"execute all every collected suite"

	self defaultExecutionEnvironmentClass runTestsBy: [ 
		self suites do: [ :testSuite | self runSuite: testSuite ] ]
]

{ #category : #tests }
Runner >> shouldAccumulate [

	^ shouldAccumulate
]

{ #category : #asserting }
Runner >> shouldAccumulate: aBoolean [

	shouldAccumulate := aBoolean
]

{ #category : #accessing }
Runner >> someTestCausesError [

	^ result hasErrors
]

{ #category : #accessing }
Runner >> someTestFailed [

	^ result hasFailures
]

{ #category : #accessing }
Runner >> suitePreparator [

	^ suitePreparator
]

{ #category : #adding }
Runner >> suitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
]

{ #category : #'instance creation' }
Runner >> suites [

	^ suites ifNil: [ self postExecution ]
]

{ #category : #tests }
Runner >> testSuiteFromClass: aClass [

	"build a suite from the giving class then add it to the internal collections of suites. 
	The giving class should be a test case"

	aClass isTestCase
		ifFalse: [ self raiseNotTestCaseException: aClass ]
		ifTrue: [ self suites add: aClass isAbstract not & aClass suite ]
]

{ #category : #tests }
Runner >> testSuitesFromClasses: aColOfTestCase [

	"build a collection of TestSuite and store it in "

	aColOfTestCase do: [ :class | self testSuiteFromClass: class ]
]

{ #category : #accessing }
Runner >> testsCount [

	"return the number of all tests methods from suites"

	^ self suites
		  inject: 0
		  into: [ :sum :suite | sum + suite tests size ]
]

{ #category : #update }
Runner >> updateResultForFailure: testResult [

	"updtade the current test result"
	testResult passed do: [ :testCase | result addPass: testCase ].
	testResult failures do: [ :testCase | result addFailure: testCase ]
]
