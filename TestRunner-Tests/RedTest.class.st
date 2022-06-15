Class {
	#name : #RedTest,
	#superclass : #TestCase,
	#category : #'TestRunner-Tests-Utilities-Test'
}

{ #category : #tests }
RedTest >> testFail [

	self skipOnPharoCITestingEnvironment.
	self assert: false
]

{ #category : #tests }
RedTest >> testPass [

	self skipOnPharoCITestingEnvironment.
	self assert: true
]

{ #category : #tests }
RedTest >> testWithError [

	self skipOnPharoCITestingEnvironment.
	self assert: nil
]
