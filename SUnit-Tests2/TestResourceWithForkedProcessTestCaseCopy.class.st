Class {
	#name : #TestResourceWithForkedProcessTestCaseCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'withForkedProcessTestResourceClass'
	],
	#category : #'SUnit-Tests2'
}

{ #category : #accessing }
TestResourceWithForkedProcessTestCaseCopy class >> resources [

	"Answer the TestResource class having a forked process"

	^ Array with: WithForkedProcessTestResourceCopy
]

{ #category : #accessing }
TestResourceWithForkedProcessTestCaseCopy class >> testParameters [

	^ ParametrizedTestMatrix new
		  addCase: { (#withForkedProcessTestResourceClass
			   -> WithForkedProcessTestResourceCopy) };
		  yourself
]

{ #category : #tests }
TestResourceWithForkedProcessTestCaseCopy >> testFirst [

	"Test whether the TestResource's forked process is not terminated.
	A second test method will do the same and thereby validate that forked processes
	of a TestResource do not get terminated (in between tests)."

	self
		assert: self withForkedProcessTestResourceClass current forkedProcess isTerminated not
		description: 'A forked process within a TestResource should not be terminated'
]

{ #category : #tests }
TestResourceWithForkedProcessTestCaseCopy >> testSecond [

	"Test whether the TestResource's forked process is not terminated between tests"

	"Use the other test method's implementation"
	self testFirst
]

{ #category : #accessing }
TestResourceWithForkedProcessTestCaseCopy >> withForkedProcessTestResourceClass [

	^ withForkedProcessTestResourceClass
]

{ #category : #setter }
TestResourceWithForkedProcessTestCaseCopy >> withForkedProcessTestResourceClass: aClass [ 
	withForkedProcessTestResourceClass := aClass
]
