Class {
	#name : #TestCaseAnnouncementCopy,
	#superclass : #Announcement,
	#instVars : [
		'testCase',
		'testSelector',
		'testResult'
	],
	#category : #'SUnit-Core2'
}

{ #category : #testing }
TestCaseAnnouncementCopy >> hasErrors [
	"Return true if the test result has errors."

	^ testResult hasErrors
]

{ #category : #testing }
TestCaseAnnouncementCopy >> hasFailures [
	"Return true if the test result has failures."

	^ testResult hasFailures
]

{ #category : #testing }
TestCaseAnnouncementCopy >> hasPassed [
	"Return true if the test has passed."

	^ testResult hasPassed
]

{ #category : #accessing }
TestCaseAnnouncementCopy >> testCase [
	"Returns the test case."

	^ testCase
]

{ #category : #accessing }
TestCaseAnnouncementCopy >> testCase: aTestCase [
	"Sets the test case to the given test case."

	testCase := aTestCase
]

{ #category : #accessing }
TestCaseAnnouncementCopy >> testResult [
	"Returns the test result."

	^ testResult
]

{ #category : #accessing }
TestCaseAnnouncementCopy >> testResult: aTestResult [
	"Sets the test result to the given test result."

	testResult := aTestResult
]

{ #category : #accessing }
TestCaseAnnouncementCopy >> testSelector [
	"Returns the test selector."

	^ testSelector
]

{ #category : #accessing }
TestCaseAnnouncementCopy >> testSelector: aSymbol [
	"Sets the test selector to the given symbol."

	testSelector := aSymbol
]
