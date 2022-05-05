Class {
	#name : #RedTest,
	#superclass : #TestCase,
	#category : #'Runner-Core-Utilities-Test'
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
