Class {
	#name : #TestSuiteEndedCopy,
	#superclass : #TestCaseAnnouncementCopy,
	#category : #'SUnit-Core2'
}

{ #category : #'instance creation' }
TestSuiteEndedCopy class >> result: aResult [

	^ self new
		  testResult: aResult;
		  yourself
]
