Class {
	#name : #BadEqualerCopy,
	#superclass : #Object,
	#category : #'SUnit-Core2'
}

{ #category : #comparing }
BadEqualerCopy >> = other [ 
	self class = other class
		ifFalse: [^ false].
	^ 100 atRandom < 30
]
