Class {
	#name : #Runner,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result',
		'suitePreparator',
		'shouldAccumulate'
	],
	#category : #'Runner-Core-Kernel'
}

{ #category : #running }
Runner class >> run: aTestCase [
	^ self new
		run: aTestCase
]

{ #category : #'as yet unclassified' }
Runner >> accumulateResult [

	self shouldAccumulate: true
]

{ #category : #'as yet unclassified' }
Runner >> defaultExecutionEnvironmentClass [

	^ CurrentExecutionEnvironment
]

{ #category : #running }
Runner >> defaultSuitePreparator [

	^ AnyEffectSuitePreparator
]

{ #category : #running }
Runner >> defaultTestResultClass [

	^ TestResult
]

{ #category : #'as yet unclassified' }
Runner >> doNotAccumulateResult [

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

	"check either the runner has test to run or not."

	"If any test has not been added, there nothing to run"

	"Example of usages:"

	"Runner new hasTestsToRun >>> false"

	"(Runner new testSuiteFromClass: GreenTest) hasTestsToRun >>> true"

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

{ #category : #running }
Runner >> resetResult [

	result := self defaultTestResultClass new
]

{ #category : #tests }
Runner >> resetSuite [
	suites := OrderedCollection new.
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
Runner >> run: aTestCase [

	"self shouldAccumulate ifFalse: [ self resetSuite. self resetResult]."

	self shouldAccumulate
		ifTrue: [  self resetResult ]
		ifFalse: [ 
			self resetSuite.
			self resetResult ].
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

	self suites add: aClass isAbstract not & aClass suite
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
