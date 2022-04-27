Class {
	#name : #Runner,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result'
	],
	#category : #'Runner-Core-Kernel'
}

{ #category : #'as yet unclassified' }
Runner >> defaultExecutionEnvironmentClass [
	^ CurrentExecutionEnvironment
]

{ #category : #running }
Runner >> defaultTestResultClass [
	^ TestResult
]

{ #category : #processing }
Runner >> executeSuite: aTestSuite as: aBlock [
	" The block defines how to interact with the suite. run with a result or debug "
	[ aBlock cull: aTestSuite cull: result  ] ensure: [
		aTestSuite unsubscribe:TestAnnouncement.
	].
]

{ #category : #testing }
Runner >> hasTestsToRun [
	^ self suites isEmpty not.
]

{ #category : #running }
Runner >> initialize [
	result := self defaultTestResultClass new.
]

{ #category : #running }
Runner >> run [
	self runTestsSuites.
	^ result.
]

{ #category : #'as yet unclassified' }
Runner >> runSuite [
	self shouldBeImplemented.
]

{ #category : #running }
Runner >> runSuite: aTestSuite [
	self executeSuite: aTestSuite as: [ :aSuite :aResult | aSuite run: aResult ].
]

{ #category : #'as yet unclassified' }
Runner >> runTestsSuites [
	self defaultExecutionEnvironmentClass runTestsBy: [ 
		self suites
			do: [ :testSuite | self runSuite: testSuite ]
	]
]

{ #category : #'instance creation' }
Runner >> suites [
	^ suites ifNil: [ suites := OrderedCollection new ]
]

{ #category : #tests }
Runner >> testSuiteFromClass: aClass [
	self suites add: (aClass isAbstract not & aClass suite ).
]

{ #category : #tests }
Runner >> testSuitesFromClasses: aCol [
	aCol do: (
		[ :class | self testSuiteFromClass: class  ]
	)
]

{ #category : #accessing }
Runner >> testsCount [
	"return the number of all tests methods from suites"
	^ self suites inject: 0 into: [ :sum :suite | sum + suite tests size ]
]
