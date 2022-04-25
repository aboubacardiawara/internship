Class {
	#name : #WithForkedProcessTestResourceCopy,
	#superclass : #TestResource,
	#instVars : [
		'forkedProcess'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
WithForkedProcessTestResourceCopy >> forkedProcess [

	"Answer the receiver's forked process"

	^ forkedProcess
]

{ #category : #running }
WithForkedProcessTestResourceCopy >> setUp [

	"Create a forked process which should live until the #tearDown message is received.
	The process is and should remain in suspended state."

	super setUp.
	forkedProcess := [ "empty process" ] newProcess
]

{ #category : #running }
WithForkedProcessTestResourceCopy >> tearDown [

	"Terminate forked process"

	super tearDown.
	forkedProcess ifNotNil: [ forkedProcess terminate ]
]
