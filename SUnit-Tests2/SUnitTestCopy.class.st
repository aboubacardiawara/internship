Class {
	#name : #SUnitTestCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'hasRun',
		'hasSetup',
		'hasRanOnce',
		'forkedProcesses',
		'executionEnvironmentClass',
		'executionEnvironmentForTestClass'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #history }
SUnitTestCopy class >> lastStoredRun [
	^ ((Dictionary new) add: (#passed->((Set new) add: #testWithExceptionDo; add: #testAssert; add: #testRanOnlyOnce; add: #testDialectLocalizedException; add: #testFail; add: #testDefects; add: #testIsNotRerunOnDebug; add: #testResult; add: #testRunning; add: #testError; add: #testException; add: #testShould; add: #testSuite; yourself)); add: (#timeStamp->'22 November 2008 10:11:35 pm'); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #history }
SUnitTestCopy class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { 
				  (#executionEnvironmentForTestClass -> TestExecutionEnvironment).
				  (#executionEnvironmentClass -> DefaultExecutionEnvironment) };
		  yourself
]

{ #category : #private }
SUnitTestCopy >> assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount [

	self assert: aResult runCount equals: aRunCount.
	self assert: aResult passedCount equals: aPassedCount.
	self assert: aResult failureCount equals: aFailureCount.
	self assert: aResult errorCount equals: anErrorCount
]

{ #category : #private }
SUnitTestCopy >> assertForTestResult: aResult runCount: aRunCount passed: aPassedCount failed: aFailureCount errors: anErrorCount expectedFailures: anExpectedFailureCount [

	self assert: aResult runCount equals: aRunCount.
	self assert: aResult expectedPassCount equals: aPassedCount.
	self assert: aResult failureCount equals: aFailureCount.
	self assert: aResult errorCount equals: anErrorCount.
	self
		assert: aResult expectedDefectCount
		equals: anExpectedFailureCount
]

{ #category : #helpers }
SUnitTestCopy >> assertTerminationOfFailedChildProcesses [

	| failedProcesses |
	failedProcesses := self failedChildProcesses.
	self assert: failedProcesses notEmpty.
	self assert: (failedProcesses allSatisfy: #isTerminated)
]

{ #category : #helpers }
SUnitTestCopy >> deprecatedMessage [
	self deprecated: 'Deprecated method used by #testIgnoreDeprecationWarnings' on: '' in: ''
]

{ #category : #private }
SUnitTestCopy >> error [
	3 zork
]

{ #category : #testing }
SUnitTestCopy >> errorShouldntRaise [
	self someMessageThatIsntUnderstood
]

{ #category : #accessing }
SUnitTestCopy >> executionEnvironmentClass [
	^ executionEnvironmentClass
]

{ #category : #helpers }
SUnitTestCopy >> executionEnvironmentClass: aClass [

	executionEnvironmentClass := aClass
]

{ #category : #accessing }
SUnitTestCopy >> executionEnvironmentForTestClass [
	^ executionEnvironmentForTestClass
]

{ #category : #setter }
SUnitTestCopy >> executionEnvironmentForTestClass: aClass [

	executionEnvironmentForTestClass := aClass
]

{ #category : #private }
SUnitTestCopy >> expectedFailureFails [
	<expectedFailure>
	self assert: false.
]

{ #category : #private }
SUnitTestCopy >> expectedFailurePasses [
	<expectedFailure>
	self assert: true.
]

{ #category : #private }
SUnitTestCopy >> failedChildProcessTest [
	"During this test forked process should signal error.
	It means that after fork we should give the process control"
	
	| process |
	process := [ self error: 'error from child process'] forkNamed: 'failed child for ', testSelector.
	forkedProcesses add: process.
	Processor yield.
]

{ #category : #helpers }
SUnitTestCopy >> failedChildProcesses [
	^forkedProcesses select: [: each | each name beginsWith: 'failed child']
]

{ #category : #private }
SUnitTestCopy >> failedTestWithFailedChildProcessTest [
	"This failing test first launches a subprocess that fails and then fails."
	self failedChildProcessTest.
	Processor yield.
	self error: 'failed test with failed child process'
]

{ #category : #accessing }
SUnitTestCopy >> forkedProcesses [
	^forkedProcesses
]

{ #category : #accessing }
SUnitTestCopy >> forkedProcesses: aCollection [
	forkedProcesses := aCollection
]

{ #category : #private }
SUnitTestCopy >> hangedChildProcessTest [

	| process |
	process := [10 seconds wait] forkNamed: #hangedChildProcessTest.
	forkedProcesses add: process
]

{ #category : #private }
SUnitTestCopy >> hangedTestDueToFailedChildProcess [
	self timeLimit: 10 milliSeconds.
	
	self failedChildProcessTest.
	
	20 milliSeconds wait.
]

{ #category : #accessing }
SUnitTestCopy >> hasRun [
	^hasRun
]

{ #category : #accessing }
SUnitTestCopy >> hasSetup [
	^hasSetup
]

{ #category : #private }
SUnitTestCopy >> longRunningTest [

	self timeLimit: 10 milliSeconds.
	20 milliSeconds wait
]

{ #category : #helpers }
SUnitTestCopy >> newTestCase: myTestSelector [ 
	| testCase |
	testCase := self class selector: myTestSelector.	
	"During the #run the #tearDown logic resets to nil all inst vars of #testCase instance.
	Here is a hook to collect any required state inside the receiver so that it can be accessed directly from the receiver despite on the reset #testCase.
	#forkedProcesses variable is used to keep all processes forked during the testCase execution"
	forkedProcesses ifNil: [ forkedProcesses := OrderedCollection new ].
	testCase forkedProcesses: forkedProcesses.
	^testCase
]

{ #category : #private }
SUnitTestCopy >> noop [
]

{ #category : #testing }
SUnitTestCopy >> raiseDeprecationWarnings [
	| oldRaiseWarning |
	oldRaiseWarning := Deprecation raiseWarning.
	[ Deprecation raiseWarning: true.
	self deprecatedMessage.
	self fail ]
		ensure: [ Deprecation raiseWarning: oldRaiseWarning ]
]

{ #category : #private }
SUnitTestCopy >> setRun [
	hasRun := true
]

{ #category : #running }
SUnitTestCopy >> setUp [
	super setUp.
	hasSetup := true
]

{ #category : #testing }
SUnitTestCopy >> testAssert [
	self assert: true.
	self deny: false
]

{ #category : #testing }
SUnitTestCopy >> testChildProcessShouldNotBeStoredStronglyByTestEnvironment [

	| process weak |
	process := [   ] forkNamed: 'child test process'.
	weak := WeakArray with: process.
	process := nil.
	Processor yield.
	Smalltalk garbageCollect.
	
	self assert: weak first equals: nil
]

{ #category : #testing }
SUnitTestCopy >> testDefects [
	| result suite error failure |
	suite := self classForTestSuite new.
	suite addTest: (error := self newTestCase: #error).
	suite addTest: (failure := self newTestCase: #fail).
	result := suite run.
	self assert: result defects asArray equals: (Array with: error with: failure).
	self
		assertForTestResult: result
		runCount: 2
		passed: 0
		failed: 1
		errors: 1
]

{ #category : #testing }
SUnitTestCopy >> testDialectLocalizedException [

	self
		should: [self classForTestResult signalFailureWith: 'Foo']
		raise: self defaultTestFailure.
	self
		should: [self classForTestResult signalErrorWith: 'Foo']
		raise: self defaultTestError.
]

{ #category : #testing }
SUnitTestCopy >> testError [

	| case result |

	case := self newTestCase: #error.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1.

	case := self newTestCase: #errorShouldntRaise.
	result := case run.
	self 
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1
]

{ #category : #testing }
SUnitTestCopy >> testErrorShouldResetWatchDog [

	| case result |
	
	self executionEnvironmentClass beActive.
	self executionEnvironmentForTestClass new beActiveDuring: [ 
		case := self newTestCase: #fail.
		result := case run.
		1 seconds wait]. 

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 1
		errors: 0
]

{ #category : #testing }
SUnitTestCopy >> testException [

	self
		should: [self error: 'foo']
		raise: self defaultTestError
]

{ #category : #testing }
SUnitTestCopy >> testExecutionEnvironmentShouldBeInstalled [

	| env |
	env := self executionEnvironment.

	self assert: env class equals: self executionEnvironmentForTestClass.
	self assert: env testCase equals: self
]

{ #category : #testing }
SUnitTestCopy >> testExpectedFailure [

	| case result |
	case := self newTestCase: #expectedFailureFails.
	self deny: case shouldPass.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 0
		expectedFailures: 1.
]

{ #category : #testing }
SUnitTestCopy >> testExpectedFailureDetection [

	self assert: self expectedFailures size equals: 2.
	self assert: (self expectedFailures includesAll:
			 #( expectedFailureFails expectedFailurePasses ))
]

{ #category : #testing }
SUnitTestCopy >> testExpectedFailurePass [

	| case result |
	case := self newTestCase: #expectedFailurePasses.
	self deny: case shouldPass.
	result := case run.
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 1
		errors: 0
		expectedFailures: 0.
]

{ #category : #testing }
SUnitTestCopy >> testFail [

	| case result |

	case := self newTestCase: #fail.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 1
		errors: 0
]

{ #category : #testing }
SUnitTestCopy >> testFailedChildProcessTest [

	| case result |
	self executionEnvironmentClass beActive.
	case := self newTestCase: #failedChildProcessTest.	
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1.		
	self assertTerminationOfFailedChildProcesses
]

{ #category : #testing }
SUnitTestCopy >> testFailedChildProcessTestShouldNotEffectFollowingAnotherTest [

	| result case1 case2 |
	self executionEnvironmentClass beActive.
	self executionEnvironmentForTestClass new beActiveDuring: [ 
		case1 := self newTestCase: #failedChildProcessTest.
		result := case1 run.

		case2 := self newTestCase: #noop.
		result := case2 run ].

	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0.
	self assertTerminationOfFailedChildProcesses
]

{ #category : #testing }
SUnitTestCopy >> testFailedTestWithFailedChildProcessTestShouldNotEffectFollowingAnotherTest [

	| result case1 case2 |
	self executionEnvironmentClass beActive.
	self executionEnvironmentForTestClass new beActiveDuring: [ 
		case1 := self newTestCase: #failedTestWithFailedChildProcessTest.
		result := case1 run.

		case2 := self newTestCase: #noop.
		result := case2 run ].

	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0.
	self assertTerminationOfFailedChildProcesses
]

{ #category : #testing }
SUnitTestCopy >> testFileOutResult [
	| suite result fileout |
	suite := self classForTestSuite new.
	suite
		addTest: (self newTestCase: #noop);
		addTest: (self newTestCase: #fail);
		addTest: (self newTestCase: #error).
	result := suite run.
	fileout := String streamContents: [ :aStream | result fileOutOn: aStream ].
	self
		assert: fileout
		equals:
			'3 ran, 1 passed, 0 skipped, 0 expected failures, 1 failure, 1 error, 0 passed unexpected
Failures:
SUnitTestCopy(TestAsserterCopy)>>#fail

Errors:
SUnitTestCopy>>#error
'
]

{ #category : #testing }
SUnitTestCopy >> testGreenTestThenLongRunningTest [

	| case result |
	self executionEnvironmentClass beActive.
	case := self newTestCase: #noop.
	result := case run.
	case := self newTestCase: #longRunningTest.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1
]

{ #category : #testing }
SUnitTestCopy >> testHangedChildProcessTestWhenItIsAllowedToLeaveProcessesAfterTest [

	| case result hangedProcess |
	
	case := self newTestCase: #hangedChildProcessTest.	
	case executionProcessMonitor allowTestToLeaveProcesses.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0.
		
	hangedProcess := forkedProcesses detect: [: each | each name = #hangedChildProcessTest].
	self assert: hangedProcess isTerminated
]

{ #category : #testing }
SUnitTestCopy >> testHangedChildProcessTestWhenLeftProcessIsConsideredAsFailure [

	| case result |

	case := self newTestCase: #hangedChildProcessTest.	
	case executionProcessMonitor failTestLeavingProcesses.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1
]

{ #category : #testing }
SUnitTestCopy >> testHangedTestDueToFailedChildProcess [

	| case result |
	executionEnvironmentClass beActive.
	case := self newTestCase: #hangedTestDueToFailedChildProcess.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1.

	self assertTerminationOfFailedChildProcesses
]

{ #category : #testing }
SUnitTestCopy >> testIgnoreDeprecationWarnings [
	| oldRaiseWarning |
	oldRaiseWarning := Deprecation raiseWarning.
	[ Deprecation raiseWarning: false.
	self deprecatedMessage.
	self assert: true ]
		ensure: [ Deprecation raiseWarning: oldRaiseWarning ]
]

{ #category : #testing }
SUnitTestCopy >> testIsNotRerunOnDebug [

	| case |

	case := self newTestCase: #testRanOnlyOnce.
	case run.
	case debug
]

{ #category : #testing }
SUnitTestCopy >> testLongRunningTest [

	| case result |
	self executionEnvironmentClass beActive.
	case := self newTestCase: #longRunningTest.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 0
		errors: 1
]

{ #category : #testing }
SUnitTestCopy >> testLongRunningTestThenGreenTest [

	| case result |
	self executionEnvironmentClass beActive.
	case := self newTestCase: #longRunningTest.
	result := case run.
	case := self newTestCase: #noop.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0
]

{ #category : #testing }
SUnitTestCopy >> testRaiseDeprecationWarnings [
	| case result |
	case := self newTestCase: #raiseDeprecationWarnings.
	result := case run.
	self assert: result defects asArray equals: (Array with: case).
	self
		assertForTestResult: result
		runCount: 1
		passed: 0
		failed: 1
		errors: 0
]

{ #category : #testing }
SUnitTestCopy >> testRan [

	| case |

	case := self newTestCase: #setRun.
	case resources do: [:each | each availableFor: case].
	[case setUp.
	case performTest] ensure: [
		self assert: case hasSetup.
		self assert: case hasRun.
		case tearDown.
		case cleanUpInstanceVariables].
	self assert: case hasSetup isNil.
	self assert: case hasRun isNil.
]

{ #category : #testing }
SUnitTestCopy >> testRanOnlyOnce [

	self assert: hasRanOnce ~= true.
	hasRanOnce := true
]

{ #category : #testing }
SUnitTestCopy >> testResult [

	| case result |

	case := self newTestCase: #noop.
	result := case run.

	self
		assertForTestResult: result
		runCount: 1
		passed: 1
		failed: 0
		errors: 0
]

{ #category : #testing }
SUnitTestCopy >> testRunning [

	10 milliSeconds wait
]

{ #category : #testing }
SUnitTestCopy >> testRunningLongTime [
	self timeLimit: 3 seconds.
	
	2 seconds wait
]

{ #category : #testing }
SUnitTestCopy >> testSelectorWithArg: anObject [
	"should not result in error"
]

{ #category : #testing }
SUnitTestCopy >> testShould [

	self
		should: [true];
		shouldnt: [false]
]

{ #category : #testing }
SUnitTestCopy >> testShouldIgnoreTimeLimitWhenTestProcessIsSuspended [
	"If you open debugger on test (by halt or error) and will not close it more then test time limit then following interaction with debugger will fail. 
	As simple fix watch dog should check that test process is not suspended. It of course will open possibility to hang test execution when tested code will suspend active process by incident. But we could live with it and probably it could be addressed too in future"
	| testProcess |
	self timeLimit: 30 milliSeconds.
	testProcess := Processor activeProcess.
	[ 50 milliSeconds wait. testProcess resume ] fork.
	testProcess suspend.
	self assert: true.
]

{ #category : #testing }
SUnitTestCopy >> testSuite [
	| suite result |
	suite := self classForTestSuite new.
	suite
		addTest: (self newTestCase: #noop);
		addTest: (self newTestCase: #fail);
		addTest: (self newTestCase: #error).
	result := suite run.
	self
		assertForTestResult: result
		runCount: 3
		passed: 1
		failed: 1
		errors: 1
]

{ #category : #testing }
SUnitTestCopy >> testWatchDogProcessShouldNotBeCatchedAsForkedProcess [
	| env |
	env := self executionEnvironment.

	self assertEmpty: env forkedProcesses
]

{ #category : #testing }
SUnitTestCopy >> testWithExceptionDo [

	self
		should: [self error: 'foo']
		raise: self defaultTestError
		withExceptionDo: [:exception |
			self assert: (exception description includesSubstring: 'foo')
		]
]
