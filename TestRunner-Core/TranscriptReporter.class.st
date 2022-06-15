Class {
	#name : #TranscriptReporter,
	#superclass : #Object,
	#category : #'TestRunner-Core-Reporter'
}

{ #category : #report }
TranscriptReporter >> report: aMessage [

	self transcript
		tab;
		show: aMessage;
		cr
]

{ #category : #report }
TranscriptReporter >> reportEndedTest: aTestCase withResult: aTestResult [

	aTestResult passed do: [ :testCase | 
		self report: '[+] ' , testCase asString ].
	aTestResult failures do: [ :testCase | 
		self report: '[-] ' , testCase asString ].
	aTestResult errors do: [ :testCase | 
		self report: '[x] ' , testCase asString ]
]

{ #category : #report }
TranscriptReporter >> reportstartedTest: aTestCase [

	self transcript
		show: 'running: ' , aTestCase asString , ' ...';
		cr
]

{ #category : #tools }
TranscriptReporter >> transcript [

	^ Transcript
]
