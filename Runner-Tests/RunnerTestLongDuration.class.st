Class {
	#name : #RunnerTestLongDuration,
	#superclass : #TestCase,
	#instVars : [
		'runner'
	],
	#category : #'Runner-Tests-Core'
}

{ #category : #tests }
RunnerTestLongDuration >> setUp [
	super setUp.
	runner := TestRunner2 new suitePreparator: ShuffleSuitePreparator.
]

{ #category : #tests }
RunnerTestLongDuration >> testRunningFromACollectionOfPackages [

	"first execution"

	| packages |
	packages := OrderedCollection
		            with: #'Zodiac-Tests' asPackage
		            with: #'Zodiac-Tests' asPackage.
	runner runPackages: packages.
	self assert: runner runCount equals: 79 * 2.
	self assert: runner passedCount equals: 79 * 2
]

{ #category : #tests }
RunnerTestLongDuration >> testRunningFromAPackage [

	"first execution"

	| aPackage |
	aPackage := #'Zodiac-Tests' asPackage.
	runner runPackage: aPackage.
	self assert: runner runCount equals: 79.
	self assert: runner passedCount equals: 79
]
