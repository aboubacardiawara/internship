Class {
	#name : #ResumableTestFailureTestCaseCopy,
	#superclass : #TestCaseCopy,
	#instVars : [
		'duplicateFailureLog'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #history }
ResumableTestFailureTestCaseCopy class >> lastStoredRun [
	^ ((Dictionary new) add: (#passed->((Set new) add: #testResumable; yourself)); add: (#timeStamp->'22 November 2008 10:11:35 pm'); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #'test data' }
ResumableTestFailureTestCaseCopy >> errorTest [
	1 zork
]

{ #category : #'test data' }
ResumableTestFailureTestCaseCopy >> failureTest [
	self
		assert: false description: 'You should see me' resumable: true; 
		assert: false description: 'You should see me too' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true
]

{ #category : #logging }
ResumableTestFailureTestCaseCopy >> logFailure: aString [
	duplicateFailureLog add: aString.
	super logFailure: aString.
]

{ #category : #'test data' }
ResumableTestFailureTestCaseCopy >> okTest [
	self assert: true
]

{ #category : #'test data' }
ResumableTestFailureTestCaseCopy >> regularTestFailureTest [
	self assert: false description: 'You should see me'
]

{ #category : #'test data' }
ResumableTestFailureTestCaseCopy >> resumableTestFailureTest [
	self
		assert: false description: 'You should see more than me' resumable: true; 
		assert: false description: 'You should see more than me' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true
]

{ #category : #running }
ResumableTestFailureTestCaseCopy >> setUp [
	super setUp.
	duplicateFailureLog := OrderedCollection with: 'In set up'.
]

{ #category : #running }
ResumableTestFailureTestCaseCopy >> tearDown [
	self deny: 'You should not see me' = duplicateFailureLog last
			description: 'We saw the ''You should not see me'' failure'.
	self deny: 'You should see more than me' = duplicateFailureLog last
			description: 'We did not see more than a ''You should see more than me'' failure'.
	super tearDown
]

{ #category : #tests }
ResumableTestFailureTestCaseCopy >> testResumable [
	| result suite |
	suite := self classForTestSuite new.
	suite addTest: (self class selector: #errorTest).
	suite addTest: (self class selector: #regularTestFailureTest).
	suite addTest: (self class selector: #resumableTestFailureTest).
	suite addTest: (self class selector: #okTest).
	result := suite run.
	self
		assert: result failures size equals: 2;
		assert: result errors size equals: 1
]
