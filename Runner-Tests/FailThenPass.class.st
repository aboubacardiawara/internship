"
I am a Test who faild at the first execution.

I will be use to tests some rerunFailed Tests features.
"
Class {
	#name : #FailThenPass,
	#superclass : #TestCase,
	#classInstVars : [
		'counter'
	],
	#category : #'Runner-Tests-Utilities-Test'
}

{ #category : #accessing }
FailThenPass class >> counter [

	counter isNil
		ifTrue: [ counter := 0 ]
		ifFalse: [ counter := counter + 1 ].
	^ counter
]

{ #category : #accessing }
FailThenPass class >> reset [
	<script>
	counter := nil.
]

{ #category : #tests }
FailThenPass >> testFailAtFirstRunning [
	self assert: self class counter > 0.
]
