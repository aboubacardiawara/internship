Class {
	#name : #SimpleTestResourceACopy,
	#superclass : #SimpleTestResourceCopy,
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
SimpleTestResourceACopy class >> resources [
	^Array with: SimpleTestResourceA1Copy with: SimpleTestResourceA2Copy
]
