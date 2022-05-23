Class {
	#name : #FailingTestResourceTestCaseCopy,
	#superclass : #SimpleTestResourceTestCaseCopy,
	#category : #'SUnit-Tests2'
}

{ #category : #utilities }
FailingTestResourceTestCaseCopy >> clearOuterResourceStateDuring: aBlock [
	"Make the resource impossible to make available, then ensure that every test raises a failure but not an error (which its setUp would do if it reached it and the resource were nil)."

	^super clearOuterResourceStateDuring:
		[SimpleTestResourceCopy preventAvailabilityDuring:
			[self should: aBlock raise: self defaultTestFailure]]
]
