Class {
	#name : #TestAsserterTestCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'testFailureClass'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #tests }
TestAsserterTestCopy class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#testFailureClass -> TestFailureCopy) };
		  yourself
]

{ #category : #tests }
TestAsserterTestCopy >> testAssertCollectionHasSameElements [
	| c1 c2 |
	c1 := { 1. 2. 3 }.
	c2 := Set with: 2 with: 3 with: 1.
	self shouldnt: [ self assertCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.

	c2 := Set with: 2 with: 3 with: 1 with: 4.
	self should: [ self assertCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.
]

{ #category : #tests }
TestAsserterTestCopy >> testDenyCollectionHasSameElements [
	| c1 c2 |
	c1 := { 1. 2. 3 }.
	c2 := Set with: 2 with: 3 with: 1.
	self should: [ self denyCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.

	c2 := Set with: 2 with: 3 with: 1 with: 4.
	self shouldnt: [ self denyCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.
]

{ #category : #accessing }
TestAsserterTestCopy >> testFailureClass [

	^ testFailureClass
]

{ #category : #setter }
TestAsserterTestCopy >> testFailureClass: aClass [

	testFailureClass := aClass
]
