Class {
	#name : #CommandLineTestRunner2,
	#superclass : #TestRunner2,
	#instVars : [
		'stdin',
		'stdout',
		'stderr'
	],
	#category : #'TestRunner-Core-Core'
}

{ #category : #private }
CommandLineTestRunner2 >> createStderr [

	^ Stdio stderr
]

{ #category : #private }
CommandLineTestRunner2 >> createStdout [

	^ Stdio stdout
]

{ #category : #private }
CommandLineTestRunner2 >> print: longErrorMessage short: shortErrorMessage of: aTestCase [

	| cr |
	cr := OSPlatform current lineEnding.
	self stdout << (shortErrorMessage trimBoth padRightTo: 10)
	<< aTestCase printString << cr.
	longErrorMessage isEmptyOrNil ifFalse: [ 
		self stdout << longErrorMessage << cr ]
]

{ #category : #private }
CommandLineTestRunner2 >> printNextTest [

	| cr |
	cr := OSPlatform current lineEnding.

	self stderr << 'Test in progress: ' << currentTest name << cr
]

{ #category : #private }
CommandLineTestRunner2 >> printReport [

	| cr |
	cr := OSPlatform current lineEnding.

	self stderr << cr << 'Finished running ' << currentTest name << cr
	<< '  [+] passed: ' << currentResult runCount asString << cr
	<< '  [-] failure: ' << currentResult failureCount asString << cr
	<< '  [+] errors: ' << currentResult errorCount asString << cr
]

{ #category : #private }
CommandLineTestRunner2 >> printReportInTranscript [

	Transcript
		show: 'Finished';
		cr.
		
	self printStat.
]

{ #category : #private }
CommandLineTestRunner2 >> printStat [

	Transcript
		tab;
		show: 'tests: ';
		nextPutAll: self testsCount asString;
		cr;
		tab;
		show: '[+] passed: ';
		nextPutAll: self passedCount asString;
		cr;
		tab;
		show: '[-] fail: ';
		nextPutAll: self failureCount asString;
		cr;
		tab;
		show: '[x] errors: ';
		nextPutAll: self errorCount asString;
		cr
]

{ #category : #private }
CommandLineTestRunner2 >> recordErrorOf: aTestCase [
	self
		print: nil
		short: ' [ERROR]' 
		of: aTestCase
]

{ #category : #private }
CommandLineTestRunner2 >> recordFailureOf: aTestCase [
	self
		print: nil
		short: ' [FAILED]' 
		of: aTestCase
]

{ #category : #private }
CommandLineTestRunner2 >> recordPassOf: aTestCase [
	self
		print: nil
		short: ' [OK]' 
		of: aTestCase
]

{ #category : #private }
CommandLineTestRunner2 >> setUp [
	super setUp.
	self printNextTest.
]

{ #category : #private }
CommandLineTestRunner2 >> stderr [
	(stderr isNil or: [ stderr closed ])
		ifTrue: [ stderr := self createStderr ].
	^ stderr
]

{ #category : #private }
CommandLineTestRunner2 >> stdout [
	(stdout isNil or: [ stdout closed ])
		ifTrue: [ stdout := self createStdout ].
		
	^ stdout
]

{ #category : #private }
CommandLineTestRunner2 >> tearDown [

	super tearDown.
	self printReport

]
