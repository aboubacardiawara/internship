Class {
	#name : #GreenTest,
	#superclass : #TestCase,
	#category : #'Runner-Tests-Utilities-Test'
}

{ #category : #tests }
GreenTest >> testPass [
	self assert: true.
]

{ #category : #tests }
GreenTest >> testPassAgain [
	self assert: true.
]
