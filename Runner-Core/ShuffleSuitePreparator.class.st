Class {
	#name : #ShuffleSuitePreparator,
	#superclass : #AbstractSuitePreparator,
	#category : #'Runner-Core-Preparators'
}

{ #category : #applying }
ShuffleSuitePreparator class >> applyOn: testSuite [
	
	"shuffle the suite. It could be useful for tests dependency detection"
	testSuite tests shuffle.
]
