"
SUnit tests for handling of many test resources
"
Class {
	#name : #ManyTestResourceTestCase,
	#superclass : #SimpleTestResourceTestCase,
	#instVars : [
		'simplTestRessourceClassA',
		'simplTestRessourceClassA1',
		'simplTestRessourceClassA2',
		'simplTestRessourceClassB',
		'simplTestRessourceClassB1'
	],
	#category : #'SUnit-Tests-Core'
}

{ #category : #accessing }
ManyTestResourceTestCase class >> resources [
	^super resources
		, (Array with: SimpleTestResourceA with: SimpleTestResourceB)
]

{ #category : #testing }
ManyTestResourceTestCase class >> shouldInheritSelectors [
	^true
]

{ #category : #testing }
ManyTestResourceTestCase class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { 
				  (#simpleRessourceClass -> SimpleTestResource).
				  (#simpleTestRessourceTestCaseClass -> SimpleTestResourceTestCase).
				  (#simplTestRessourceClassA -> SimpleTestResourceA).
				  (#simplTestRessourceClassA1 -> SimpleTestResourceA1).
				  (#simplTestRessourceClassA2 -> SimpleTestResourceA2).
				  (#simplTestRessourceClassB -> SimpleTestResourceB).
				  (#simplTestRessourceClassB1 -> SimpleTestResourceB1) };
		  yourself
]

{ #category : #utilities }
ManyTestResourceTestCase >> clearOuterResourceStateDuring: aBlock [
	"This self-testing test must clear the outer state of its resources before starting and after finishing, so that it can construct test cases and suites of itself and test them."
	
	self
		assert: SimpleTestResourceA1 isAlreadyAvailable
		description: 'The resource was not set up for the test'.
	SimpleTestResourceA reset.
	SimpleTestResourceB reset.
	SimpleTestResourceA1 reset.
	self
		deny: SimpleTestResourceA1 isAlreadyAvailable
		description: 'The resource was still set up before we began the run'.
	^[super clearOuterResourceStateDuring: aBlock]
		ensure:
			[self
				deny: SimpleTestResourceA1 isAlreadyAvailable
				description: 'The resource was still set up after we finished the run'.
			self
				deny: SimpleTestResourceB1 isAlreadyAvailable
				description: 'The resource was still set up after we finished the run'.
			SimpleTestResourceA isAvailable.
			self
				assert: SimpleTestResourceA1 isAlreadyAvailable
				description: 'The resource was not set up again after the test'.
			SimpleTestResourceB isAvailable.
			self
				assert: SimpleTestResourceB1 isAlreadyAvailable
				description: 'The resource was not set up again after the test']
]

{ #category : #setter }
ManyTestResourceTestCase >> simplTestRessourceClassA1: aClass [

	simplTestRessourceClassA1 := aClass
]

{ #category : #setter }
ManyTestResourceTestCase >> simplTestRessourceClassA2: aClass [

	simplTestRessourceClassA2 := aClass
]

{ #category : #setter }
ManyTestResourceTestCase >> simplTestRessourceClassA: aClass [

	simplTestRessourceClassA := aClass
]

{ #category : #setter }
ManyTestResourceTestCase >> simplTestRessourceClassB1: aClass [

	simplTestRessourceClassB1 := aClass
]

{ #category : #setter }
ManyTestResourceTestCase >> simplTestRessourceClassB: aClass [

	simplTestRessourceClassB := aClass
]

{ #category : #running }
ManyTestResourceTestCase >> testTearDownOrder [
	| myResourceSetUpOrder myResourceReverseTearDownOrder |
	myResourceReverseTearDownOrder := OrderedCollection new: 7.
	myResourceSetUpOrder := (OrderedCollection new: 7)
		add: SimpleTestResource;
		add: SimpleTestResourceA1;
		add: SimpleTestResourceA2;
		add: SimpleTestResourceA;
		add: SimpleTestResourceB1;
		add: SimpleTestResourceB;
		yourself.
	self
		assert: (myResourceSetUpOrder allSatisfy: [:each | each isAvailable])
		description: 'At test start, not all my resources were set up'.
	self class resources
		do: [:each | each resetOrAddResourcesTo: myResourceReverseTearDownOrder].
	self
		assert: myResourceReverseTearDownOrder = myResourceSetUpOrder
		description: 'Wrong order for tearDown'.
	self
		assert: (myResourceSetUpOrder allSatisfy: [:each | each isAvailable])
		description: 'At test start, not all my resources were set up'
]
