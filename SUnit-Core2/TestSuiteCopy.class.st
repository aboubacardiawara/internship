Class {
	#name : #TestSuiteCopy,
	#superclass : #Object,
	#instVars : [
		'tests',
		'resources',
		'name',
		'announcer'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'instance creation' }
TestSuiteCopy class >> named: aString [

	^self new
		name: aString;
		yourself
]

{ #category : #composing }
TestSuiteCopy >> , aTestSuite [ 

		^ TestSuiteCopy new
			addTests: self tests;
			addTests: aTestSuite tests;
			yourself
]

{ #category : #dependencies }
TestSuiteCopy >> addDependentToHierachy: anObject [
	self addDependent: anObject.
	self tests do: [ :each | each addDependentToHierachy: anObject]
]

{ #category : #accessing }
TestSuiteCopy >> addTest: aTest [
	self tests add: aTest
]

{ #category : #accessing }
TestSuiteCopy >> addTests: aCollection [ 
	aCollection do: [:eachTest | self addTest: eachTest]
]

{ #category : #announcements }
TestSuiteCopy >> announceTest: aTest [
	^ self testSuiteAnnouncer announce: (TestAnnouncementCopy with: aTest).
]

{ #category : #running }
TestSuiteCopy >> debug [
	self setUp.
	[
		self tests do: [:each | 
					each debug.
					self announceTest: each.
					self changed: each.
		]
	] ensure:[ 
		self tearDown. 
	].
]

{ #category : #accessing }
TestSuiteCopy >> defaultResources [
	^self tests
		inject: OrderedCollection new
		into:
			[:coll :testCase |
			testCase resources do:
				[:each |
				(coll includes: each) ifFalse: [coll add: each]].
			coll]
]

{ #category : #accessing }
TestSuiteCopy >> name [

	^name
]

{ #category : #accessing }
TestSuiteCopy >> name: aString [

	name := aString
]

{ #category : #dependencies }
TestSuiteCopy >> removeDependentFromHierachy: anObject [
	self removeDependent: anObject.
	self tests do: [ :each | each removeDependentFromHierachy: anObject]
]

{ #category : #running }
TestSuiteCopy >> resourceClass [

	^ TestResourceCopy
]

{ #category : #accessing }
TestSuiteCopy >> resources [

	^ resources ifNil: [ resources := self defaultResources ]
]

{ #category : #accessing }
TestSuiteCopy >> resources: someOrderedTestResourceClasses [
	"The parameter should understand reverseDo: and should not contain duplicates."

	resources := someOrderedTestResourceClasses
]

{ #category : #running }
TestSuiteCopy >> resultClass [

	^ TestAsserterCopy classForTestResult
]

{ #category : #running }
TestSuiteCopy >> run [
	| result |
	result := self resultClass new.
	self run: result.
	^result
]

{ #category : #running }
TestSuiteCopy >> run: aResult [
	CurrentExecutionEnvironment runTestsBy: [
		self runUnmanaged: aResult ]
]

{ #category : #running }
TestSuiteCopy >> runUnmanaged: aResult [
	self setUp.
	[ self tests
		do: [ :each | 
			each run: aResult.
			self announceTest: each.
			self changed: each ] ]
		ensure: [ self tearDown ]
]

{ #category : #running }
TestSuiteCopy >> setUp [
	self resources do: [:each |
			each isAvailable ifFalse: [ each signalInitializationError ]].
]

{ #category : #running }
TestSuiteCopy >> tearDown [
	self resourceClass resetResources: self resources.
]

{ #category : #announcements }
TestSuiteCopy >> testSuiteAnnouncer [
	^ announcer ifNil: [ announcer := Announcer new. ]
]

{ #category : #accessing }
TestSuiteCopy >> tests [

	^ tests ifNil: [ tests := OrderedCollection new ]
]

{ #category : #announcements }
TestSuiteCopy >> unsubscribe: anAnnouncementClass [ 
	self testSuiteAnnouncer unsubscribe: anAnnouncementClass.
]

{ #category : #announcements }
TestSuiteCopy >> when: aAnnouncement do: aBlock [
	self testSuiteAnnouncer when: aAnnouncement do: aBlock
]
