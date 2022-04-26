Class {
	#name : #ProcessMonitorTestServiceCopy,
	#superclass : #TestExecutionServiceCopy,
	#instVars : [
		'forkedProcesses',
		'testFailures',
		'shouldSuspendBackgroundFailures',
		'shouldFailTestLeavingProcesses',
		'shouldTerminateProcesses'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'fuel support' }
ProcessMonitorTestServiceCopy class >> fuelIgnoredInstanceVariableNames [
    ^#('forkedProcesses' 'suspendedBackgroundFailures')
]

{ #category : #settings }
ProcessMonitorTestServiceCopy class >> settingsForFailingStrategyOn: aBuilder [
	
	(aBuilder setting: #shouldFailTestLeavingProcesses)
		target: self;
		parent: self name ;
		default: false;
		label: 'Fail tests which left running processes' ;
		description: 'The test will be failed if it left running processes after the run.
For example following test will fail:
	testExample
		[ 10 seconds wait ] fork.
		self assert: true.
Tests should not leave the system dirty.
And this setting is to facilitate such rule relatively to background processes forked during the test.
See ProcessMonitorTestService comment for more details'
]

{ #category : #settings }
ProcessMonitorTestServiceCopy class >> settingsForTerminationStrategyOn: aBuilder [
	
	(aBuilder setting: #shouldTerminateProcesses)
		target: self;
		parent: self name ;
		default: true;
		label: 'Terminate all processes after the test' ;
		description: 'At the end of each test all forked processes will be terminated except when we are running in interractive mode under debugger. 
When debugger opens all control is up to the user.
But when we are running the test suite to get results it is a good practice to remove all garbage after the test. 
This setting is about doing it in automatic way.
See ProcessMonitorTestService comment for more details'
]

{ #category : #settings }
ProcessMonitorTestServiceCopy class >> settingsOn: aBuilder [
	super settingsOn: aBuilder.
	
	self
		settingsForFailingStrategyOn: aBuilder;
		settingsForTerminationStrategyOn: aBuilder
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy class >> shouldFailTestLeavingProcesses [
	^shouldFailTestLeavingProcesses ifNil: [ shouldFailTestLeavingProcesses := false ]
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy class >> shouldFailTestLeavingProcesses: aBoolean [
	shouldFailTestLeavingProcesses := aBoolean
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy class >> shouldTerminateProcesses [
	^ shouldTerminateProcesses ifNil: [ shouldTerminateProcesses := true ]
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy class >> shouldTerminateProcesses: anObject [
	shouldTerminateProcesses := anObject
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> allowRunningProcessesToFinish [
	"The idea here is to allow most trivial processes to finish themselves.
	So they would not be a garbage left by test.
	For example following test would left one process at the end:
		>>testExample
			[ Processor yield ] fork 
	But if we would give it a chance to finish it would do this. 
	So in this method we give running processes a chance to finish:
		- yield execution until number of rest processes are reduced"
	| runningProcesses restProcesses |
	runningProcesses := self runningProcesses.
	runningProcesses ifEmpty: [ ^self ].
	(runningProcesses allSatisfy: [ :each | each priority = Processor activePriority ]) ifFalse: [ 
			"If there is any process with different priority than active one 
			we can't do anything to allow finish all of them"
			^self ].
	
	[Processor yield.
	restProcesses := runningProcesses reject: [ :each | each isTerminated ].
	restProcesses size = runningProcesses size or: [ restProcesses isEmpty ]] 
		whileFalse: [ runningProcesses := restProcesses ]
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> allowTestToLeaveProcesses [

	shouldFailTestLeavingProcesses := false
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> cleanUpAfterTest [
	super cleanUpAfterTest.
	
	shouldTerminateProcesses ifTrue: [ 
		self terminateRunningProcesses].
	forkedProcesses removeAll.
	testFailures removeAll.
	self enableBackgroudFailuresSuspension.
	self useDefaultFailingStrategyForRunningProcesses.
	self useDefaultTerminationStrategyForRunningProcesses
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> disableBackgroudFailuresSuspension [

	shouldSuspendBackgroundFailures := false
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> disableProcessesTermination [

	shouldTerminateProcesses := false
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> enableBackgroudFailuresSuspension [

	shouldSuspendBackgroundFailures := true
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> ensureNoBackgroundFailures [
	self isMainTestProcessFailed & self shouldPassBackgroundFailures ifTrue: [ 
		"We don't need extra error about failed process when all errors are shown to the user: 
			- if they were not suspended and were passed
			- if main test process is also fail (and therefore test fails anyway)"
		^self ].
	self suspendedBackgroundFailures ifEmpty: [ ^self ].

	"COMMENT FOR DEBUGGER STOPPED HERE:
	TestFailedByForkedProcess notifies about background failures.
	Test failed because forked process failed (even if main test process was completed without errors).
	See ProcessMonitorTestService comment for more details"
	[TestFailedByForkedProcessCopy signalFrom: executionEnvironment] 
		on: UnhandledError do: [ :e | 
			self passBackgroundFailures.
			e pass]
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> ensureNoRunningProcesses [
	"If test was already failed due to an error in the main test process 
	we do not need an extra failure about left processes"
	self isMainTestProcessFailed ifTrue: [ ^self ].	
	self runningProcesses ifEmpty: [ ^self ].
	shouldFailTestLeavingProcesses ifFalse: [ ^self ].
	
	"COMMENT FOR DEBUGGER STOPPED HERE:
	TestLeftRunningProcess notifies that forked processes are still running when test completes.
	Test failed because test left the system in dirty state.
	Left running processes can affect the result of other tests 
	and even the general system behavior after test run.
	This protection can be disabled globaly in settings or in test method and setUp:
		self executionProcessMonitor allowTestToLeaveProcesses
	See ProcessMonitorTestService comment for more details"
	TestLeftRunningProcessCopy signalFrom: executionEnvironment
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> estLeftRunningProcessClass [
	^ TestLeftRunningProcessCopy
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> failTestLeavingProcesses [

	shouldFailTestLeavingProcesses := true
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> forkedProcesses [
	^ forkedProcesses
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> forkedProcesses: anObject [
	forkedProcesses := anObject
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> handleBackgroundException: anUnhandledException [
	
	self handleException: anUnhandledException.
	
	anUnhandledException pass
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> handleCompletedTest [
	super handleCompletedTest.
	
	self allowRunningProcessesToFinish.
	self ensureNoBackgroundFailures.
	self ensureNoRunningProcesses
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> handleException: anException [
	super handleException: anException.
	
	anException manageTestProcessBy: self
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> handleNewProcess: aProcess [
	super handleNewProcess: aProcess.
	
	forkedProcesses add: aProcess.
	
	aProcess on: UnhandledException do: [ :err |
		self handleBackgroundException: err]
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> handleUnhandledException: anUnhandledException [
	self recordTestFailure: anUnhandledException.
	
	executionEnvironment isMainTestProcessActive ifTrue: [ ^self passBackgroundFailures ].
	
	shouldSuspendBackgroundFailures ifTrue: [
		self suspendBackgroundFailure: anUnhandledException]
]

{ #category : #initialization }
ProcessMonitorTestServiceCopy >> initialize [
	super initialize.
	
	self enableBackgroudFailuresSuspension.
	self useDefaultFailingStrategyForRunningProcesses.
	self useDefaultTerminationStrategyForRunningProcesses.
	forkedProcesses := WeakSet new.
	testFailures := OrderedIdentityDictionary new.
]

{ #category : #testing }
ProcessMonitorTestServiceCopy >> isMainTestProcessFailed [
	^self isTestProcessFailed: executionEnvironment mainTestProcess
]

{ #category : #testing }
ProcessMonitorTestServiceCopy >> isTestProcessFailed: aProcess [

	^testFailures at: aProcess ifPresent: [ true ] ifAbsent: [ false ]
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> passBackgroundFailures [	
	self disableBackgroudFailuresSuspension.
	self disableProcessesTermination.
		
	testFailures keys 
		select: [:each | each isSuspended ] 
		thenDo: [:each | each resume ]
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> recordTestFailure: anException [

	| activeProcess |
	activeProcess := Processor activeProcess.
	activeProcess isTerminating ifTrue: [ 
		"Do nothing for exceptions during process termination"
		^self ]. 
	
	testFailures at: activeProcess put: anException
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> runningProcesses [
	"Suspended processes are not scheduled and therefore they are not considered as running"
	^ forkedProcesses reject: [ :each | each isTerminated or: [ each isSuspended ]]
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> shouldFailTestLeavingProcesses [
	^ shouldFailTestLeavingProcesses
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> shouldFailTestLeavingProcesses: anObject [
	shouldFailTestLeavingProcesses := anObject
]

{ #category : #testing }
ProcessMonitorTestServiceCopy >> shouldPassBackgroundFailures [
	^shouldSuspendBackgroundFailures not
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> shouldSuspendBackgroundFailures [
	^ shouldSuspendBackgroundFailures
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> shouldSuspendBackgroundFailures: anObject [
	shouldSuspendBackgroundFailures := anObject
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> shouldTerminateProcesses [
	^ shouldTerminateProcesses
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> shouldTerminateProcesses: anObject [
	shouldTerminateProcesses := anObject
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> suspendBackgroundFailure: anException [

	| activeProcess |
	activeProcess := Processor activeProcess.
	activeProcess isTerminating ifTrue: [ 
		"Do nothing if process is under termination"
		^self ]. 
	
	self recordTestFailure: anException.
	activeProcess suspend
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> suspendedBackgroundFailures [
	^ testFailures associationsSelect: [ :each | each key isSuspended ]
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> terminateProcessesAfterTest [

	shouldTerminateProcesses := true
]

{ #category : #controlling }
ProcessMonitorTestServiceCopy >> terminateRunningProcesses [
	forkedProcesses do: [:each | each terminate]
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> testBackgroundFailures [
	^ testFailures copy 
		removeKey: executionEnvironment mainTestProcess ifAbsent: [ ];
		yourself
]

{ #category : #accessing }
ProcessMonitorTestServiceCopy >> testFailures [
	^ testFailures
]

{ #category : #initialization }
ProcessMonitorTestServiceCopy >> useDefaultFailingStrategyForRunningProcesses [

	shouldFailTestLeavingProcesses := self class shouldFailTestLeavingProcesses.
]

{ #category : #initialization }
ProcessMonitorTestServiceCopy >> useDefaultTerminationStrategyForRunningProcesses [
	shouldTerminateProcesses := self class shouldTerminateProcesses
]
