Class {
	#name : #GreenTest,
	#superclass : #TestCase,
	#category : #'Runner-Core-Utilities-Test'
}

{ #category : #tests }
GreenTest >> testPass [
	self assert: true.
]

{ #category : #tests }
GreenTest >> testPassAgain [
	self assert: true.
]
