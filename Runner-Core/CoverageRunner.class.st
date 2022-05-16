"
I am a test Coverage runner
"
Class {
	#name : #CoverageRunner,
	#superclass : #Runner,
	#instVars : [
		'classes'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #adding }
CoverageRunner >> addClass: aClass [ 
	classes add: aClass
]

{ #category : #adding }
CoverageRunner >> addTestCase: aTestCase [
	self testSuiteFromClass: aTestCase
]

{ #category : #coverage }
CoverageRunner >> coverage [
	^ 50
]

{ #category : #adding }
CoverageRunner >> initialize [
	super initialize.
	classes := OrderedCollection new.
]
