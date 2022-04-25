Class {
	#name : #SimpleTestResourceCircularCopy,
	#superclass : #SimpleTestResourceCopy,
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
SimpleTestResourceCircularCopy class >> resources [

	^ preventAvailability
		ifNil: [ super resources , ( Array with: SimpleTestResourceA1Copy ) ]
		ifNotNil: [ super resources , ( Array with: SimpleTestResourceA1Copy with: SimpleTestResourceCircular1Copy ) ]
]
