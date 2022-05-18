Class {
	#name : #DebugerOnFailureRunner,
	#superclass : #Runner,
	#category : #'Runner-Core-Core'
}

{ #category : #running }
DebugerOnFailureRunner >> runSuite: aTestSuite [

	self
		executeSuite: aTestSuite
		as: [ :aSuite :aResult | aSuite debug ]
]
