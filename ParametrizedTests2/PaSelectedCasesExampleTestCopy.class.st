Class {
	#name : #PaSelectedCasesExampleTestCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'number1',
		'number2',
		'result'
	],
	#category : #ParametrizedTests2
}

{ #category : #'building suites' }
PaSelectedCasesExampleTestCopy class >> testParameters [

	^ ParametrizedTestMatrixCopy new
		addCase: { #number1 -> 2. #number2 -> 1.0. #result -> 3 };
		addCase: { #number1 -> (2/3). #number2 -> (1/3). #result -> 1 };
		yourself
]

{ #category : #accessing }
PaSelectedCasesExampleTestCopy >> number1 [
	^ number1
]

{ #category : #accessing }
PaSelectedCasesExampleTestCopy >> number1: anObject [
	number1 := anObject
]

{ #category : #accessing }
PaSelectedCasesExampleTestCopy >> number2 [
	^ number2
]

{ #category : #accessing }
PaSelectedCasesExampleTestCopy >> number2: anObject [
	number2 := anObject
]

{ #category : #accessing }
PaSelectedCasesExampleTestCopy >> result [
	^ result
]

{ #category : #accessing }
PaSelectedCasesExampleTestCopy >> result: anObject [
	result := anObject
]

{ #category : #tests }
PaSelectedCasesExampleTestCopy >> testSum [
	
	self assert: number1 + number2 equals: result
]
