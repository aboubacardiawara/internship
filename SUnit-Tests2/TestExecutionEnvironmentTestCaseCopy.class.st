Class {
	#name : #TestExecutionEnvironmentTestCaseCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'testService',
		'executionEnvironment',
		'processes',
		'executionEnvForTestClass'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #testing }
TestExecutionEnvironmentTestCaseCopy class >> isAbstract [ 
	^self = TestExecutionEnvironmentTestCaseCopy
]

{ #category : #testing }
TestExecutionEnvironmentTestCaseCopy class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase:
			  { (#executionEnvForTestClass -> TestExecutionEnvironment) };
		  yourself
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> createTestService [

	self subclassResponsibility
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> executionEnvForTestClass [

	^ executionEnvForTestClass
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> executionEnvForTestClass: aClass [

	executionEnvForTestClass := aClass
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> newProcess: aName toImmediatelyExecute: aBlock [
	| newProcess |
	newProcess := aBlock newProcess.
	newProcess name: aName, (processes size + 1) asString.
	newProcess priority: Processor activePriority + 1.
	processes add: newProcess.
	^newProcess
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> runCaseManaged [

	"Here we are testing the test environment logic.
	So we should disable it for ourselves"

	^ DefaultExecutionEnvironment  beActiveDuring: [ self runCase ]
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> runWithNoHandlers: aBlock [
	"Executing the given block directly would go through all handlers of SUnit machinery.
	Here we simulate the clean environment with no outer handlers for possible block errors"
	| newProcess synchSemaphore result |
	synchSemaphore := Semaphore new. 
	newProcess := self 
		newProcess: 'Test process with no error handlers' 
		toImmediatelyExecute: [result := aBlock ensure: [synchSemaphore signal]].
	newProcess resume.
	synchSemaphore wait.
	^result
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> setUp [
	super setUp.
	processes := OrderedCollection new.
	
	testService := self createTestService.	
	testService enable.
	executionEnvironment := self executionEnvForTestClass new.
	executionEnvironment registerService: testService.
]

{ #category : #running }
TestExecutionEnvironmentTestCaseCopy >> tearDown [
	
	executionEnvironment deactivated. "for the case if we activated environment during test"
	processes do: [ :each | each terminate ].
	
	super tearDown.
]

{ #category : #tests }
TestExecutionEnvironmentTestCaseCopy >> testCleanUpShouldRevertServiceToBeEnabledByDefault [

	testService isEnabled: testService isEnabledByDefault not.
	
	testService cleanUpAfterTest.
	
	self assert: testService isEnabled equals: testService isEnabledByDefault
]

{ #category : #tests }
TestExecutionEnvironmentTestCaseCopy >> testIsEnabledByDefault [

	testService := self createTestService.
	
	self assert: testService isEnabled equals: testService isEnabledByDefault.
	self assert: testService isEnabledByDefault equals: testService class isEnabled
]
