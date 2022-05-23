Class {
	#name : #PaAbstractExampleTestCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'option2',
		'option1'
	],
	#category : #ParametrizedTests2
}

{ #category : #private }
PaAbstractExampleTestCopy class >> isAbstract [
	^ self name = #PaAbstractExampleTestCopy
]

{ #category : #accessing }
PaAbstractExampleTestCopy >> option1 [
	^ option1
]

{ #category : #accessing }
PaAbstractExampleTestCopy >> option1: aString [ 
	option1 := aString
]

{ #category : #accessing }
PaAbstractExampleTestCopy >> option2 [
	^ option2
]

{ #category : #accessing }
PaAbstractExampleTestCopy >> option2: anInteger [ 
	option2 := anInteger
]

{ #category : #tests }
PaAbstractExampleTestCopy >> testParametersHaveValue [
	self assert: option1 isNotNil.
	self assert: option2 isNotNil.
]
