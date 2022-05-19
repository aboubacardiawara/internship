Class {
	#name : #DebugMode,
	#superclass : #ExecutionConfiguration,
	#category : #'Runner-Core-Configuration'
}

{ #category : #execution }
DebugMode class >> executeSuite: aTestSuite [

	| result |
	result := self defaultTestResultClass new.
	" The block defines how to interact with the suite. run with a result or debug"
	[ aTestSuite debug ] ensure: [ 
		aTestSuite unsubscribe: TestAnnouncement ].

	^ result
]
