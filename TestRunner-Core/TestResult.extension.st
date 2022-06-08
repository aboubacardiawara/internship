Extension { #name : #TestResult }

{ #category : #'*TestRunner-Core' }
TestResult >> + aTestResult [

	aTestResult passed do: [ :each | 
		(self passed includes: each) ifFalse: [ self addPass: each ] ].
	aTestResult failures do: [ :each | 
		(self failures includes: each) ifFalse: [ self addFailure: each ] ].
	aTestResult errors do: [ :each | 
		(self errors includes: each) ifFalse: [ self addError: each ] ].
	aTestResult skipped do: [ :each | 
		(self skipped includes: each) ifFalse: [ self addSkip: each ] ]
]

{ #category : #'*TestRunner-Core' }
TestResult >> removeFailure: aTestCase [
	"remove the giving failure from the failures set"

	^failures remove: aTestCase
]
