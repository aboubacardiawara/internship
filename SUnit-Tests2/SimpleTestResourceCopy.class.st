Class {
	#name : #SimpleTestResourceCopy,
	#superclass : #TestResourceCopy,
	#instVars : [
		'runningState',
		'hasRun',
		'hasSetup'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
SimpleTestResourceCopy class >> allowAvailability [
	^preventAvailability isNil
]

{ #category : #utilties }
SimpleTestResourceCopy class >> preventAvailabilityDuring: aBlock [
	"Only setter of preventAvailability."
	
	preventAvailability := false.
	^aBlock ensure: [preventAvailability := nil]
]

{ #category : #accessing }
SimpleTestResourceCopy class >> rawCurrentForTest [
	^current
]

{ #category : #testing }
SimpleTestResourceCopy >> hasRun [
	^hasRun
]

{ #category : #testing }
SimpleTestResourceCopy >> hasSetup [
	^hasSetup
]

{ #category : #testing }
SimpleTestResourceCopy >> isAvailable [
	^self class allowAvailability
		and: [self runningState == self startedStateSymbol]
]

{ #category : #accessing }
SimpleTestResourceCopy >> runningState [

	^runningState
]

{ #category : #accessing }
SimpleTestResourceCopy >> runningState: aSymbol [

	runningState := aSymbol
]

{ #category : #running }
SimpleTestResourceCopy >> setRun [
	hasRun := true
]

{ #category : #running }
SimpleTestResourceCopy >> setUp [
	super setUp.
	self runningState: self startedStateSymbol.
	hasSetup := true
]

{ #category : #running }
SimpleTestResourceCopy >> startedStateSymbol [

	^#started
]

{ #category : #running }
SimpleTestResourceCopy >> stoppedStateSymbol [

	^#stopped
]

{ #category : #running }
SimpleTestResourceCopy >> tearDown [

	self runningState: self stoppedStateSymbol
]
