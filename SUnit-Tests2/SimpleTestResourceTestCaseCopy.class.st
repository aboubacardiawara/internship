Class {
	#name : #SimpleTestResourceTestCaseCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'resource',
		'simpleRessourceClass',
		'simpleTestRessourceTestCaseClass'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #history }
SimpleTestResourceTestCaseCopy class >> lastStoredRun [
	^ ((Dictionary new) add: (#passed->((Set new) add: #testResourceInitRelease; add: #testResourcesCollection; yourself)); add: (#timeStamp->'22 November 2008 10:11:35 pm'); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
SimpleTestResourceTestCaseCopy class >> resources [
	^Array with: SimpleTestResourceCopy
]

{ #category : #accessing }
SimpleTestResourceTestCaseCopy class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase: {
			#simpleRessourceClass -> SimpleTestResourceCopy.
			#simpleTestRessourceTestCaseClass -> SimpleTestResourceTestCaseCopy
			};
		yourself
]

{ #category : #utilities }
SimpleTestResourceTestCaseCopy >> clearOuterResourceStateDuring: aBlock [
	"This self-testing test must clear the outer state of its resources before starting and after finishing, so that it can construct test cases and suites of itself and test them."
	
	self
		assert: self simpleRessourceClass isAlreadyAvailable
		description: 'The resource was not set up for the test'.
	self simpleRessourceClass reset.
	self
		deny: self simpleRessourceClass isAlreadyAvailable
		description: 'The resource was still set up before we began the run'.
	^aBlock
		ensure:
			[self
				deny: self simpleRessourceClass isAlreadyAvailable
				description: 'The resource was still set up after we finished the run'.
			self simpleRessourceClass isAvailable.
			self
				assert: self simpleRessourceClass isAlreadyAvailable
				description: 'The resource was not set up again after the test']
]

{ #category : #private }
SimpleTestResourceTestCaseCopy >> dummy [
	self assert: resource hasSetup
		description: 'This test uses a resource but it was not set up'.
	self setRun.
	self assert: resource hasRun
		description: 'This test uses a resource but we could not interact with it'.
]

{ #category : #private }
SimpleTestResourceTestCaseCopy >> error [
	'foo' odd
]

{ #category : #private }
SimpleTestResourceTestCaseCopy >> setRun [
	resource setRun
]

{ #category : #running }
SimpleTestResourceTestCaseCopy >> setUp [
	"Ensure that we error, not just fail, if resource is nil so that #should:raise: checks cannot mistake such an error for what they are trapping."
	super setUp.
	resource := self simpleRessourceClass rawCurrentForTest.
	self
		deny: resource isNil
		description: 'SimpleTestResource has no current value in test'.
	self
		assert: resource class == self simpleRessourceClass
		description: 'SimpleTestResource current is not an instance of itself'.
	self
		assert: resource hasSetup
		description: 'This test uses a resource but it was not set up'
]

{ #category : #accessing }
SimpleTestResourceTestCaseCopy >> simpleRessourceClass [

	^ simpleRessourceClass
]

{ #category : #setter }
SimpleTestResourceTestCaseCopy >> simpleRessourceClass: aClass [

	simpleRessourceClass := aClass
]

{ #category : #accessing }
SimpleTestResourceTestCaseCopy >> simpleTestRessourceTestCaseClass [

	^ simpleTestRessourceTestCaseClass
]

{ #category : #setter }
SimpleTestResourceTestCaseCopy >> simpleTestRessourceTestCaseClass: aClass [

	simpleTestRessourceTestCaseClass := aClass
]

{ #category : #tests }
SimpleTestResourceTestCaseCopy >> testDebugTestWithResource [
	"The debug will raise an error if the resource is not set up properly."
	
	self clearOuterResourceStateDuring: [(self class selector: #setRun) debug]
]

{ #category : #tests }
SimpleTestResourceTestCaseCopy >> testResourceCollection [
	self assert: self class buildSuiteFromSelectors resources size = self resources size
		description: 'The suite should have the same number of resources as its test'.
	self class buildSuiteFromSelectors resources do:
		[:each |
		self assert: (self resources includes: each)
			description: each name , ':  I have this resource but my suite does not'].
]

{ #category : #tests }
SimpleTestResourceTestCaseCopy >> testResourceInitRelease [
	| suite error failure |
	suite := self classForTestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	suite addTest: (self class selector: #dummy).
	suite run.
	self assert: resource hasSetup
]

{ #category : #tests }
SimpleTestResourceTestCaseCopy >> testRunSuiteWithResource [
	| suite |
	suite :=  self classForTestSuite new.
	suite addTest: (self simpleTestRessourceTestCaseClass selector: #error).
	suite addTest: (self simpleTestRessourceTestCaseClass selector: #fail).
	suite addTest: (self class selector: #dummy).
	self clearOuterResourceStateDuring:
		[self
			assert: suite run printString = '3 ran, 1 passed, 0 skipped, 0 expected failures, 1 failure, 1 error, 0 passed unexpected'
			description: 'A suite of tests needing SimpleTestResource did not run as expected'].
]

{ #category : #tests }
SimpleTestResourceTestCaseCopy >> testRunTestWithResource [
	self clearOuterResourceStateDuring:
		[self
			assert: (self class selector: #dummy) run printString =
							'1 ran, 1 passed, 0 skipped, 0 expected failures, 0 failures, 0 errors, 0 passed unexpected'
			description: 'A dummy test that needed a resource did not pass']
]
