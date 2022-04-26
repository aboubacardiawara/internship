Class {
	#name : #TestFailureCopy,
	#superclass : #Exception,
	#category : #'SUnit-Core2'
}

{ #category : #testing }
TestFailureCopy class >> captureIfSignalledWhenStepping [
	^self == TestFailureCopy
]

{ #category : #'camp smalltalk' }
TestFailureCopy >> isResumable [
	
	^ false
]

{ #category : #'camp smalltalk' }
TestFailureCopy >> sunitAnnounce: aTestCase toResult: aTestResult [
	aTestResult addFailure: aTestCase.
]
