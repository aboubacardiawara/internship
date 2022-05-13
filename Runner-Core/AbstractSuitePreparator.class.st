"
After building a TestSuite and after executing its tests, we would like to apply to it some process as randomisation. I repesent an abstract represent of any Class intented to do such things.
"
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
