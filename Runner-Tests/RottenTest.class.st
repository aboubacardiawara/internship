Class {
	#name : #RottenTest,
	#superclass : #TestCase,
	#category : #'Runner-Tests-Utilities-Test'
}

{ #category : #tests }
RottenTest >> testWithAssertionNeverExecuted [

	| integers |
	integers := OrderedCollection new.
	integers do: [ :i | self assert: i = 100 ]
]
