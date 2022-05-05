Class {
	#name : #TestExecutionEnvironmentCopy,
	#superclass : #ExecutionEnvironment,
	#instVars : [
		'watchDogProcess',
		'watchDogSemaphore',
		'testCase',
		'maxTimeForTest',
		'testCompleted',
		'services',
		'mainTestProcess'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'fuel support' }
TestExecutionEnvironmentCopy class >> fuelIgnoredInstanceVariableNames [
    ^#('watchDogProcess' 'watchDogSemaphore' 'mainTestProcess')
]

{ #category : #settings }
TestExecutionEnvironmentCopy class >> settingsOn: aBuilder [
	<systemsettings>	

	TestExecutionServiceCopy defaultServiceClasses do: [ :each | 
		each settingsOn: aBuilder]
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> activated [

	mainTestProcess := Processor activeProcess.
	self registerDefaultServices.
	self startWatchDog
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> backgroundFailures [
	^self processMonitor testBackgroundFailures
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> cleanUpAfterTest [
	"Cleanup is performed over all services (enabled and disabled) 
	because service can change its state during test execution
	(user can disable it in the middle of test)"
	
	services do: [ :each | each cleanUpAfterTest]
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> deactivated [

	watchDogProcess ifNotNil: [watchDogProcess terminate]
]

{ #category : #private }
TestExecutionEnvironmentCopy >> disableService: aTestExecutionServiceClass [

	| service |
	service := self findService: aTestExecutionServiceClass ifAbsent: [^self].
	service disable
]

{ #category : #private }
TestExecutionEnvironmentCopy >> enableService: aTestExecutionServiceClass [

	| service |
	service := self findService: aTestExecutionServiceClass ifAbsent: [
		self registerService: aTestExecutionServiceClass new].
	service enable.
	^service
]

{ #category : #private }
TestExecutionEnvironmentCopy >> enableService: aTestExecutionServiceClass using: aBlock [

	| service |
	service := self enableService: aTestExecutionServiceClass.
	aBlock value: service.
	^service
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> enabledServicesDo: aBlock [
	
	services select: [ :each | each isEnabled ] thenDo: aBlock
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> failures [
	^self processMonitor testFailures
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> findService: aTestExecutionServiceClass [
	^services detect: [:each | each isKindOf: aTestExecutionServiceClass]
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> findService: aTestExecutionServiceClass ifAbsent: absentBlock [
	^services detect: [:each | each isKindOf: aTestExecutionServiceClass] ifNone: absentBlock
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> forkedProcesses [
	^ self processMonitor forkedProcesses
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> handleCompletedTest [
	
	self enabledServicesDo: [ :each | each handleCompletedTest].
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> handleException: anException [

	self enabledServicesDo: [ :each | each handleException: anException].
	
	anException pass
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> handleNewProcess: aProcess [

	self enabledServicesDo: [ :each | each handleNewProcess: aProcess ].
]

{ #category : #initialization }
TestExecutionEnvironmentCopy >> initialize [
	super initialize.
	services := OrderedCollection new.
	testCompleted := false
]

{ #category : #testing }
TestExecutionEnvironmentCopy >> isMainTestProcess: aProcess [
	^mainTestProcess = aProcess
]

{ #category : #testing }
TestExecutionEnvironmentCopy >> isMainTestProcessActive [
	^self isMainTestProcess: Processor activeProcess
]

{ #category : #testing }
TestExecutionEnvironmentCopy >> isMainTestProcessFailed [
	^self processMonitor isMainTestProcessFailed
]

{ #category : #testing }
TestExecutionEnvironmentCopy >> isTest [
	^true
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> mainTestProcess [
	^ mainTestProcess
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> maxTimeForTest [
	^ maxTimeForTest
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> maxTimeForTest: aDuration [
	maxTimeForTest := aDuration.
	watchDogSemaphore ifNotNil: [ 
		"we need restart watch dog timer for new timeout"
		watchDogSemaphore signal ].
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> prepareForNewProcess: aProcess [
	| processBlock |
	watchDogProcess ifNil: [ ^self ]. "we should not catch watchDogProcess which is always the first one"
	aProcess suspendedContext sender ifNotNil: [ ^self ]. "Some existing tests in system create processes on arbitrary block and then check suspendedContext state. Without this 'if' all these tests will fail"
	processBlock := aProcess suspendedContext receiver.
	processBlock isClosure ifFalse: [ ^self ]. "same case as in previous comment"
	
	self handleNewProcess: aProcess
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> processMonitor [
	^self findService: ProcessMonitorTestServiceCopy
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> registerDefaultServices [

	TestExecutionServiceCopy enabledServiceClasses do: [ :each |
		self registerService: each new	
	 ]
]

{ #category : #private }
TestExecutionEnvironmentCopy >> registerService: aTestExecutionService [

	aTestExecutionService executionEnvironment: self.
	services add: aTestExecutionService.
	^aTestExecutionService
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> removeAllServices [

	services removeAll
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> runTestCase: aTestCase [
	testCase := aTestCase.
	maxTimeForTest := testCase defaultTimeLimit.
	testCompleted := false.
	watchDogSemaphore signal. "signal about new test case"	
	[self runTestCaseUnderWatchdog: aTestCase] ensure: [
		testCompleted := true.
		watchDogSemaphore signal.  "signal that test case is completed"	
		self cleanUpAfterTest	].
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> runTestCaseUnderWatchdog: aTestCase [
	
	[
		[aTestCase runCase] ensure: [
			"Terminated test is not considered as completed (user just closed a debugger for example)"
			mainTestProcess isTerminating ifFalse: [ 
				self handleCompletedTest ]]
	] on: Exception do: [ :err | 
			self handleException: err 
	]
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> runTestsBy: aBlock [

	aBlock value
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> services [
	^ services
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> services: anObject [
	services := anObject
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> startWatchDog [
	
	watchDogSemaphore := Semaphore new.
	watchDogProcess := [self watchDogLoop] newProcess.
	"Watchdog needs to run at high priority to do its job (but not at timing priority)"
	watchDogProcess 
		name: 'Tests execution watch dog';
		priority: Processor timingPriority-1;
		resume
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> testCase [
	^ testCase
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> testCase: anObject [
	testCase := anObject
]

{ #category : #controlling }
TestExecutionEnvironmentCopy >> watchDogLoop [

	| timeIsGone |
	[	"waiting new test case" 
		watchDogSemaphore wait. 
		"waiting while test completes"
		[timeIsGone := watchDogSemaphore wait: maxTimeForTest.
		testCompleted] whileFalse: [ 
			"this subloop allows to dynamically change time limit and restart watch dog"
			timeIsGone ifTrue: [
				"The main purpose of following condition is to ignore timeout when test is under debug.
				Test process is suspended only when it is debugged"
				mainTestProcess isSuspended ifFalse: [
					mainTestProcess signalException: TestTookTooMuchTimeCopy new]]	].
	] repeat
]

{ #category : #accessing }
TestExecutionEnvironmentCopy >> watchDogProcess [
	^ watchDogProcess
]
