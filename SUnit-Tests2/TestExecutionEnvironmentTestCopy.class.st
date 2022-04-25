Class {
	#name : #TestExecutionEnvironmentTestCopy,
	#superclass : #TestExecutionEnvironmentTestCaseCopy,
	#instVars : [
		'exampleTestBlock',
		'ranTest'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
TestExecutionEnvironmentTestCopy class >> defaultTimeLimit [
	^9.1 seconds
]

{ #category : #running }
TestExecutionEnvironmentTestCopy >> createTestService [
	^TestServiceExample new
]

{ #category : #helpers }
TestExecutionEnvironmentTestCopy >> exampleTest [
	"It is a test case to be used for testing how testCase is running by environment"

	exampleTestBlock cull: self
]

{ #category : #accessing }
TestExecutionEnvironmentTestCopy >> exampleTestBlock: anObject [
	exampleTestBlock := anObject
]

{ #category : #helpers }
TestExecutionEnvironmentTestCopy >> runTestWith: aBlock [

	| currentServices |
	ranTest := self class selector: #exampleTest.
	currentServices := executionEnvironment services copy.
	executionEnvironment activated. "activation registerrs all default services"
	executionEnvironment services: currentServices.
	
	ranTest exampleTestBlock: aBlock.
	executionEnvironment runTestCase: ranTest
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testActivationShouldRegisterDefaultServices [

	[
		TestServiceExample isEnabled: true.
		executionEnvironment removeAllServices.
		
		executionEnvironment activated.
		self assert: (executionEnvironment services 
						anySatisfy: [:each | each class = TestServiceExample ])

	] ensure: [TestServiceExample isEnabled: false]
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testActivationShouldSetUpMainTestProcess [

	executionEnvironment activated.
	
	self assert: executionEnvironment mainTestProcess equals: Processor activeProcess
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testActivationShouldStartWatchDog [

	executionEnvironment activated.
	
	self assert: executionEnvironment watchDogProcess isTerminated not
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testCleanUpAlsoDisabledTestServices [
	| testService2 |
	testService disable.
	testService2 := self createTestService.
	testService2 enable.
	executionEnvironment registerService: testService2.
	
	executionEnvironment cleanUpAfterTest.
	
	self assert: testService isCleanUpDone.
	self assert: testService2 isCleanUpDone
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testCleanUpTestServicesAfterFailedTest [

	[ 
		self runTestWith: [ self error: 'test error'] 
	] onErrorDo: [].

	self assert: testService isCleanUpDone
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testCleanUpTestServicesAfterSucceedTest [

	self runTestWith: [ #success].

	self assert: testService isCleanUpDone
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testCleanUpTestServicesAfterTerminatedTest [

	self runWithNoHandlers: [
		self runTestWith: [ Processor terminateActive]].

	self assert: testService isCleanUpDone
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testDeactivation [

	executionEnvironment activated.
	self deny: executionEnvironment watchDogProcess isTerminated.
	
	executionEnvironment deactivated.
	self assert: executionEnvironment watchDogProcess isTerminated.
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testDisableGivenServiceWhenItExists [

	executionEnvironment disableService: TestServiceExample.

	self deny: testService isEnabled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testDisableGivenServiceWhenItIsNotRegistered [

	executionEnvironment removeAllServices.
	
	executionEnvironment disableService: TestServiceExample
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testDoesNotCleanUpTestServicesUntilTestErrorIsNotHandled [

	self runWithNoHandlers: [ 
		[ self runTestWith: [ self error: 'test error'] ]
			on: UnhandledError do: [:exc | 
				self deny: testService isCleanUpDone.
	]].

	self assert: testService isCleanUpDone
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testDoesNotNotifyTestServicesAboutTerminatedTest [

	self runWithNoHandlers: [ 
		self runTestWith: [Processor terminateActive].
	].

	self deny: testService isCompletedTestHandled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testEnableGivenServiceWhenItExists [

	| actual |
	testService disable.
	
	actual := executionEnvironment enableService: TestServiceExample.

	self assert: actual identicalTo: testService.
	self assert: testService isEnabled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testEnableGivenServiceWhenItIsNotRegistered [

	executionEnvironment removeAllServices.
	
	testService := executionEnvironment enableService: TestServiceExample.

	self assert: testService identicalTo: (executionEnvironment findService: TestServiceExample).
	self assert: testService isEnabled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testEnableGivenServiceWithConfigurationBlock [

	| actual |
	executionEnvironment enableService: TestServiceExample using: [:service | actual := service] .

	self assert: actual identicalTo: testService
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testFindService [

	self assert: (executionEnvironment findService: TestServiceExample) identicalTo: testService
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testGettingEnvironmentFromTestCase [

	| actual |
	executionEnvironment beActiveDuring: [ 
		actual := self executionEnvironment.
	].

	self assert: actual identicalTo: executionEnvironment
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testHandleForkedProcessesByAllServices [

	| process |
	executionEnvironment activated.
	
	process := [  ] newProcess name: 'test process'.
	executionEnvironment prepareForNewProcess: process.
	
	self assert: (testService forkedProcesses includes: process)
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testHasEmptyServicesByDefault [

	executionEnvironment := testExecutionEnv new.
	self assert: executionEnvironment services isEmpty
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testIgnoreLongTestWhenItIsSuspendedAsUnderDebug [
	| timeOutSignaled testProcess |
	timeOutSignaled := false.
	testProcess := [
		executionEnvironment activated.		
		[ self runTestWith: [ 
				executionEnvironment maxTimeForTest: 10 milliSeconds.
				Processor activeProcess suspend "it simulates the under debugger condition"]
		] on: TestTookTooMuchTime do: [ :err | timeOutSignaled := true ]		
	] forkAt: Processor activePriority + 1.

	self deny: timeOutSignaled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testIgnoreWatchDogProcessAsForkedOne [
	
	executionEnvironment activated.
	executionEnvironment prepareForNewProcess: executionEnvironment watchDogProcess.
	
	self deny: (testService forkedProcesses includes: executionEnvironment watchDogProcess)
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testIsMainTestProcess [

	executionEnvironment activated.
	
	self assert: (executionEnvironment isMainTestProcess: Processor activeProcess).
	
	self deny: (executionEnvironment isMainTestProcess: [] newProcess).
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testIsMainTestProcessActive [

	executionEnvironment activated.
	
	self assert: (executionEnvironment isMainTestProcessActive).
	
	self runWithNoHandlers: [ 
		self deny: (executionEnvironment isMainTestProcessActive) ]
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testIsMainTestProcessFailed [

	| processMonitor |
	processMonitor := testMonitorServiceClass new.
	executionEnvironment registerService: processMonitor.		
	executionEnvironment activated.
	
	self deny: executionEnvironment isMainTestProcessFailed.
	
	processMonitor recordTestFailure: Error new.
	self assert: executionEnvironment isMainTestProcessFailed
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testNotifyOnlyEnabledTestServices [
	| testService2 testService3 |
	testService disable.
	testService2 := self createTestService.
	testService2 disable.
	testService3 := self createTestService.
	testService3 enable.
	executionEnvironment registerService: testService2; registerService: testService3.
	
	self runTestWith: [ #success ].
	
	self deny: testService isCompletedTestHandled.
	self deny: testService2 isCompletedTestHandled.
	self assert: testService3 isCompletedTestHandled.
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testNotifyTestServicesAboutCompletedFailedTest [

	[
		self runTestWith: [ self error: 'test error' ]
	] onErrorDo: [ self deny: testService isCompletedTestHandled ].

	self assert: testService isCompletedTestHandled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testNotifyTestServicesAboutCompletedTest [

	self runTestWith: [
		self deny: testService isCompletedTestHandled].

	self assert: testService isCompletedTestHandled
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testNotifyTestServicesAboutHalt [
	| errorPassed expectedException|
	errorPassed := false.
	expectedException := Halt new messageText: 'test halt'.
	self runWithNoHandlers: [	
		[self runTestWith: [ expectedException signal]] on: Halt do: [:actualException | 
			errorPassed := true.
			self assert: actualException equals: expectedException.
			self assert: (testService signaledExceptions includes: actualException)].
	].

	self assert: errorPassed
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testNotifyTestServicesAboutUnhandledError [
	| errorPassed expectedException|

	errorPassed := false.
	expectedException := Error new messageText: 'test error'.
	
	self runWithNoHandlers: [	
		[self runTestWith: [ expectedException signal]] on: UnhandledError do: [:actualException | 
			errorPassed := true.
			self assert: actualException exception equals: expectedException.
			self assert: (testService signaledExceptions includes: actualException)].
	].

	self assert: errorPassed
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testNotifyTestServicesAboutWarning [
	| errorPassed expectedException|
	errorPassed := false.
	expectedException := Warning new messageText: 'test halt'.
	self runWithNoHandlers: [	
		[self runTestWith: [ expectedException signal]] on: Warning do: [:actualException | 
			errorPassed := true.
			self assert: actualException equals: expectedException.
			self assert: (testService signaledExceptions includes: actualException)].
	].

	self assert: errorPassed
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testRegisteredServiceShouldBeBoundToEnvironment [

	self assert: testService executionEnvironment equals: executionEnvironment
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testResetWatchDogTimeoutBetweenFailedTests [

	[self runTestWith: [ 
		executionEnvironment maxTimeForTest: self defaultTimeLimit + 10 seconds. 
		self error: 'test error']
	]	onErrorDo: [].
	
	self runTestWith: [ 
		self assert: executionEnvironment maxTimeForTest equals: self defaultTimeLimit]
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testResetWatchDogTimeoutBetweenTests [

	self runTestWith: [ executionEnvironment maxTimeForTest: self defaultTimeLimit + 10 seconds].
	
	self runTestWith: [ 
		self assert: executionEnvironment maxTimeForTest equals: self defaultTimeLimit]
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testRunningTest [
	| executed |
	executed := false.
	
	self runTestWith: [ 
		self assert: executionEnvironment testCase identicalTo: ranTest.
		executed := true
	].

	self assert: executed
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testRunningTestShouldSetDefaultTimeLimit [

	self runTestWith: [ 
		self assert: executionEnvironment maxTimeForTest equals: self defaultTimeLimit
	]
]

{ #category : #tests }
TestExecutionEnvironmentTestCopy >> testRunningTooLongTest [

	self 
		should: [
			self runTestWith: [ 
				executionEnvironment maxTimeForTest: 10 milliSeconds.
				20 milliSeconds wait]]
		raise: TestTookTooMuchTime
]
