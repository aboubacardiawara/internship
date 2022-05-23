Class {
	#name : #TestFailureTestCaseCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'classForTestFailure'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #tests }
TestFailureTestCaseCopy class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#classForTestFailure -> TestFailure) };
		  yourself
]

{ #category : #accessing }
TestFailureTestCaseCopy >> classForTestFailure [
	^ classForTestFailure
]

{ #category : #setter }
TestFailureTestCaseCopy >> classForTestFailure: aClass [ 
	classForTestFailure := aClass
]

{ #category : #tests }
TestFailureTestCaseCopy >> testCaptureIfSignalledWhenStepping [

	self assert: self classForTestFailure captureIfSignalledWhenStepping.
	self deny:
		(self classForTestFailure allSubclasses anySatisfy: [ :c | 
			 c captureIfSignalledWhenStepping ])
]
