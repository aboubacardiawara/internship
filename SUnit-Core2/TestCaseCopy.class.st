Class {
	#name : #TestCaseCopy,
	#superclass : #TestAsserterCopy,
	#instVars : [
		'testSelector',
		'expectedFails'
	],
	#classVars : [
		'Announcers',
		'DefaultTimeLimit',
		'HistoryAnnouncer'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'building suites' }
TestCaseCopy class >> addTestsFor: classNameString toSuite: suite [
	| cls |
	cls := self environment at: classNameString ifAbsent: [ ^ suite ].
	^ cls isAbstract
		ifTrue: [ 
			cls allSubclasses
				do: [ :each | 
					each isAbstract
						ifFalse: [ each addToSuiteFromSelectors: suite ] ].
			suite ]
		ifFalse: [ cls addToSuiteFromSelectors: suite ]
]

{ #category : #'building suites' }
TestCaseCopy class >> addToSuite: suite fromMethods: testMethods [ 
	testMethods do:  [ :selector | 
			suite addTest: (self selector: selector) ].
	^suite
]

{ #category : #'building suites' }
TestCaseCopy class >> addToSuiteFromSelectors: suite [
	^self addToSuite: suite fromMethods: (self shouldInheritSelectors
		ifTrue: [ self allTestSelectors ]
		ifFalse: [self testSelectors ])
]

{ #category : #accessing }
TestCaseCopy class >> allTestSelectors [
	| answer pivotClass lookupRoot |
	answer := Set withAll: self testSelectors.
	self shouldInheritSelectors
		ifTrue:
			[pivotClass := self.
			lookupRoot := self lookupHierarchyRoot.
			[pivotClass == lookupRoot]
				whileFalse:
					[pivotClass := pivotClass superclass.
					answer addAll: pivotClass testSelectors]].
	^answer asSortedCollection asOrderedCollection
]

{ #category : #events }
TestCaseCopy class >> announcer [ 
	^ self announcers at: self ifAbsentPut: [ Announcer new ]
]

{ #category : #events }
TestCaseCopy class >> announcers [
	^ Announcers ifNil: [ Announcers := Dictionary new ]
]

{ #category : #'building suites' }
TestCaseCopy class >> buildSuite [
	"Returns a suite of test case. This suite can be composed of local and inherited methods if the superclass is declared as abstract."
	| suite |
	^self isAbstract
		ifTrue: 
			[suite := self suiteClass named: self name asString.
			self allSubclasses 
				do: [:each | each isAbstract ifFalse: [suite addTest: each buildSuiteFromSelectors]].
			suite]
		ifFalse: [self buildSuiteFromSelectors]
]

{ #category : #'building suites' }
TestCaseCopy class >> buildSuiteFromAllSelectors [

	^self buildSuiteFromMethods: self allTestSelectors
]

{ #category : #'building suites' }
TestCaseCopy class >> buildSuiteFromLocalSelectors [

	^self buildSuiteFromMethods: self testSelectors
]

{ #category : #'building suites' }
TestCaseCopy class >> buildSuiteFromMethods: testMethods [

	^testMethods
		inject: (self suiteClass named: self name asString)
		into: [:suite :selector |
			suite
				addTest: (self selector: selector);
				yourself]
]

{ #category : #'building suites' }
TestCaseCopy class >> buildSuiteFromSelectors [
	^self buildSuiteFromMethods: self allTestSelectors
]

{ #category : #'accessing - comment' }
TestCaseCopy class >> classCommentBlank [
	^'This class contains tests'
]

{ #category : #coverage }
TestCaseCopy class >> coverage [
	"returns the coverage determined by a simple static analysis of test coverage 
	made by the receiver on a class that is identified by the name of the receiver.
	We assume that SetTest test Set."

	| cls className |
	(self name endsWith: 'Test')
		ifFalse: [ self error: 'Please, use #coverageForClass: instead' ].
	className := self name copyFrom: 1 to: self name size - 'Test' size.
	cls := self environment at: className asSymbol ifAbsent: [ self error: 'Please, use #coverageForClass: instead' ].	"May happen with Transcript"
	cls isBehavior
		ifFalse: [ cls := cls class ].
	^ self coverageForClass: cls
]

{ #category : #coverage }
TestCaseCopy class >> coverageAsString [
	| cov className |
	cov := self coverage first asInteger. 
	"coverage already checks that the name is ends with 'Test' and if the class tested exists"
	
	className := self name copyFrom: 1 to: (self name size - 'Test' size).
	^ self name asString, ' covers ', cov asString, '% of ', className.
]

{ #category : #coverage }
TestCaseCopy class >> coverageForClass: cls [
	"returns the test coverage of all the methods included inherited ones"
	^ self coverageForClass: cls until: ProtoObject
]

{ #category : #coverage }
TestCaseCopy class >> coverageForClass: cls until: aRootClass [
	"returns the test coverage of all the methods included inherited ones but stopping at aRootClass included"
	
	| definedMethods testedMethods untestedMethods |
	definedMethods := cls allSelectorsAboveUntil: aRootClass.
	definedMethods size = 0
		ifTrue: [^ {0. Set new}].
	testedMethods := 
		self methods inject: Set new into: 
							[:sums :cm | sums union: cm messages].
	testedMethods := testedMethods reject: [:sel | (definedMethods includes: sel) not].
	untestedMethods := definedMethods select: [:selector | (testedMethods includes: selector) not].
	^ { (testedMethods size * 100 / definedMethods size) asFloat . untestedMethods}
]

{ #category : #coverage }
TestCaseCopy class >> coveragePercentage [
	^ self coverage first
]

{ #category : #'instance creation' }
TestCaseCopy class >> debug: aSymbol [

	^(self selector: aSymbol) debug
]

{ #category : #accessing }
TestCaseCopy class >> defaultTestCaseClass [
	^ TestCaseCopy
]

{ #category : #accessing }
TestCaseCopy class >> defaultTimeLimit [
	^DefaultTimeLimit ifNil: [DefaultTimeLimit := 10 seconds]
]

{ #category : #accessing }
TestCaseCopy class >> defaultTimeLimit: aDuration [
	DefaultTimeLimit := aDuration
]

{ #category : #settings }
TestCaseCopy class >> defaultTimeLimitSecs [
	^self defaultTimeLimit asMilliSeconds / 1000.0
]

{ #category : #settings }
TestCaseCopy class >> defaultTimeLimitSecs: aNumber [
	self defaultTimeLimit: aNumber seconds
]

{ #category : #settings }
TestCaseCopy class >> defaultTimeLimitSettingOn: aBuilder [
	<systemsettings>
	
	(aBuilder group: #sunit)
		label: 'SUnit';
		parent: #pharoSystem;
		description: 'SUnit';
		with: [  
			(aBuilder setting: #defaultTimeLimitSecs)
				target: self;
				default: 10.0;
				label: 'Default time limit for tests (secs)' ;
				description: 'Detault time limit in seconds for test execution']
]

{ #category : #history }
TestCaseCopy class >> generateLastStoredRunMethod [

	self shouldGenerateLastStoredRunMethod ifTrue: [
		self class
			compile: (self lastRunMethodNamed: #lastStoredRun)
			classified: 'history' ]
]

{ #category : #'accessing - comment' }
TestCaseCopy class >> hasComment [
	^true
]

{ #category : #testing }
TestCaseCopy class >> hasErrorTest [

	^ (self history at: #errors) isEmpty not
]

{ #category : #testing }
TestCaseCopy class >> hasFailedTest [

	^ (self history at: #failures) isEmpty not
]

{ #category : #testing }
TestCaseCopy class >> hasMethodBeenRun: aSelector [
	^ ((self lastRun at: #errors),
		(self lastRun at: #failures),
		(self lastRun at: #passed))
			includes: aSelector
]

{ #category : #testing }
TestCaseCopy class >> hasPassedTest [

	^ (self history at: #passed) isEmpty not
]

{ #category : #testing }
TestCaseCopy class >> hasTestSelectors [

	^(self selectors anySatisfy: [ :each | 
		(each beginsWith: 'test') and: [
				each numArgs isZero 
			]
		]) or: [ 
			self superclass isTestCase and: [ 
				self shouldInheritSelectors and: [ 
						self superclass hasTestSelectors	
				]
			]
		]
]

{ #category : #history }
TestCaseCopy class >> history [
	^ history ifNil: [ history := self newTestDictionary ]
]

{ #category : #history }
TestCaseCopy class >> history: aDictionary [

	history := aDictionary.
	self historyAnnouncer announce: (TestSuiteEndedCopy result: self)
]

{ #category : #accessing }
TestCaseCopy class >> historyAnnouncer [
	^ HistoryAnnouncer ifNil: [  HistoryAnnouncer := Announcer new ]
]

{ #category : #'class initialization' }
TestCaseCopy class >> initialize [
	SystemAnnouncer uniqueInstance unsubscribe: self.
	SystemAnnouncer uniqueInstance weak
		when: MethodAdded, MethodModified, MethodRemoved 
		send: #methodChanged: 
		to: self
]

{ #category : #testing }
TestCaseCopy class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self name = #TestCaseCopy
]

{ #category : #testing }
TestCaseCopy class >> isTestCase [
	^ true
]

{ #category : #testing }
TestCaseCopy class >> isUnitTest [
	^true
]

{ #category : #testing }
TestCaseCopy class >> isUsed [
	"all my subclasses are used by me"
	^self name = 'TestCase'
		ifTrue: [ super isUsed ]
		ifFalse: [ true ]
]

{ #category : #history }
TestCaseCopy class >> lastRun [
	^ self classForTestResult historyFor: self
]

{ #category : #history }
TestCaseCopy class >> lastRunMethodNamed: aSelector [
	
	^ String streamContents: [:str |
		str nextPutAll: aSelector asString ;cr.
		str tab; nextPutAll: '^ ', (self lastRun) storeString]
]

{ #category : #history }
TestCaseCopy class >> lastStoredRun [
	^ ((Dictionary new) add: (#failures->#()); add: (#passed->#()); add: (#errors->#()); yourself)
]

{ #category : #coverage }
TestCaseCopy class >> localCoverage [
	"returns the coverage determined by a simple static analysis of test coverage 
	made by the receiver on a class that is identified by the name of the receiver.
	We assume that SetTest test Set. The computation of the coverage takes only into
	account the methods defined locally in the tested class. See coverage for a more global 
	coverage"

	| cls className |
	(self name endsWith: 'Test')
		ifFalse: [ self error: 'Please, use #localCoverageForClass: instead' ].
	className := self name copyFrom: 1 to: self name size - 'Test' size.
	cls := self environment at: className asSymbol ifAbsent: [ self error: 'Please, use #localCoverageForClass: instead' ].
	cls isBehavior
		ifFalse: [ cls := cls class ].
	^ self localCoverageForClass: cls
]

{ #category : #coverage }
TestCaseCopy class >> localCoverageAsString [
	| cov className |
	cov := self localCoverage first asInteger. 
	"coverage already checks that the name is ends with 'Test' and if the class tested exists"
	
	className := self name copyFrom: 1 to: (self name size - 'Test' size).
	^ self name asString, ' covers ', cov asString, '% of ', className.
]

{ #category : #coverage }
TestCaseCopy class >> localCoverageForClass: cls [
	
	| definedMethods testedMethods untestedMethods |
	definedMethods := cls selectors.
	"It happens for IdentityBag / IdentityBagTest"
	definedMethods size = 0
		ifTrue: [^ {0. Set new}].

	testedMethods := 
		self methods inject: Set new into: 
							[:sums :cm | sums union: cm messages].
					
	"testedMethods contains all the methods send in test methods, which probably contains methods that have nothing to do with collection"
	testedMethods := testedMethods reject: [:sel | (definedMethods includes: sel) not].

	untestedMethods := definedMethods select: [:selector | (testedMethods includes: selector) not].

	^ { (testedMethods size * 100 / definedMethods size) asFloat . untestedMethods}
]

{ #category : #coverage }
TestCaseCopy class >> localCoveragePercentage [
	^ self localCoverage first
]

{ #category : #accessing }
TestCaseCopy class >> lookupHierarchyRoot [
	^ TestCaseCopy
]

{ #category : #updating }
TestCaseCopy class >> methodChanged: anEvent [
	"Remove the changed method from the known test results."
	
	anEvent method isTestMethod ifFalse: [ ^ self ].
	self classForTestResult removeFromTestHistory: anEvent selector in: anEvent methodClass
]

{ #category : #testing }
TestCaseCopy class >> methodFailed: aSelector [
	^ (self lastRun at: #failures) includes: aSelector
]

{ #category : #testing }
TestCaseCopy class >> methodPassed: aSelector [
	^ (self lastRun at: #passed) includes: aSelector
]

{ #category : #testing }
TestCaseCopy class >> methodProgressed: aSelector [
	^ ((self storedMethodRaisedError: aSelector) or: [self storedMethodFailed: aSelector])
		and: [self methodPassed: aSelector]
]

{ #category : #testing }
TestCaseCopy class >> methodRaisedError: aSelector [
	^ (self lastRun at: #errors) includes: aSelector
]

{ #category : #testing }
TestCaseCopy class >> methodRegressed: aSelector [
	^ (self storedMethodPassed: aSelector) and: [(self methodFailed: aSelector) or: [self methodRaisedError: aSelector]]
]

{ #category : #history }
TestCaseCopy class >> newTestDictionary [

	^ Dictionary new at: #timeStamp put: DateAndTime now;
		at: #passed put: Set new;
		at: #failures put: Set new;
		at: #errors put: Set new;
		yourself
]

{ #category : #events }
TestCaseCopy class >> resetAnnouncer [
	self announcers removeKey: self ifAbsent: []
]

{ #category : #history }
TestCaseCopy class >> resetHistory [
	history := nil
]

{ #category : #accessing }
TestCaseCopy class >> resources [

	^#()
]

{ #category : #'instance creation' }
TestCaseCopy class >> run: aSymbol [
	"Execute a testcase name, aSymbol, and return a test result."
	
	^(self selector: aSymbol) run
]

{ #category : #utilities }
TestCaseCopy class >> runAllAndLogResult [

	"runs all tests in the image"

	TestCaseCopy suite run traceCr
]

{ #category : #'instance creation' }
TestCaseCopy class >> selector: aSymbol [
	"Return a test case with aSymbol as selector but does not execute it."
	^self new setTestSelector: aSymbol
]

{ #category : #events }
TestCaseCopy class >> shouldAnnounce [
	^ self announcers includesKey: self
]

{ #category : #history }
TestCaseCopy class >> shouldGenerateLastStoredRunMethod [
	| sameRun |
	
	(self class includesSelector: #lastStoredRun)
		ifFalse: [^ true].
	sameRun := #(#passed #failures #errors) inject: true into: 
		[ :ok :set | ok and: [(self lastRun at: set) = (self lastStoredRun at: set) ]].
	^ sameRun not
]

{ #category : #testing }
TestCaseCopy class >> shouldInheritSelectors [
	"I should inherit from an Abstract superclass but not from a concrete one by default, unless I have no testSelectors in which case I must be expecting to inherit them from my superclass.  If a test case with selectors wants to inherit selectors from a concrete superclass, override this to true in that subclass."
	
	^self ~~ self lookupHierarchyRoot
		and: [self superclass isAbstract or: [self testSelectors isEmpty]]
]

{ #category : #testing }
TestCaseCopy class >> storedMethodFailed: aSelector [
	^ (self lastStoredRun at: #failures) includes: aSelector
]

{ #category : #testing }
TestCaseCopy class >> storedMethodPassed: aSelector [
	^ (self lastStoredRun at: #passed) includes: aSelector
]

{ #category : #testing }
TestCaseCopy class >> storedMethodRaisedError: aSelector [
	^ (self lastStoredRun at: #errors) includes: aSelector
]

{ #category : #'instance creation' }
TestCaseCopy class >> suite [
	"Return a test suite"
	^self buildSuite
]

{ #category : #accessing }
TestCaseCopy class >> sunitVersion [
	^'4.0'
]

{ #category : #accessing }
TestCaseCopy class >> testSelectors [
	^(self selectors select: [ :each | (each beginsWith: 'test') and: [each numArgs isZero]])
]

{ #category : #testing }
TestCaseCopy class >> whichClassIncludesTestSelector: aSymbol [
	^self whichClassIncludesSelector: aSymbol
]

{ #category : #dependencies }
TestCaseCopy >> addDependentToHierachy: anObject [ 
	"an empty method. for Composite compatibility with TestSuite"
]

{ #category : #events }
TestCaseCopy >> announce: anAnnouncementClass [
	^ self announce: anAnnouncementClass withResult: nil
]

{ #category : #events }
TestCaseCopy >> announce: anAnnouncementClass withResult: result [
	| event |
	self shouldAnnounce ifFalse: [ ^ self ].
	
	event := anAnnouncementClass asAnnouncement.
	event testCase: self.
	event testSelector: testSelector.
	event testResult: result.
	self announcer announce: event.
]

{ #category : #events }
TestCaseCopy >> announcer [
	^ self class announcer
]

{ #category : #private }
TestCaseCopy >> cleanUpInstanceVariables [
	self class allInstVarNames do: [ :name |
		(self instanceVariablesToKeep includes: name) ifFalse: [
			self instVarNamed: name put: nil ] ]
]

{ #category : #running }
TestCaseCopy >> debug [
	| result |
	result := self classForTestResult new.
	[ result runCaseForDebug: self ]
		ensure: [ self classForTestResource resetResources: self resources.
			result updateResultsInHistory  ].
	^ result
]

{ #category : #running }
TestCaseCopy >> debugAsFailure [
	| semaphore |
	semaphore := Semaphore new.
	[ 
	semaphore wait.
	self classForTestResource resetResources: self resources ] fork.
	(self class selector: testSelector) runCaseAsFailure: semaphore
]

{ #category : #accessing }
TestCaseCopy >> defaultTimeLimit [
	^self class defaultTimeLimit
]

{ #category : #private }
TestCaseCopy >> executeShould: aBlock inScopeOf: anExceptionalEvent withDescriptionContaining: aString [
	^[aBlock value.
 	false] on: anExceptionalEvent
		do: [:ex | ex return: (ex description includesSubstring: aString) ]
]

{ #category : #accessing }
TestCaseCopy >> executionEnvironment [
	^CurrentExecutionEnvironment value
]

{ #category : #accessing }
TestCaseCopy >> executionProcessMonitor [
	^self executionEnvironment processMonitor
]

{ #category : #testing }
TestCaseCopy >> expectedFailures [
	| pragmas |
	^ expectedFails ifNil: [
		
		pragmas := Pragma allNamed: #expectedFailure from: self class to: TestCaseCopy.
		expectedFails := pragmas collect: [:each | each method selector  ].
	]
]

{ #category : #running }
TestCaseCopy >> failureLog [	
	^Transcript
]

{ #category : #private }
TestCaseCopy >> instanceVariablesToKeep [
	^ #('testSelector')
]

{ #category : #testing }
TestCaseCopy >> isExpectedFailure [
	^self expectedFailures includes: testSelector
]

{ #category : #running }
TestCaseCopy >> isLogging [
	"By default, we're not logging failures. If you override this in 
	a subclass, make sure that you override #failureLog"
	^false
]

{ #category : #running }
TestCaseCopy >> logFailure: aString [
	self isLogging ifTrue: [
		self failureLog 
			cr; 
			nextPutAll: aString; 
			flush]
]

{ #category : #accessing }
TestCaseCopy >> nameForReport [

	^ self selector
]

{ #category : #'CI support' }
TestCaseCopy >> onPharoCITestingEnvironment [
	
	^ Smalltalk os environment at: 'PHARO_CI_TESTING_ENVIRONMENT' ifPresent: [ true ] ifAbsent: [ false ]
]

{ #category : #running }
TestCaseCopy >> openDebuggerOnFailingTestMethod [
	<haltOrBreakpointForTesting>
	"SUnit has halted one step in front of the failing test method. Step over the 'self halt' and 
	 send into 'self perform: testSelector' to see the failure from the beginning"

	self
		halt;
		performTest
]

{ #category : #private }
TestCaseCopy >> performTest [
	self perform: testSelector asSymbol
]

{ #category : #running }
TestCaseCopy >> prepareToRunAgain [ 	

	"Used by the debugger when a test is restarted
	I'm not 'hidding'' possible exceptions because I think it is best to popup a new debugger
	if some one occurs and let the programmer decide what to do - Hernan"
	self 
		tearDown;
		setUp
]

{ #category : #printing }
TestCaseCopy >> printOn: aStream [
	aStream nextPutAll: self class name asString.
	self printTestSelectorOn: aStream
]

{ #category : #printing }
TestCaseCopy >> printTestSelectorDefiningClass: aClass on: aStream [
	aStream << '('.
	aClass printOn: aStream.
	aStream << ')'
]

{ #category : #printing }
TestCaseCopy >> printTestSelectorOn: aStream [
	testSelector
		ifNotNil: [ 
			| class |
			class := self class whichClassIncludesTestSelector: testSelector.
			class ~= self class
				ifTrue: [ self printTestSelectorDefiningClass: class on: aStream ].
			aStream
				nextPutAll: '>>#';
				nextPutAll: testSelector ]
]

{ #category : #dependencies }
TestCaseCopy >> removeDependentFromHierachy: anObject [ 
	"an empty method. for Composite compatibility with TestSuite"
]

{ #category : #accessing }
TestCaseCopy >> resources [
	"We give TestCase this instance-side method so that methods polymorphic with TestSuite can be code-identical.  Having this instance-side method also helps when writing tests of resource behaviour. Except for such tests, it is rare to override this method and should not be done without thought.  If there were a good reason why a single test case needed to share tests requiring different resources, it might be legitimate."

	^self class resources
]

{ #category : #running }
TestCaseCopy >> run [
	"Execute the receiver and return a test result."
	| result |
	result := self classForTestResult new.
	[ result runCase: self]
		ensure: [ self classForTestResource resetResources: self resources ].
	^ result
]

{ #category : #running }
TestCaseCopy >> run: aResult [
	aResult runCase: self
]

{ #category : #running }
TestCaseCopy >> runCase [
	self resources do: [:each | each availableFor: self].
	[self setUp.
	self performTest] ensure: [
		self tearDown.
		self cleanUpInstanceVariables]
]

{ #category : #running }
TestCaseCopy >> runCaseAsFailure: aSemaphore [
	[self resources do: [:each | each availableFor: self].
	[self setUp.
	self openDebuggerOnFailingTestMethod] ensure: [self tearDown]]
		ensure: [aSemaphore signal]
]

{ #category : #running }
TestCaseCopy >> runCaseManaged [
	CurrentExecutionEnvironment runTestCase: self
]

{ #category : #accessing }
TestCaseCopy >> selector [
	^testSelector
]

{ #category : #private }
TestCaseCopy >> setTestSelector: aSymbol [
	testSelector := aSymbol
]

{ #category : #running }
TestCaseCopy >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
]

{ #category : #events }
TestCaseCopy >> shouldAnnounce [
	^ self class shouldAnnounce
]

{ #category : #testing }
TestCaseCopy >> shouldPass [
	^self isExpectedFailure not
]

{ #category : #'CI support' }
TestCaseCopy >> skipOnPharoCITestingEnvironment [
	
	self onPharoCITestingEnvironment 
		ifTrue: [ self skip ].
]

{ #category : #running }
TestCaseCopy >> tearDown [
	"Hooks that subclasses may override to clean the fixture of test."
]

{ #category : #accessing }
TestCaseCopy >> timeLimit: aDuration [
	^self executionEnvironment maxTimeForTest: aDuration
]
