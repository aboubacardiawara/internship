Class {
	#name : #ManyTestResourceTestCaseCopy,
	#superclass : #SimpleTestResourceTestCaseCopy,
	#instVars : [
		'simplTestRessourceClassA',
		'simplTestRessourceClassA1',
		'simplTestRessourceClassA2',
		'simplTestRessourceClassB',
		'simplTestRessourceClassB1'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
ManyTestResourceTestCaseCopy class >> resources [
	^super resources
		, (Array with: SimpleTestResourceACopy with: SimpleTestResourceBCopy)
]

{ #category : #testing }
ManyTestResourceTestCaseCopy class >> shouldInheritSelectors [
	^true
]

{ #category : #testing }
ManyTestResourceTestCaseCopy class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { 
				  (#simpleRessourceClass -> SimpleTestResourceCopy).
				  (#simpleTestRessourceTestCaseClass -> SimpleTestResourceTestCaseCopy).
				  (#simplTestRessourceClassA -> SimpleTestResourceACopy).
				  (#simplTestRessourceClassA1 -> SimpleTestResourceA1Copy).
				  (#simplTestRessourceClassA2 -> SimpleTestResourceA2Copy).
				  (#simplTestRessourceClassB -> SimpleTestResourceBCopy).
				  (#simplTestRessourceClassB1 -> SimpleTestResourceB1Copy) };
		  yourself
]

{ #category : #utilities }
ManyTestResourceTestCaseCopy >> clearOuterResourceStateDuring: aBlock [
	"This self-testing test must clear the outer state of its resources before starting and after finishing, so that it can construct test cases and suites of itself and test them."
	
	self
		assert: SimpleTestResourceA1Copy isAlreadyAvailable
		description: 'The resource was not set up for the test'.
	SimpleTestResourceACopy reset.
	SimpleTestResourceBCopy reset.
	SimpleTestResourceA1Copy reset.
	self
		deny: SimpleTestResourceA1Copy isAlreadyAvailable
		description: 'The resource was still set up before we began the run'.
	^[super clearOuterResourceStateDuring: aBlock]
		ensure:
			[self
				deny: SimpleTestResourceA1Copy isAlreadyAvailable
				description: 'The resource was still set up after we finished the run'.
			self
				deny: SimpleTestResourceB1Copy isAlreadyAvailable
				description: 'The resource was still set up after we finished the run'.
			SimpleTestResourceACopy isAvailable.
			self
				assert: SimpleTestResourceA1Copy isAlreadyAvailable
				description: 'The resource was not set up again after the test'.
			SimpleTestResourceBCopy isAvailable.
			self
				assert: SimpleTestResourceB1Copy isAlreadyAvailable
				description: 'The resource was not set up again after the test']
]

{ #category : #setter }
ManyTestResourceTestCaseCopy >> simplTestRessourceClassA1: aClass [

	simplTestRessourceClassA1 := aClass
]

{ #category : #setter }
ManyTestResourceTestCaseCopy >> simplTestRessourceClassA2: aClass [

	simplTestRessourceClassA2 := aClass
]

{ #category : #setter }
ManyTestResourceTestCaseCopy >> simplTestRessourceClassA: aClass [

	simplTestRessourceClassA := aClass
]

{ #category : #setter }
ManyTestResourceTestCaseCopy >> simplTestRessourceClassB1: aClass [

	simplTestRessourceClassB1 := aClass
]

{ #category : #setter }
ManyTestResourceTestCaseCopy >> simplTestRessourceClassB: aClass [

	simplTestRessourceClassB := aClass
]

{ #category : #running }
ManyTestResourceTestCaseCopy >> testTearDownOrder [
	| myResourceSetUpOrder myResourceReverseTearDownOrder |
	myResourceReverseTearDownOrder := OrderedCollection new: 7.
	myResourceSetUpOrder := (OrderedCollection new: 7)
		add: SimpleTestResourceCopy;
		add: SimpleTestResourceA1Copy;
		add: SimpleTestResourceA2Copy;
		add: SimpleTestResourceACopy;
		add: SimpleTestResourceB1Copy;
		add: SimpleTestResourceBCopy;
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
