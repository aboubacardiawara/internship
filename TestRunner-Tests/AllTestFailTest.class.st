Class {
	#name : #AllTestFailTest,
	#superclass : #TestCase,
	#category : #'TestRunner-Tests-Utilities-Test'
}

{ #category : #tests }
AllTestFailTest >> testFail1 [

	self skipOnPharoCITestingEnvironment.
	self assert: false
]

{ #category : #tests }
AllTestFailTest >> testFail2 [

	self skipOnPharoCITestingEnvironment.
	self assert: false
]

{ #category : #tests }
AllTestFailTest >> testFail3 [

	self skipOnPharoCITestingEnvironment.
	self assert: false
]

{ #category : #tests }
AllTestFailTest >> testFail4 [

	self skipOnPharoCITestingEnvironment.
	self assert: false
]
