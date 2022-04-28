Class {
	#name : #AbstractSuitePreparator,
	#superclass : #Object,
	#category : #'Runner-Core-Preparators'
}

{ #category : #applying }
AbstractSuitePreparator class >> applyOn: testSuite [
	
	self subclassResponsibility.
]

{ #category : #applying }
AbstractSuitePreparator class >> applyOnSuites: aCol [
	
	aCol do: [ :suite | self applyOn: suite ]
]
