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
Runner class >> runCase: aTestCase [
	^ self new
		runCase: aTestCase
]

{ #category : #'as yet unclassified' }
Runner >> accumulateResult [

	"activate the results accumulation behavior"

	self shouldAccumulate: true
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

{ #category : #running }
Runner >> initialize [

	super initialize.
	self resetSuite.
	self doNotAccumulateResult.
	self resetResult.
	suitePreparator := self defaultSuitePreparator
]

{ #category : #'as yet unclassified' }
Runner >> preProcessOnSuites [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	self suitePreparator applyOnSuites: suites
]

{ #category : #'as yet unclassified' }
Runner >> rerunFailures [

	"rerun only the failed testcases"

	| failures aResult |
	failures := self result failures.
	result failures: Set new.
	aResult := failures collect: [ :failure | failure run ].
	aResult do: [ :testResult | self updateResultForFailure: testResult ]
]

{ #category : #running }
Runner >> resetResult [

	"reset the runner result"

	result := self defaultTestResultClass new
]

{ #category : #tests }
Runner >> resetSuite [

	suites := OrderedCollection new
]

{ #category : #accessing }
Runner >> result [

	^ result
]

{ #category : #running }
Runner >> run [

	"run all the suite then return the result"

	"self shouldNotAccumulate ifTrue: [ self resetSuite ]."

	self preProcessOnSuites.
	self runTestsSuites.
	^ result
]

{ #category : #running }
Runner >> runCase: aTestCase [

	"self shouldAccumulate ifFalse: [ self resetSuite. self resetResult]."

	"/!\ todo  la compléxité est élévée, mieux vaut vider le suite dans les cas et garder le resultat si accumulation activée"

	self resetResult.
	self shouldAccumulate ifFalse: [ self resetSuite ].
	self testSuiteFromClass: aTestCase.
	^ self run
]

{ #category : #running }
Runner >> runSuite: aTestSuite [

	self
		executeSuite: aTestSuite
		as: [ :aSuite :aResult | aSuite run: aResult ]
]

{ #category : #running }
Runner >> runTestsSuites [

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
Runner >> suitePreparator [

	^ suitePreparator
]

{ #category : #adding }
Runner >> suitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
]

{ #category : #'instance creation' }
Runner >> suites [

	^ suites ifNil: [ self resetSuite ]
]

{ #category : #tests }
Runner >> testSuiteFromClass: aClass [

	"build a suite from the giving class then add it to the internal collections of suites"

	aClass isTestCase
		ifFalse: [ ANoTestCaseException signal: aClass name, ' is not a testCase' ]
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

{ #category : #'as yet unclassified' }
Runner >> updateResultForFailure: testResult [

	"updtade the current test result"

	testResult passed do: [ :testCase | result addPass: testCase ].
	testResult failures do: [ :testCase | result addFailure: testCase ]
]
