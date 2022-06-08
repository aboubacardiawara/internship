Class {
	#name : #RedTest,
	#superclass : #TestCase,
	#category : #'TestRunner-Tests-Utilities-Test'
}

{ #category : #tests }
RedTest >> testFail [
	self assert: false.
]

{ #category : #tests }
RedTest >> testPass [
	self assert: true.
]

{ #category : #tests }
RedTest >> testWithError [
	self assert: nil.
]
