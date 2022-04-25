Class {
	#name : #SimpleTestResourceBCopy,
	#superclass : #SimpleTestResourceCopy,
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
SimpleTestResourceBCopy class >> resources [
	^Array with: SimpleTestResourceA1Copy with: SimpleTestResourceB1Copy
]
