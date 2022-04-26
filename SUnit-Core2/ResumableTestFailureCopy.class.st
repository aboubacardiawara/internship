Class {
	#name : #ResumableTestFailureCopy,
	#superclass : #TestFailureCopy,
	#category : #'SUnit-Core2'
}

{ #category : #'camp smalltalk' }
ResumableTestFailureCopy >> isResumable [
	"Of course a ResumableTestFailure is resumable ;-)"

	^true
]

{ #category : #'camp smalltalk' }
ResumableTestFailureCopy >> sunitExitWith: aValue [
	self resume: aValue
]
