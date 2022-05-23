"
SUnit tests for forked processes in test resources
"
Class {
	#name : #TestResourceWithForkedProcessTestCase,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'withForkedProcessTestResourceClass'
	],
	#category : #'SUnit-Tests-Core'
}

{ #category : #accessing }
TestResourceWithForkedProcessTestCase class >> resources [

	"Answer the TestResource class having a forked process"

	^ Array with: WithForkedProcessTestResource
]

{ #category : #accessing }
TestResourceWithForkedProcessTestCase class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#withForkedProcessTestResourceClass
			   -> WithForkedProcessTestResource) };
		  yourself
]

{ #category : #tests }
TestResourceWithForkedProcessTestCase >> testFirst [

	"Test whether the TestResource's forked process is not terminated.
	A second test method will do the same and thereby validate that forked processes
	of a TestResource do not get terminated (in between tests)."

	self
		assert: self withForkedProcessTestResourceClass current forkedProcess isTerminated not
		description: 'A forked process within a TestResource should not be terminated'
]

{ #category : #tests }
TestResourceWithForkedProcessTestCase >> testSecond [

	"Test whether the TestResource's forked process is not terminated between tests"

	"Use the other test method's implementation"
	self testFirst
]

{ #category : #accessing }
TestResourceWithForkedProcessTestCase >> withForkedProcessTestResourceClass [

	^ withForkedProcessTestResourceClass
]

{ #category : #setter }
TestResourceWithForkedProcessTestCase >> withForkedProcessTestResourceClass: aClass [ 
	withForkedProcessTestResourceClass := aClass
]
