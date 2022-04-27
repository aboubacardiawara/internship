Class {
	#name : #AbstractSuitePreparator,
	#superclass : #Object,
	#category : #'Runner-Core-Preparators'
}

{ #category : #applying }
AbstractSuitePreparator >> applyOn: testSuite [
	
	self subclassResponsibility.
]
