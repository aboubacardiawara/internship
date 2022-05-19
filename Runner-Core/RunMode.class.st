Class {
	#name : #RunMode,
	#superclass : #ExecutionConfiguration,
	#category : #'Runner-Core-Configuration'
}

{ #category : #execution }
RunMode class >> executeSuite: aTestSuite [

	| result |
	result := self defaultTestResultClass new.
	" The block defines how to interact with the suite. run with a result or debug"
	[ aTestSuite run: result ] ensure: [ 
		aTestSuite unsubscribe: TestAnnouncement ].

	^ result
]
