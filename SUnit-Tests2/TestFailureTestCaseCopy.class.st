Class {
	#name : #TestFailureTestCaseCopy,
	#superclass : #TestCase,
	#category : #'SUnit-Tests2'
}

{ #category : #tests }
TestFailureTestCaseCopy >> testCaptureIfSignalledWhenStepping [
	self assert: TestFailure captureIfSignalledWhenStepping.
	self deny: (TestFailure allSubclasses anySatisfy: [:c|c captureIfSignalledWhenStepping])
]
