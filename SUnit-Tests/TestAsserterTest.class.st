Class {
	#name : #TestAsserterTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'testFailureClass'
	],
	#category : #'SUnit-Tests-Core'
}

{ #category : #tests }
TestAsserterTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#testFailureClass -> TestFailure) };
		  yourself
]

{ #category : #tests }
TestAsserterTest >> testAssertCollectionHasSameElements [
	| c1 c2 |
	c1 := { 1. 2. 3 }.
	c2 := Set with: 2 with: 3 with: 1.
	self shouldnt: [ self assertCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.

	c2 := Set with: 2 with: 3 with: 1 with: 4.
	self should: [ self assertCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.
]

{ #category : #tests }
TestAsserterTest >> testDenyCollectionHasSameElements [
	| c1 c2 |
	c1 := { 1. 2. 3 }.
	c2 := Set with: 2 with: 3 with: 1.
	self should: [ self denyCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.

	c2 := Set with: 2 with: 3 with: 1 with: 4.
	self shouldnt: [ self denyCollection: c1 hasSameElements: c2 ] raise: self testFailureClass.
]

{ #category : #accessing }
TestAsserterTest >> testFailureClass [

	^ testFailureClass
]

{ #category : #setter }
TestAsserterTest >> testFailureClass: aClass [

	testFailureClass := aClass
]
