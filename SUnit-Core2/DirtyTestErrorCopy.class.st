Class {
	#name : #DirtyTestErrorCopy,
	#superclass : #Error,
	#instVars : [
		'executionEnvironment'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'instance creation' }
DirtyTestErrorCopy class >> signalFrom: aTestExecutionEnvironment [
	^self new 
		executionEnvironment: aTestExecutionEnvironment;
		signal
]

{ #category : #accessing }
DirtyTestErrorCopy >> executionEnvironment [

	^ executionEnvironment
]

{ #category : #accessing }
DirtyTestErrorCopy >> executionEnvironment: anObject [

	executionEnvironment := anObject
]

{ #category : #'exception handling' }
DirtyTestErrorCopy >> manageTestProcessBy: aProcessMonitorTestService [
	"Do nothing because I am not an error during actual test execution.
	My subclasses only represent the dirty system state at the end of test"
]

{ #category : #'exception handling' }
DirtyTestErrorCopy >> sunitAnnounce: aTestCase toResult: aTestResult [

	executionEnvironment isMainTestProcessFailed ifTrue: [ 
		"The main test process errors are handled by SUnit using same message.
		So the actual domain test error is already counted in result" 
		^ self ].

	"If main test process was completed successfully
	we should mark test as failed due to dirty system state"
	aTestResult addError: aTestCase
]
