Class {
	#name : #TestResourceCopy,
	#superclass : #TestAsserterCopy,
	#instVars : [
		'name',
		'description'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SUnit-Core2'
}

{ #category : #running }
TestResourceCopy class >> availableFor: aTestAsserter [
	aTestAsserter
		assert: self isAvailable
		description:
			['Unavailable resource ' , self name , ' requested by '
				, aTestAsserter printString]
]

{ #category : #accessing }
TestResourceCopy class >> current [
	"This is a lazy accessor:  the assert of self isAvailable does no work unless current isNil.  However this method should normally be sent only to a resource that should already have been made available, e.g. in a test whose test case class has the resource class in its #resources, so should never be able to fail the assert.
	If the intent is indeed to access a possibly-unprepared or reset-in-earlier-test resource lazily, then preface the call of 'MyResource current' with 'MyResource availableFor: self'."
	
	self
		assert: self isAvailable
		description:
			'Sent #current to unavailable resource ' , self name ,
					'.  Add it to test case'' class-side #resources (recommended) or send #availableFor: beforehand'.
	^current
]

{ #category : #accessing }
TestResourceCopy class >> current: aTestResource [

	current := aTestResource
]

{ #category : #testing }
TestResourceCopy class >> isAbstract [
	"Override to true if a TestResource subclass is Abstract and should not have
	TestCase instances built from it"

	^self name = #TestResourceCopy
]

{ #category : #testing }
TestResourceCopy class >> isAlreadyAvailable [
	^current class == self
]

{ #category : #testing }
TestResourceCopy class >> isAvailable [
	"This is (and must be) a lazy method.  If my current has a value, an attempt to make me available has already been made:  trust its result.  If not, try to make me available."

	current ifNil: [self makeAvailable].
	^self isAlreadyAvailable
]

{ #category : #testing }
TestResourceCopy class >> isUnavailable [

	^self isAvailable not
]

{ #category : #private }
TestResourceCopy class >> makeAvailable [
	"This method must be the _only_ way to set a notNil value for the unique instance (current).  First, obtain a candidate instance and set current to a notNil placeholder (any notNil object not an instance of me would do;  this version uses false).  Next, check any subordinate resources needed by this resource.  Lastly, setUp the candidate and put it in current if it is available, ensuring that it is torn down otherwise."
	
	| candidate |
	current := nil.
	candidate := self new.
	self resources do: [:each | each availableFor: candidate].
	
	"Execute the TestResource's #setUp method within the DefaultExecutionEnvironment to prevent
	forked processes created within #setUp from being terminated by the TestExecutionEnvironment
	(in #checkForkedProcesses) it is running in."
	DefaultExecutionEnvironment beActiveDuring: [[candidate setUp.
	candidate isAvailable ifTrue: [current := candidate]]
		ensure: [current == candidate ifFalse: [candidate tearDown]]]
]

{ #category : #'instance creation' }
TestResourceCopy class >> new [
	"Use #current to get the valid current instance.  Use of #new to get an instance (that should never be the current one) could be done in bizarre circumstances, so is not blocked, but will usually be inappropriate."
	
	^super new initialize.
]

{ #category : #'class initialization' }
TestResourceCopy class >> reset [
	[self isAlreadyAvailable ifTrue: [current tearDown]]
		ensure: [current := nil]
]

{ #category : #private }
TestResourceCopy class >> resetOrAddResourcesTo: aCollection [
	"Add correctly set-up resources to the collection unless already there. Reset any imperfectly-set-up resources, so current isNil will return true if they are re-encountered via an indirectly self-prerequing resource;  circular references cannot be set up so will never reply true to isAlreadyAvailable, but may have correctly-set-up prereqs to add and/or imperfectly-set-up ones to reset, so do not abort the loop first time round."

	current ifNil: [^self].
	self isAlreadyAvailable
		ifFalse:
			[self reset.
			self resources do: [:each | each resetOrAddResourcesTo: aCollection]]
		ifTrue:
			[(aCollection includes: self)
				ifFalse:
					[self resources do: [:each | each resetOrAddResourcesTo: aCollection].
					aCollection add: self]]

"The cloned 'self resources do: ...' line in both blocks is, I think, the best way to write this method so that its logic is clear.  The first loop resets this resource immediately, before traversing its resources;  the second traverses before adding"
]

{ #category : #running }
TestResourceCopy class >> resetResources: topLevelResources [
	"Reset all imperfectly-set-up resources while gathering the rest for ordered resetting."

	| availableResources |
	availableResources := OrderedCollection new: topLevelResources size.
	topLevelResources
		do: [:each | each resetOrAddResourcesTo: availableResources].
	availableResources reverseDo: [:each | each reset]
]

{ #category : #accessing }
TestResourceCopy class >> resources [
	^#()
]

{ #category : #running }
TestResourceCopy class >> signalInitializationError [
	^ self classForTestResult signalFailureWith:  'Resource ' , self name , ' could not be initialized'
]

{ #category : #accessing }
TestResourceCopy >> description [
	^ description ifNil: [ String empty ]
]

{ #category : #accessing }
TestResourceCopy >> description: aString [

	description := aString
]

{ #category : #testing }
TestResourceCopy >> isAvailable [
	"Override to provide information on the readiness of the resource.  Put state-changing behaviour in setUp and keep this a state-preserving check as far as possible.  Where setUp is guaranteed to provide a valid resource if it completes, there is no need to override this."
	
	^true
]

{ #category : #testing }
TestResourceCopy >> isUnavailable [
	"override to provide information on the readiness of the resource"
	
	^self isAvailable not
]

{ #category : #accessing }
TestResourceCopy >> name [
	name ifNil: [ ^ self printString ].
	^ name
]

{ #category : #accessing }
TestResourceCopy >> name: aString [
	name := aString
]

{ #category : #printing }
TestResourceCopy >> printOn: aStream [

	aStream nextPutAll: self class name asString
]

{ #category : #accessing }
TestResourceCopy >> resources [
	^self class resources
]

{ #category : #running }
TestResourceCopy >> setUp [
	"Does nothing. Subclasses should override this to initialize their resource"
]

{ #category : #running }
TestResourceCopy >> tearDown [
	"Does nothing. Subclasses should override this to tear down their resource"
]
