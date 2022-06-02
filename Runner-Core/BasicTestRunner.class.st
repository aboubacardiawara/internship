"
If you giving a TestCase (MyCounterTest), i can execute then and give you the execution result.

## Public API
"
Class {
	#name : #BasicTestRunner,
	#superclass : #Object,
	#instVars : [
		'result',
		'suitePreparator',
		'executionMode',
		'suite'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #running }
BasicTestRunner class >> run: aClass [

	^ self new run: aClass
]

{ #category : #getter }
BasicTestRunner >> classForTestSuite [

	^ TestSuite
]

{ #category : #accessing }
BasicTestRunner >> defaultExecutionModeClass [

	^ RunExecutionMode
]

{ #category : #accessing }
BasicTestRunner >> defaultResultClass [

	^ TestResult
]

{ #category : #accessing }
BasicTestRunner >> defaultSuitePreparatorClass [

	^ ShuffleSuitePreparator
]

{ #category : #counting }
BasicTestRunner >> errorCount [

	^ self result errorCount
]

{ #category : #accessing }
BasicTestRunner >> executionMode [

	^ executionMode ifNil: [ 
		  executionMode := self defaultExecutionModeClass ]
]

{ #category : #accessing }
BasicTestRunner >> executionMode: anObject [

	executionMode := anObject
]

{ #category : #counting }
BasicTestRunner >> failureCount [

	^ self result failureCount
]

{ #category : #testing }
BasicTestRunner >> hasTestsToRun [

	^ self suite tests isNotEmpty
]

{ #category : #counting }
BasicTestRunner >> passedCount [

	^ self result passedCount
]

{ #category : #running }
BasicTestRunner >> resetResult [

	result := nil
]

{ #category : #running }
BasicTestRunner >> resetSuite [

	suite := nil
]

{ #category : #accessing }
BasicTestRunner >> result [

	^ result ifNil: [ result := self defaultResultClass new ]
]

{ #category : #accessing }
BasicTestRunner >> result: anObject [

	result := anObject
]

{ #category : #running }
BasicTestRunner >> run [

	"run all the suite then return the result"

	self setUp.
	[ self runSuite ] ensure: [ self tearDown ]
]

{ #category : #running }
BasicTestRunner >> run: aClass [

	self testSuiteFromClass: aClass.
	self run.
	^ result
]

{ #category : #counting }
BasicTestRunner >> runCount [

	^ self result runCount
]

{ #category : #accessing }
BasicTestRunner >> runFailure: failure [

	"rerun the giving failure"

	"remove it, run it, the update the result"

	| aResult |
	aResult := failure run.
	aResult hasFailures ifTrue: [ ^ self ].
	result removeFailure: failure.
	self updateResultForFailure: aResult
]

{ #category : #accessing }
BasicTestRunner >> runFailures [

	"rerun all the failed testcases"

	self result failures do: [ :failure | self runFailure: failure ]
]

{ #category : #running }
BasicTestRunner >> runSuite [

	result := self executionMode executeSuite: suite
]

{ #category : #processing }
BasicTestRunner >> setUp [

	"we would like to process suites before 
	the execution (e.g shufling the tests, ...). 
	It can be useful 
	for tests dependancy detection"

	self resetResult.
	self suitePreparator applyOn: self suite
]

{ #category : #getter }
BasicTestRunner >> suite [
	^ suite ifNil: [ suite := self classForTestSuite new ]
]

{ #category : #accessing }
BasicTestRunner >> suitePreparator [

	^ suitePreparator ifNil: [ 
		  suitePreparator := self defaultSuitePreparatorClass ]
]

{ #category : #accessing }
BasicTestRunner >> suitePreparator: anObject [

	suitePreparator := anObject
]

{ #category : #running }
BasicTestRunner >> tearDown [

	self resetSuite.
]

{ #category : #tests }
BasicTestRunner >> testSuiteFromClass: aClass [

	aClass isTestCase ifTrue: [ suite := aClass suite ]
]

{ #category : #counting }
BasicTestRunner >> testsCount [

	^ self result tests size
]

{ #category : #accessing }
BasicTestRunner >> updateResultForFailure: testResult [

	"updtade the current test result"
	testResult passed do: [ :testCase | result addPass: testCase ].
	testResult failures do: [ :testCase | result addFailure: testCase ]
]
