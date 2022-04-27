Class {
	#name : #YellowTest,
	#superclass : #TestCase,
	#category : #'Runner-Core-Utilities-Test'
}

{ #category : #tests }
YellowTest >> testFail [
	self assert: false.
]

{ #category : #tests }
YellowTest >> testPass [
	self assert: true.
]
