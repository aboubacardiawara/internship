Class {
	#name : #HashTesterTestCopy,
	#superclass : #TestCaseCopy,
	#category : #'SUnit-Core2'
}

{ #category : #tests }
HashTesterTestCopy >> testBasicBehaviour [

	self
		assert: ((HashTesterCopy with: 1) resultFor: 100);
		assert: ((HashTesterCopy with: 'fred') resultFor: 100);
		deny: ((HashTesterCopy with: BadHasherCopy new) resultFor: 100)
]
