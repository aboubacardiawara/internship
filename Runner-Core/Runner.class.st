Class {
	#name : #Runner,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result',
		'suitePreparator'
	],
	#category : #'Runner-Core-Kernel'
}

{ #category : #adding }
Runner >> addSuitePreparator: aSuitePreparator [

	suitePreparator := aSuitePreparator
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
	result := self defaultTestResultClass new.
	suitePreparator := self defaultSuitePreparator
]

{ #category : #'as yet unclassified' }
Runner >> preProcessOnSuites [

	"we would like to process suites before execution (e.g shufling the tests, ...). It can be useful 
	for tests dependancy detection"

	self suitePreparator applyOnSuites: suites
]

{ #category : #running }
Runner >> run [

	"run all the suite then return the result"

	self preProcessOnSuites.
	self runTestsSuites.
	^ result
]

{ #category : #running }
Runner >> runSuite [

	self shouldBeImplemented
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

{ #category : #accessing }
Runner >> suitePreparator [

	^ suitePreparator
]

{ #category : #'instance creation' }
Runner >> suites [

	^ suites ifNil: [ suites := OrderedCollection new ]
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
