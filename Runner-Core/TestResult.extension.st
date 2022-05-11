Extension { #name : #TestResult }

{ #category : #'*Runner-Core' }
TestResult >> removeFailure: aTestCase [
	"remove the giving failure from the failures set"

	^failures remove: aTestCase
]
