Class {
	#name : #PrototypeTesterCopy,
	#superclass : #Object,
	#instVars : [
		'prototype'
	],
	#category : #'SUnit-Core2'
}

{ #category : #default }
PrototypeTesterCopy class >> defaultRuns [
	"Returns the default number of times to test"

	^ 50
]

{ #category : #'instance creation' }
PrototypeTesterCopy class >> with: aPrototype [

	^ self new prototype: aPrototype
]

{ #category : #accessing }
PrototypeTesterCopy >> prototype [
	"Get a prototype"

	^ prototype copy
]

{ #category : #accessing }
PrototypeTesterCopy >> prototype: aPrototype [
	"Set my prototype"

	prototype := aPrototype copy
]

{ #category : #operation }
PrototypeTesterCopy >> result [
	"Perform the test the default number of times"

	^ self resultFor: self class defaultRuns
]

{ #category : #operation }
PrototypeTesterCopy >> resultFor: runs [ 
	"Test that equality is the same over runs and answer the result"
	
	self subclassResponsibility
]
