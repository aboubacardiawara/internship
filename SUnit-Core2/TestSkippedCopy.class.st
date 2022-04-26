Class {
	#name : #TestSkippedCopy,
	#superclass : #Exception,
	#category : #'SUnit-Core2'
}

{ #category : #handling }
TestSkippedCopy >> defaultAction [
	"Nothing to do. If I am not handled I might trigger an Assertion failure later on."
]

{ #category : #handling }
TestSkippedCopy >> manageTestProcessBy: aProcessMonitorTestService [
	"It is special exception which do not represent the actual test failure.
	 So we just ignoring it"
]

{ #category : #handling }
TestSkippedCopy >> sunitAnnounce: aTestCase toResult: aTestResult [

	aTestResult addSkip: aTestCase
]
