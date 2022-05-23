Class {
	#name : #TestFailureTestCase,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'classForTestFailure'
	],
	#category : #'SUnit-Tests-Core'
}

{ #category : #tests }
TestFailureTestCase class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#classForTestFailure -> TestFailure) };
		  yourself
]

{ #category : #accessing }
TestFailureTestCase >> classForTestFailure [
	^ classForTestFailure
]

{ #category : #setter }
TestFailureTestCase >> classForTestFailure: aClass [ 
	classForTestFailure := aClass
]

{ #category : #tests }
TestFailureTestCase >> testCaptureIfSignalledWhenStepping [

	self assert: self classForTestFailure captureIfSignalledWhenStepping.
	self deny:
		(self classForTestFailure allSubclasses anySatisfy: [ :c | 
			 c captureIfSignalledWhenStepping ])
]
