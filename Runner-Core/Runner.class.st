Class {
	#name : #Runner,
	#superclass : #Object,
	#instVars : [
		'suites',
		'result'
	],
	#category : #'Runner-Core-Kernel'
}

{ #category : #testing }
Runner >> hasTestsToRun [
	^ self suites isEmpty not.
]

{ #category : #'instance creation' }
Runner >> suites [
	^ suites ifNil: [ suites := OrderedCollection new ]
]

{ #category : #tests }
Runner >> testSuiteFromClass: aClass [
	self suites add: (aClass isAbstract not & aClass suite ).
]

{ #category : #tests }
Runner >> testSuitesFromClasses: aCol [
	aCol do: (
		[ :class | self testSuiteFromClass: class  ]
	)
]

{ #category : #accessing }
Runner >> testsCount [
	|cpt|
	cpt := 0.
	self suites do: [ :suite | cpt := cpt + suite tests size ].
	^ cpt
]
