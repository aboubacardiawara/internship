Class {
	#name : #TestServiceExampleCopy,
	#superclass : #TestExecutionServiceCopy,
	#instVars : [
		'forkedProcesses',
		'isCleanUpDone',
		'isCompletedTestHandled',
		'signaledExceptions'
	],
	#category : #'SUnit-Core2'
}

{ #category : #testing }
TestServiceExampleCopy class >> isEnabledByDefault [
	^false
]

{ #category : #controlling }
TestServiceExampleCopy >> cleanUpAfterTest [
	super cleanUpAfterTest.
	
	isCleanUpDone := true
]

{ #category : #accessing }
TestServiceExampleCopy >> forkedProcesses [
	^ forkedProcesses
]

{ #category : #controlling }
TestServiceExampleCopy >> handleCompletedTest [
	super handleCompletedTest.
	
	isCompletedTestHandled := true
]

{ #category : #controlling }
TestServiceExampleCopy >> handleException: anUnhandledException [
	super handleException: anUnhandledException.
	
	signaledExceptions add: anUnhandledException
]

{ #category : #controlling }
TestServiceExampleCopy >> handleNewProcess: aProcess [
	super handleNewProcess: aProcess.
	
	forkedProcesses add: aProcess
]

{ #category : #initialization }
TestServiceExampleCopy >> initialize [ 
	super initialize.
	
	forkedProcesses := OrderedCollection new.
	signaledExceptions := OrderedCollection new.
	isCleanUpDone := false.
	isCompletedTestHandled := false
]

{ #category : #accessing }
TestServiceExampleCopy >> isCleanUpDone [
	^ isCleanUpDone
]

{ #category : #accessing }
TestServiceExampleCopy >> isCompletedTestHandled [
	^ isCompletedTestHandled
]

{ #category : #accessing }
TestServiceExampleCopy >> signaledExceptions [
	^ signaledExceptions
]
