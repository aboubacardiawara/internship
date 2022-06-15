Class {
	#name : #CommandLineTestRunner2,
	#superclass : #TestRunner2,
	#instVars : [
		'reporter',
		'stderr',
		'stdout',
		'stdin'
	],
	#category : #'TestRunner-Core-Core'
}

{ #category : #accessing }
CommandLineTestRunner2 >> createStderr [

	^ Stdio stderr
]

{ #category : #accessing }
CommandLineTestRunner2 >> createStdout [

	^ Stdio stdout
]

{ #category : #accessing }
CommandLineTestRunner2 >> defaultReporter [

	^ TranscriptReporter
]

{ #category : #accessing }
CommandLineTestRunner2 >> reportEndedTest [

	self reporter
		reportEndedTest: currentResult
		withResult: currentResult
]

{ #category : #accessing }
CommandLineTestRunner2 >> reportStartedTest [

	self reporter reportstartedTest: currentTest
]

{ #category : #accessing }
CommandLineTestRunner2 >> reporter [

	^ reporter ifNil: [ reporter := self defaultReporter new ]
]

{ #category : #accessing }
CommandLineTestRunner2 >> run: aClass [

	super run: aClass.
	self reportStartedTest.
	self reportEndedTest
]

{ #category : #accessing }
CommandLineTestRunner2 >> stderr [

	(stderr isNil or: [ stderr closed ]) ifTrue: [ 
		stderr := self createStderr ].
	^ stderr
]

{ #category : #accessing }
CommandLineTestRunner2 >> stdout [

	(stdout isNil or: [ stdout closed ]) ifTrue: [ 
		stdout := self createStdout ].

	^ stdout
]
