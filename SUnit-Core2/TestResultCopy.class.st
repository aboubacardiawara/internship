Class {
	#name : #TestResultCopy,
	#superclass : #Object,
	#instVars : [
		'timeStamp',
		'failures',
		'errors',
		'passed',
		'skipped'
	],
	#category : #'SUnit-Core2'
}

{ #category : #exceptions }
TestResultCopy class >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorBackGroundForErrorTest [
	^ self currentTheme testColorError
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorBackGroundForFailureTest [
	^ self currentTheme testColorFailure
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorBackGroundForPassingTest [
	^ self currentTheme testColorPassing
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorText [
	^ Color black
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorTextForErrorTest [
	^ self defaultColorText
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorTextForFailureTest [
	^ self defaultColorText
]

{ #category : #'default - color' }
TestResultCopy class >> defaultColorTextForPassingTest [
	^ self defaultColorText
]

{ #category : #exceptions }
TestResultCopy class >> error [
	^self exError
]

{ #category : #exceptions }
TestResultCopy class >> exError [
	^Error
]

{ #category : #exceptions }
TestResultCopy class >> failure [
	^TestFailureCopy
]

{ #category : #history }
TestResultCopy class >> historyAt: aTestCaseClass [
"I will return the last test dictionary for aTestCaseClass. If none found, I will create a new empty one and link it in the history."

	^ aTestCaseClass history
]

{ #category : #history }
TestResultCopy class >> historyAt: aTestCaseClass put: aDictionary [
	aTestCaseClass history: aDictionary
	"^ self history at: aTestCaseClass put: aDictionary "
]

{ #category : #history }
TestResultCopy class >> historyFor: aTestCaseClass [
	"I return the last test dictionary for aTestCaseClass. 
	If none found, I return an empty dictionary but will not link it to the class in the history."
	
	| history |
	history := aTestCaseClass history.
	history ifNil: [ ^ self newTestDictionary ].
	^ history
	
"	^ self history at: aTestCaseClass ifAbsent: [ self newTestDictionary ]"
]

{ #category : #history }
TestResultCopy class >> newTestDictionary [

	^ Dictionary new at: #timeStamp put: DateAndTime now;
		at: #passed put: Set new;
		at: #failures put: Set new;
		at: #errors put: Set new;
		yourself
]

{ #category : #history }
TestResultCopy class >> removeFromTestHistory: aSelector in: aTestCaseClass [
	| lastRun |
	
	lastRun := self historyFor: aTestCaseClass.
	#(#passed #failures #errors) do:
		[ :set | (lastRun at: set) remove: aSelector ifAbsent: []].
]

{ #category : #exceptions }
TestResultCopy class >> resumableFailure [
	^ResumableTestFailureCopy
]

{ #category : #exceptions }
TestResultCopy class >> signalErrorWith: aString [ 
	self error signal: aString
]

{ #category : #exceptions }
TestResultCopy class >> signalFailureWith: aString [ 
	self failure signal: aString
]

{ #category : #exceptions }
TestResultCopy class >> skip [
	^ TestSkippedCopy
]

{ #category : #history }
TestResultCopy class >> updateTestHistoryFor: aTestCase status: aSymbol [
	| cls sel |
	
	cls := aTestCase class.
	sel := aTestCase selector.
	self removeFromTestHistory: sel in: cls.
	((self historyAt: cls) at: aSymbol ) add: sel.
]

{ #category : #exceptions }
TestResultCopy class >> warning [
	"Warning that should be treated as test failure"
	^Deprecation
]

{ #category : #adding }
TestResultCopy >> addError: aTestCase [
	"We cannot use self errors as that incorporates test expectations and so does not return the stored collection."

	^errors add: aTestCase
]

{ #category : #adding }
TestResultCopy >> addFailure: aTestCase [
	"We cannot use self failures as that incorporates test expectations and so does not return the stored collection."

	^failures add: aTestCase
]

{ #category : #adding }
TestResultCopy >> addPass: aTestCase [
	"We cannot use self passed as that incorporates test expectations and so does not return the stored collection."

	^passed add: aTestCase
]

{ #category : #adding }
TestResultCopy >> addSkip: aTestCase [

	^skipped add: aTestCase
]

{ #category : #accessing }
TestResultCopy >> classesTested [
	^ (self tests collect: [ :testCase | testCase class ]) asSet
]

{ #category : #accessing }
TestResultCopy >> defects [
	^OrderedCollection new
		addAll: self errors;
		addAll: self failures; yourself
]

{ #category : #diff }
TestResultCopy >> diff: aTestResult [
	"Return a collection that contains differences"
	| passed1Selectors failed1Selectors errors1Selectors passed2Selectors failed2Selectors errors2Selectors |
	passed1Selectors := self passed collect: [:testCase | testCase selector].
	failed1Selectors := self failures collect: [:testCase | testCase selector].
	errors1Selectors := self errors collect: [:testCase | testCase selector].

	passed2Selectors := aTestResult passed collect: [:testCase | testCase selector].
	failed2Selectors := aTestResult failures collect: [:testCase | testCase selector].
	errors2Selectors := aTestResult errors collect: [:testCase | testCase selector].
	
	^ {passed1Selectors copyWithoutAll: passed2Selectors .
		failed1Selectors copyWithoutAll: failed2Selectors .
		errors1Selectors copyWithoutAll: errors2Selectors}
]

{ #category : #history }
TestResultCopy >> dispatchResultsIntoHistory [ 

	self classesTested do: 
		[ :testClass | 
		self class
			historyAt: testClass
			put: (self selectResultsForTestCase: testClass) ].
]

{ #category : #accessing }
TestResultCopy >> errorCount [

	^self errors size
]

{ #category : #compatibility }
TestResultCopy >> errors [
	^ self unexpectedErrors
]

{ #category : #accessing }
TestResultCopy >> errors: anOrderedCollection [
	errors := anOrderedCollection
]

{ #category : #accessing }
TestResultCopy >> expectedDefectCount [
	^ self expectedDefects size
]

{ #category : #accessing }
TestResultCopy >> expectedDefects [
	^ (errors, failures asOrderedCollection) select: [:each | each shouldPass not]
]

{ #category : #accessing }
TestResultCopy >> expectedPassCount [
	^ self expectedPasses size
]

{ #category : #accessing }
TestResultCopy >> expectedPasses [
	^ passed select: [:each | each shouldPass]
]

{ #category : #accessing }
TestResultCopy >> failureCount [

	^self failures size
]

{ #category : #compatibility }
TestResultCopy >> failures [
	^ self unexpectedFailures, self unexpectedPasses
]

{ #category : #accessing }
TestResultCopy >> failures: aSet [
	failures := aSet
]

{ #category : #'file in/out' }
TestResultCopy >> fileOutOn: aFileStream [
	"Write in aFileStream like:
	3 run, 2 passes, 0 expected failures, 1 failures, 0 errors, 0 unexpected passes
	Failures:
	SHParserST80Test>>#testNumbers
	
	Errors:"	
	| printer |
	printer := [:title :testCases | 
				aFileStream cr; nextPutAll: title; cr.
				testCases do: [:aTestCase| 
								aTestCase printOn: aFileStream.
								aFileStream cr]].
				
	self printOn: aFileStream.	
	printer value: 'Failures:' value: self failures.
	printer value: 'Errors:' value: self errors.
]

{ #category : #testing }
TestResultCopy >> hasErrors [

	^self errors size > 0
]

{ #category : #testing }
TestResultCopy >> hasFailures [

	^self failures size > 0
]

{ #category : #testing }
TestResultCopy >> hasPassed [

	^self hasErrors not and: [self hasFailures not]
]

{ #category : #initialization }
TestResultCopy >> initialize [
	super initialize.
	passed := OrderedCollection new.
	failures := Set new.
	errors := OrderedCollection new.
	skipped := OrderedCollection new.
	timeStamp := DateAndTime now
]

{ #category : #testing }
TestResultCopy >> isError: aTestCase [

	^self errors includes: aTestCase
]

{ #category : #querying }
TestResultCopy >> isErrorFor: class selector: selector [
	^ self errors anySatisfy: [:testCase | testCase class == class and: [testCase selector == selector]]
]

{ #category : #testing }
TestResultCopy >> isFailure: aTestCase [
	^self failures includes: aTestCase
]

{ #category : #querying }
TestResultCopy >> isFailureFor: class selector: selector [
	^ self failures anySatisfy: [:testCase | testCase class == class and: [testCase selector == selector]]
]

{ #category : #testing }
TestResultCopy >> isPassed: aTestCase [

	^self passed includes: aTestCase
]

{ #category : #querying }
TestResultCopy >> isPassedFor: class selector: selector [
	^ self passed anySatisfy: [:testCase | testCase class == class and: [testCase selector == selector]]
]

{ #category : #combining }
TestResultCopy >> mergeWith: aTestResult [

	timeStamp := DateAndTime now.
	failures addAll: aTestResult failures.
	errors addAll: aTestResult errors.
	passed addAll: aTestResult passed.
	skipped addAll: aTestResult skipped
]

{ #category : #compatibility }
TestResultCopy >> passed [
	^ self expectedPasses, self expectedDefects
]

{ #category : #accessing }
TestResultCopy >> passed: anOrderedCollection [
	passed := anOrderedCollection
]

{ #category : #accessing }
TestResultCopy >> passedCount [

	^self passed size
]

{ #category : #printing }
TestResultCopy >> printOn: aStream [
	self runCount isZero ifTrue: [ ^ aStream nextPutAll: 'No tests ran' ].
	aStream
		print: self runCount;
		nextPutAll: ' ran, ';
		print: self expectedPassCount;
		nextPutAll: ' passed, ';
		print: self skippedCount;
		nextPutAll: ' skipped, ';
		print: self expectedDefectCount;
		nextPutAll: (' expected failure' asPluralBasedOn: self expectedDefectCount); 
		nextPutAll: ', ';
		print: self unexpectedFailureCount;
		nextPutAll: (' failure' asPluralBasedOn: self unexpectedFailureCount);
		nextPutAll: ', ';
		print: self unexpectedErrorCount;
		nextPutAll: (' error' asPluralBasedOn: self unexpectedErrorCount);
		nextPutAll: ', ';
		print: self unexpectedPassCount;
		nextPutAll: ' passed unexpected'
]

{ #category : #running }
TestResultCopy >> runCase: aTestCase [
	[
	aTestCase announce: TestCaseStartedCopy withResult: self.
	aTestCase runCaseManaged.
	aTestCase announce: TestCaseEndedCopy  withResult: self.
	self addPass: aTestCase]
		on: self class failure , self class skip, self class warning, self class error
		do: [:ex | ex sunitAnnounce: aTestCase toResult: self]
]

{ #category : #running }
TestResultCopy >> runCaseForDebug: aTestCase [
	[
	aTestCase announce: TestCaseStartedCopy withResult: self.
	aTestCase runCaseManaged.
	aTestCase announce: TestCaseEndedCopy  withResult: self.
	"To not affect performance of big test suites following logic is not inside addPass: method"
	errors remove: aTestCase ifAbsent: [].
	failures remove: aTestCase ifAbsent: [].
	self addPass: aTestCase]
		on: self class failure , self class skip, self class warning, self class error
		do: [:ex | ex sunitAnnounce: aTestCase toResult: self. ex pass]
]

{ #category : #accessing }
TestResultCopy >> runCount [

	^self passedCount + self failureCount + self errorCount
]

{ #category : #history }
TestResultCopy >> selectResultsForTestCase: aTestCaseClass [
	| passedSelectors errorsSelectors failuresSelectors |
	passedSelectors := self passed
						select: [:testCase | testCase class == aTestCaseClass ] thenCollect: [:testCase | testCase selector].
	errorsSelectors := self errors 
						select: [:testCase | testCase class == aTestCaseClass ] thenCollect:  [:testCase | testCase selector].
	failuresSelectors := self failures 
						select: [:testCase | testCase class == aTestCaseClass ] thenCollect:  [:testCase | testCase selector].
	
	^ self class newTestDictionary 
		at: #passed put: passedSelectors asSet;
		at: #failures put: failuresSelectors asSet;
		at: #errors put: errorsSelectors asSet;
		yourself
]

{ #category : #accessing }
TestResultCopy >> skipped [
	^ skipped
]

{ #category : #accessing }
TestResultCopy >> skippedCount [

	^ self skipped size
]

{ #category : #accessing }
TestResultCopy >> tests [
	^(OrderedCollection new: self runCount)
		addAll: passed;
		addAll: failures;
		addAll: errors;
		addAll: skipped;
		yourself
]

{ #category : #accessing }
TestResultCopy >> timeStamp [
	^ timeStamp
]

{ #category : #accessing }
TestResultCopy >> timeStamp: anObject [
	timeStamp := anObject
]

{ #category : #accessing }
TestResultCopy >> unexpectedErrorCount [
	^ self unexpectedErrors size
]

{ #category : #accessing }
TestResultCopy >> unexpectedErrors [
	^ errors select: [:each | each shouldPass]
]

{ #category : #accessing }
TestResultCopy >> unexpectedFailureCount [
	^ self unexpectedFailures size
]

{ #category : #accessing }
TestResultCopy >> unexpectedFailures [
	^ failures select: [:each | each shouldPass]
]

{ #category : #accessing }
TestResultCopy >> unexpectedPassCount [
	^ self unexpectedPasses size
]

{ #category : #accessing }
TestResultCopy >> unexpectedPasses [
	^ passed select: [:each | each shouldPass not]
]

{ #category : #history }
TestResultCopy >> updateResultsInHistory [
	|classesToNotify|
	classesToNotify:= Set new.
	#(#passed #failures #errors) do: [ :status | 
		(self perform: status) do: [ :testCase | 
			classesToNotify add:testCase class.
			self class updateTestHistoryFor: testCase status: status ] ].
	classesToNotify do:[:cl | 
		cl historyAnnouncer announce: (TestSuiteEndedCopy result: cl)]
]
