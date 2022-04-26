Class {
	#name : #TestAsserterTestCopy,
	#superclass : #TestCase,
	#category : #'SUnit-Tests2'
}

{ #category : #tests }
TestAsserterTestCopy >> testAssertCollectionHasSameElements [
	| c1 c2 |
	c1 := { 1. 2. 3 }.
	c2 := Set with: 2 with: 3 with: 1.
	self shouldnt: [ self assertCollection: c1 hasSameElements: c2 ] raise: TestFailure.

	c2 := Set with: 2 with: 3 with: 1 with: 4.
	self should: [ self assertCollection: c1 hasSameElements: c2 ] raise: TestFailure.
]

{ #category : #tests }
TestAsserterTestCopy >> testDenyCollectionHasSameElements [
	| c1 c2 |
	c1 := { 1. 2. 3 }.
	c2 := Set with: 2 with: 3 with: 1.
	self should: [ self denyCollection: c1 hasSameElements: c2 ] raise: TestFailure.

	c2 := Set with: 2 with: 3 with: 1 with: 4.
	self shouldnt: [ self denyCollection: c1 hasSameElements: c2 ] raise: TestFailure.
]