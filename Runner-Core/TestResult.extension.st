Extension { #name : #TestResult }

{ #category : #'*Runner-Core' }
TestResult >> + aTestResult [

	aTestResult passed do: [ :each | self addPass: each ].
	aTestResult failures do: [ :each | self addFailure: each ].
	aTestResult errors do: [ :each | self addError: each ].
	aTestResult skipped do: [ :each | self addSkip: each ].
]

{ #category : #'*Runner-Core' }
TestResult >> removeFailure: aTestCase [
	"remove the giving failure from the failures set"

	^failures remove: aTestCase
]
