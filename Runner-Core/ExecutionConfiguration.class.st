Class {
	#name : #ExecutionConfiguration,
	#superclass : #Object,
	#category : #'Runner-Core-Configuration'
}

{ #category : #execution }
ExecutionConfiguration class >> defaultTestResultClass [

	^ TestResult
]

{ #category : #execution }
ExecutionConfiguration class >> executeSuite: aTestSuite [

	self subclassResponsibility
]
