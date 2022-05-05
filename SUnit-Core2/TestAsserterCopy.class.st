Class {
	#name : #TestAsserterCopy,
	#superclass : #Object,
	#category : #'SUnit-Core2'
}

{ #category : #asserting }
TestAsserterCopy class >> assert: aBoolean description: aString [
	"Minimal clone of the instance-side assert protocol so that class-side methods can use it."

	aBoolean ifFalse:
		[self logFailure: aString.
		self classForTestResult failure signal: aString].
]

{ #category : #asserting }
TestAsserterCopy class >> classForTestResult [
	"Returns the class of the test result"
	^ TestResultCopy
]

{ #category : #factory }
TestAsserterCopy class >> classForTestSuite [
	^ TestSuiteCopy
]

{ #category : #accessing }
TestAsserterCopy class >> defaultPrecisionsForCloseToComparison [
	"This number comes from the one used in Float>>#closeTo: implementation."
	^ 0.0001
]

{ #category : #logging }
TestAsserterCopy class >> failureLog [
	^Transcript
]

{ #category : #logging }
TestAsserterCopy class >> isLogging [
	"By default, we're not logging failures. Override in subclasses as desired."

	^false
]

{ #category : #logging }
TestAsserterCopy class >> logFailure: aString [
	self isLogging ifTrue:
		[self failureLog cr; nextPutAll: aString; flush].
]

{ #category : #factory }
TestAsserterCopy class >> methodPassed: aSelector [

	^ false
]

{ #category : #factory }
TestAsserterCopy class >> suiteClass [
	^TestSuiteCopy
]

{ #category : #asserting }
TestAsserterCopy >> assert: actualNumber closeTo: expectedNumber [
	"Tell whether the actualNumber and expectedNumber ARE close to each others with a margin of
	 the default precision (see class-side method #defaultPrecisionsForCloseToComparison).
	"
	self assert: actualNumber closeTo: expectedNumber precision: self class defaultPrecisionsForCloseToComparison
]

{ #category : #asserting }
TestAsserterCopy >> assert: actualNumber closeTo: expectedNumber precision: epsilon [
	"Tell whether the actualNumber and expectedNumber ARE close to each others with a margin of epsilon."

	^ self
		assert: (actualNumber closeTo: expectedNumber precision: epsilon)
		description: [ self comparingStringBetween: actualNumber and: expectedNumber ]
]

{ #category : #asserting }
TestAsserterCopy >> assert: aBooleanOrBlock description: aStringOrBlock [
	"This method raises an AssertionFailure with aString as #messageText if
	 aBooleanOrBlock evaluates to false.
	"
	<debuggerCompleteToSender>
	self assert: aBooleanOrBlock description: aStringOrBlock resumable: false
]

{ #category : #asserting }
TestAsserterCopy >> assert: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean [
	"Checks if aBooleanOrBlock evaluates to true (by sending #value message to it).
	 The message text of the assertion failure exception thrown in case aBooleanOrBlock
	 evaluates to false is determined by the evaluation of aStringOrBlock (again by
	 sending #value message to it).
	 The resumableBoolean flag is used to decide if the assertion failure signalled by
	 the source code below should be resumable or not.
	"
	<debuggerCompleteToSender>
	| exception aString |
	aBooleanOrBlock value
		ifTrue: [ ^ self ].
	
	aString := aStringOrBlock value.
	self logFailure: aString.
	exception := resumableBoolean
		ifTrue: [ self classForTestResult resumableFailure ]
		ifFalse: [ self classForTestResult failure ].
	exception signal: aString
]

{ #category : #asserting }
TestAsserterCopy >> assert: actual equals: expected [
	"This method raises an AssertionFailure if actual is different (using #= message) from expected.
	 Else it does nothing and execution continues.
	"
	
	^ self
		assert: actual = expected
		description: [self comparingStringBetween: actual and: expected]
]

{ #category : #asserting }
TestAsserterCopy >> assert: actual identicalTo: expected [
	"Verify whether the actual and the expected are the same object (have the same object pointer so #== returns true)."
	
	^ self
		assert: expected == actual
		description: [self comparingIdentityStringBetween: actual and: expected]
]

{ #category : #asserting }
TestAsserterCopy >> assertCollection: actualCollection equals: expectedCollection [
	"Raises an AssertionFailure if actualCollection is not equal to expectedCollection (using #= message).
	 I also provide a specialized message for the AssertionFailure in case I fail.
	"

	^ self
		assert: actualCollection = expectedCollection
		description: [ self comparingCollectionBetween: actualCollection and: expectedCollection ]
]

{ #category : #asserting }
TestAsserterCopy >> assertCollection: actualCollection hasSameElements: expected [
	"Assert that a collection contains the same elements as the given collection. Order is not checked, only the presence/absence of elements."

	| missingElements additionalElements |
	additionalElements := actualCollection difference: expected.
	missingElements := expected difference: (actualCollection intersection: expected).
	self
		assert: (additionalElements isEmpty and: [ missingElements isEmpty ])
		description:
			(String
				streamContents: [ :stream | 
					stream
						nextPutAll: 'Given Collections do not match!';
						lf;
						tab;
						nextPutAll: 'additions : ';
						print: additionalElements asArray;
						lf;
						tab;
						nextPutAll: 'missing: ';
						print: missingElements asArray;
						lf ])
]

{ #category : #asserting }
TestAsserterCopy >> assertCollection: actualCollection includesAll: subcollection [
	"Raises an AssertionFailure if actualCollection does not include all the elements of expectedCollection (using #includesAll: message).
	 I also provide a specialized message for the AssertionFailure in case I fail.
	"

	^ self
		assert: (actualCollection includesAll: subcollection)
		description: [ actualCollection asString , ' does not include all in ' , subcollection asString ]
]

{ #category : #asserting }
TestAsserterCopy >> assertCollection: actualCollection includesAny: subcollection [
	"Raises an AssertionFailure if actualCollection does not include any of the elements of 
	 expectedCollection (using #includesAny: message).
    I also provide a specialized message for the AssertionFailure in case I fail.
 	"
	^ self
		assert: (actualCollection includesAny: subcollection)
		description: [ actualCollection asString , ' does not include any of ' , subcollection asString ]
]

{ #category : #asserting }
TestAsserterCopy >> assertEmpty: aCollection [
	^ self assert: aCollection isEmpty description: aCollection asString , ' should have been empty'
]

{ #category : #factory }
TestAsserterCopy >> classForTestResource [
	^ TestResourceCopy
]

{ #category : #factory }
TestAsserterCopy >> classForTestResult [
	"Returns the class of the test result"
	
	"note that we did not name this method testResultClass because it is considered by tools as a test method."
	^ self class classForTestResult
]

{ #category : #factory }
TestAsserterCopy >> classForTestSuite [
	"Returns the class of the test suite"
	
	"note that we did not name this method testSuiteClass because it is considered by tools as a test method. it could be suiteClass"
	^ self class classForTestSuite
]

{ #category : #private }
TestAsserterCopy >> comparingCollectionBetween: left and: right [
	"Returns a string that shows the size if they are different and the additional items for each left and right"

	| additionalLeft additionalRight sortBlock |
	"use a very slow sort block"
	sortBlock := [ :a :b | a asString <= b asString ].
	additionalLeft := (left difference: right) sorted: sortBlock.
	additionalRight := (right difference: left) sorted: sortBlock.
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: 'Given Collections do not match. Got ';
				lf;
				tab;
				nextPutAll: 'left := ';
				print: left;
				nextPut: $.;
				lf;
				nextPutAll: ' instead of ';
				tab;
				nextPutAll: ' right :=';
				print: right;
				nextPut: $.;
				lf.
			left size = right size
				ifFalse: [ stream
						nextPutAll: 'Collection size does not match: left=';
						print: left size;
						nextPutAll: ' vs. right=';
						print: right size;
						lf ].
			additionalLeft isEmpty
				ifFalse: [ stream
						nextPutAll: 'Got ';
						print: additionalLeft size;
						nextPutAll: ' additional element(s) in the left collection: ';
						tab;
						print: additionalLeft ].
			additionalRight isEmpty
				ifFalse: [ stream
						nextPutAll: 'Got ';
						print: additionalRight size;
						nextPutAll: ' additional element(s) in the right collection: ';
						tab;
						print: additionalRight ] ]
]

{ #category : #private }
TestAsserterCopy >> comparingIdentityStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: actual fullPrintString;
				nextPutAll: ' is not identical to ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]

{ #category : #private }
TestAsserterCopy >> comparingStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: 'Got ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' instead of ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]

{ #category : #factory }
TestAsserterCopy >> defaultTestError [

	^ self classForTestResult error
]

{ #category : #factory }
TestAsserterCopy >> defaultTestFailure [

	^ self classForTestResult failure
]

{ #category : #asserting }
TestAsserterCopy >> deny: aBooleanOrBlock [
	"This method raises an AssertionFailure if aBooleanOrBlock evaluates to true."
	self deny: aBooleanOrBlock description: 'Denial failed'
]

{ #category : #asserting }
TestAsserterCopy >> deny: actualNumber closeTo: expectedNumber [
	"Tell whether the actualNumber and expectedNumber are NOT close to each others with a margin of
	 the default precision (see class-side method #defaultPrecisionsForCloseToComparison).
	"
	self deny: actualNumber closeTo: expectedNumber precision: self class defaultPrecisionsForCloseToComparison
]

{ #category : #asserting }
TestAsserterCopy >> deny: actualNumber closeTo: expectedNumber precision: epsilon [
	"Tell whether the actualNumber and expectedNumber are NOT close to each others with a margin of epsilon."

	^ self
		assert: (actualNumber closeTo: expectedNumber precision: epsilon) not
		description: [ self comparingStringBetween: actualNumber and: expectedNumber ]
]

{ #category : #asserting }
TestAsserterCopy >> deny: aBooleanOrBlock description: aString [
	"This method raises an AssertionFailure with aString as #messageText if
	 aBooleanOrBlock evaluates to true."
	self deny: aBooleanOrBlock description: aString resumable: false
]

{ #category : #asserting }
TestAsserterCopy >> deny: aBooleanOrBlock description: aStringOrBlock resumable: resumableBoolean [
	"Checks if aBooleanOrBlock evaluates to false (by sending #value message to it).
	 aStringOrBlock and resumableBoolean parameters are used similarly as in
	 TestAsserter>>#assert:description:resumable:.
	"
	self
		assert: aBooleanOrBlock value not
		description: aStringOrBlock
		resumable: resumableBoolean
]

{ #category : #asserting }
TestAsserterCopy >> deny: actual equals: expected [
	"This method raises an AssertionFailure if actual is equals (using #= message) to expected.
	 Else it does nothing and execution continues.
	"
	^ self
		deny: expected = actual
		description: [self unexpectedEqualityStringBetween: actual and: expected]
]

{ #category : #asserting }
TestAsserterCopy >> deny: actual identicalTo: expected [
	"Verify whether the actual and the expected are NOT the same object (have the same object pointer so #== returns false)."
	^ self
		deny: expected == actual
		description: [self unexpectedIdentityEqualityStringBetween: actual and: expected]
]

{ #category : #asserting }
TestAsserterCopy >> denyCollection: actualCollection equals: expectedCollection [
	"Raises an AssertionFailure if actualCollection IS EQUAL to expectedCollection (using #= message).
	 I also provide a specialized message for the AssertionFailure in case I fail.
	"

	^ self
		deny: actualCollection = expectedCollection
		description: [ self unexpectedEqualityStringBetween: actualCollection and: expectedCollection ]
]

{ #category : #asserting }
TestAsserterCopy >> denyCollection: actual hasSameElements: expected [
	"Deny that a collection contains the same elements as the given collection. Order is not checked, only the presence/absence of elements."

	self
		deny: ((actual difference: expected) isEmpty and: [ (expected difference: actual) isEmpty ])
		description: 'Given collections match!'
]

{ #category : #asserting }
TestAsserterCopy >> denyCollection: actualCollection includesAll: subcollection [
	"Raises an AssertionFailure if actualCollection INCLUDES all the elements of expectedCollection (by negating result of #includesAll: message).
	 I also provide a specialized message for the AssertionFailure in case I fail.
	"
	
	^ self
		assert: (actualCollection includesAll: subcollection) not
		description: [ actualCollection asString , ' does not include all in ' , subcollection asString ]
]

{ #category : #asserting }
TestAsserterCopy >> denyCollection: actualCollection includesAny: subcollection [
	"Raises an AssertionFailure if actualCollection includes any of the elements of 
	 expectedCollection (by negating result of #includesAny: message).
    I also provide a specialized message for the AssertionFailure in case I fail.
 	"
	^ self
		assert: (actualCollection includesAny: subcollection) not
		description: [ actualCollection asString , ' includes one element of ' , subcollection asString ]
]

{ #category : #asserting }
TestAsserterCopy >> denyEmpty: aCollection [
	^ self assert: aCollection isNotEmpty description: aCollection asString , ' should not have been empty'
]

{ #category : #asserting }
TestAsserterCopy >> executeShould: aBlock inScopeOf: anExceptionalEvent [ 
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: true]
]

{ #category : #asserting }
TestAsserterCopy >> executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: aString [
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: (ex description includesSubstring: aString) not ]
]

{ #category : #asserting }
TestAsserterCopy >> executeShould: aBlock inScopeOf: anException withExceptionDo: anotherBlock [

	^[aBlock value.
 	false] 
		on: anException
		do: [:exception | 
			anotherBlock value: exception.
			exception return: true]
]

{ #category : #asserting }
TestAsserterCopy >> fail [

	^self assert: false
]

{ #category : #asserting }
TestAsserterCopy >> fail: aDescriptionString [

	^self assert: false description: aDescriptionString
]

{ #category : #logging }
TestAsserterCopy >> logFailure: aString [
	self class logFailure: aString.
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock [
	"Evaluate the Block first then execute the assertion"
	<debuggerCompleteToSender>
	self assert: aBlock value
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock description: aString [
	self assert: aBlock value description: aString
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock notTakeMoreThan: aDuration [
    "Evaluate aBlock and if it takes more than given duration
    to run we report a test failure. "
	<debuggerCompleteToSender>
	^ aBlock valueWithin: aDuration onTimeout: [
		self 
			assert: false 
			description: ['Block evaluation took more than the expected <1p>' expandMacrosWith: aDuration]
	]
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock notTakeMoreThanMilliseconds: anInteger [
    "For compatibility with other Smalltalks"

   self should: aBlock notTakeMoreThan: (Duration milliSeconds: anInteger).
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock raise: anExceptionalEvent [
	"To test that a particular exception is raised during the execution of a Block"
	<debuggerCompleteToSender>
	^ self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock raise: anExceptionalEvent description: aString [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock raise: anExceptionalEvent whoseDescriptionDoesNotInclude: substring description: aString [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: substring)
		description: aString
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: substring description: aString [ 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: substring)
		description: aString
]

{ #category : #asserting }
TestAsserterCopy >> should: aBlock raise: anException withExceptionDo: anotherBlock [ 
	<debuggerCompleteToSender>
	^self assert: (self executeShould: aBlock inScopeOf: anException withExceptionDo: anotherBlock)
]

{ #category : #asserting }
TestAsserterCopy >> shouldFix: aBlock [
	"Run the block expecting an Exception. Throw an assertion failure if the block does NOT throw an exception."
	<debuggerCompleteToSender>
	^ self should: aBlock raise: Exception
]

{ #category : #asserting }
TestAsserterCopy >> shouldnt: aBlock [
	self deny: aBlock value
]

{ #category : #asserting }
TestAsserterCopy >> shouldnt: aBlock description: aString [
	self deny: aBlock value description: aString
]

{ #category : #asserting }
TestAsserterCopy >> shouldnt: aBlock raise: anExceptionalEvent [  
	<debuggerCompleteToSender>
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
]

{ #category : #asserting }
TestAsserterCopy >> shouldnt: aBlock raise: anExceptionalEvent description: aString [  
 
	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
		description: aString
]

{ #category : #asserting }
TestAsserterCopy >> shouldnt: aBlock raise: anExceptionalEvent whoseDescriptionDoesNotInclude: substring description: aString [ 
	 
	^self
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionNotContaining: substring) not
		description: aString
]

{ #category : #asserting }
TestAsserterCopy >> shouldnt: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: substring description: aString [  
	 
	^self 
		assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: substring) not
		description: aString
]

{ #category : #asserting }
TestAsserterCopy >> signalFailure: aString [
	self classForTestResult failure signal: aString
]

{ #category : #asserting }
TestAsserterCopy >> skip [
	"Don't run this test, and don't mark it as failure"
	TestSkippedCopy signal
]

{ #category : #extensions }
TestAsserterCopy >> skip: aComment [
	"Don't run this test, and don't mark it as failure"
	TestSkippedCopy signal: aComment
]

{ #category : #private }
TestAsserterCopy >> unexpectedEqualityStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: 'Unexpected equality of ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' and ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]

{ #category : #private }
TestAsserterCopy >> unexpectedIdentityEqualityStringBetween: actual and: expected [

	^ String streamContents: [:stream |
			stream
				nextPutAll: 'Unexpected identity equality of ';
				nextPutAll: actual fullPrintString;
				nextPutAll: ' and ';
				nextPutAll: expected fullPrintString;
				nextPutAll: '.']
]
