Class {
	#name : #TestCaseTestCopy,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'factoryForTestCaseTestClass',
		'testCaseClass'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #tests }
TestCaseTestCopy class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase: {
			#factoryForTestCaseTestClass -> ClassFactoryForTestCaseTestCopy. 
			#testCaseClass -> TestCase
			};
		yourself
]

{ #category : #accessing }
TestCaseTestCopy >> factoryForTestCaseTestClass: anObject [

	factoryForTestCaseTestClass := anObject
]

{ #category : #events }
TestCaseTestCopy >> testAnnouncement [
	| collection oldCollection suite unitTest |
	unitTest := factoryForTestCaseTestClass.
	collection := OrderedCollection new.
	unitTest resetAnnouncer.

	self deny: unitTest shouldAnnounce.
	self deny: unitTest new shouldAnnounce.

	unitTest announcer when: TestCaseAnnouncement do: [ :ann | collection add: ann ].

	self assert: unitTest shouldAnnounce.
	self assert: unitTest new shouldAnnounce.

	"We run SUnitTest"
	suite := unitTest buildSuite.
	suite run.

	self assert: collection size equals: suite tests size * 2.
	self assert: (collection select: [ :c | c isKindOf: TestCaseStarted ]) size equals: collection size / 2.
	self assert: (collection select: [ :c | c isKindOf: TestCaseEnded ]) size equals: collection size / 2.
	self assert: (collection allSatisfy: #hasPassed).
	self deny: (collection anySatisfy: #hasFailures).

	oldCollection := collection copy.
	unitTest resetAnnouncer.
	unitTest debug: #testClassCreationInDifferentCategories.
	self assert: collection equals: oldCollection
]

{ #category : #testing }
TestCaseTestCopy >> testAssertEqualsActualAndExpectedOrder [
	self 
		should: [
			self assert: 'actual' equals: 'expected with fairly long print string'
		]
		raise: TestFailure 
		whoseDescriptionIncludes: 'Got ''actual'' instead of ''expected with fairly long print string''.' 
		description: 'In #assert:equals: the first argument is the actual value and the second one is the expected.'.
]

{ #category : #accessing }
TestCaseTestCopy >> testCaseClass: anObject [

	testCaseClass := anObject
]

{ #category : #testing }
TestCaseTestCopy >> testIsUnitTest [

	self assert: testCaseClass isUnitTest
]