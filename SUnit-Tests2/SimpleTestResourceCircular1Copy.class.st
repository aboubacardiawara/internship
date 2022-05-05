Class {
	#name : #SimpleTestResourceCircular1Copy,
	#superclass : #SimpleTestResourceCopy,
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
SimpleTestResourceCircular1Copy class >> resources [
	"Circular prereq:  C wants C1 which wants C."
	
	^Array with: SimpleTestResourceCircularCopy
]
