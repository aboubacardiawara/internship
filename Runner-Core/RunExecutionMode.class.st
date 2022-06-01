"
I ececute a test suite then return its TestResult.
"
Class {
	#name : #RunExecutionMode,
	#superclass : #AbstractExecutionMode,
	#category : #'Runner-Core-Configuration'
}

{ #category : #execution }
RunExecutionMode class >> executeSuite: aTestSuite [

	| result |
	result := self defaultTestResultClass new.
	[ aTestSuite run: result ] ensure: [ 
		aTestSuite unsubscribe: TestAnnouncement ].

	^ result
]
