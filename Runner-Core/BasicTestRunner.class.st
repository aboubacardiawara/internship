"
If you giving a TestCase (MyCounterTest), i can execute then and give you the execution result.

## Public API
"
Class {
	#name : #BasicTestRunner,
	#superclass : #Object,
	#instVars : [
		'result',
		'suitePreparator',
		'executionMode'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #accessing }
BasicTestRunner >> defaultExecutionModeClass [

	^ RunExecutionMode
]

{ #category : #accessing }
BasicTestRunner >> defaultResultClass [

	^ TestResult
]

{ #category : #accessing }
BasicTestRunner >> defaultSuitePreparatorClass [

	^ ShuffleSuitePreparator
]

{ #category : #accessing }
BasicTestRunner >> executionMode [

	^ executionMode ifNil: [ 
		  executionMode := self defaultExecutionModeClass new ]
]

{ #category : #accessing }
BasicTestRunner >> executionMode: anObject [

	executionMode := anObject
]

{ #category : #accessing }
BasicTestRunner >> result [

	^ result ifNil: [ result := self defaultResultClass new ]
]

{ #category : #accessing }
BasicTestRunner >> result: anObject [

	result := anObject
]

{ #category : #accessing }
BasicTestRunner >> suitePreparator [

	^ suitePreparator ifNil: [ 
		  suitePreparator := self defaultSuitePreparatorClass new ]
]

{ #category : #accessing }
BasicTestRunner >> suitePreparator: anObject [

	suitePreparator := anObject
]
