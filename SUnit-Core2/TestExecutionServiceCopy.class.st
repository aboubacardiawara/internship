Class {
	#name : #TestExecutionServiceCopy,
	#superclass : #Object,
	#instVars : [
		'executionEnvironment',
		'isEnabled'
	],
	#category : #'SUnit-Core2'
}

{ #category : #accessing }
TestExecutionServiceCopy class >> defaultServiceClasses [

	^Array streamContents: [ :s |
		self allSubclassesDo: [ :each | 
			each isAbstract not & each isEnabledByDefault ifTrue: [s nextPut: each ]]]
]

{ #category : #settings }
TestExecutionServiceCopy class >> descriptionForSettingsBrowser [
	^self comment
]

{ #category : #accessing }
TestExecutionServiceCopy class >> enabledServiceClasses [

	^Array streamContents: [ :s |
		self allSubclassesDo: [ :each | 
			each isAbstract not & each isEnabled ifTrue: [s nextPut: each ]]]
]

{ #category : #accessing }
TestExecutionServiceCopy class >> isAbstract [ 
	^self = TestExecutionServiceCopy
]

{ #category : #accessing }
TestExecutionServiceCopy class >> isEnabled [ 
	^isEnabled ifNil: [ isEnabled := self isEnabledByDefault ]
]

{ #category : #accessing }
TestExecutionServiceCopy class >> isEnabled: aBoolean [
	isEnabled := aBoolean
]

{ #category : #testing }
TestExecutionServiceCopy class >> isEnabledByDefault [
	^true
]

{ #category : #settings }
TestExecutionServiceCopy class >> settingsOn: aBuilder [
	"No need for pragma <systemsettings>:
	TestExecutionEnvironment organizes settings for all services.
	It calls this method for every default service class.
	Subclasses should override it to provide specific configuration options"	
	(aBuilder setting: self name)
		target: self;
		parent: #sunit;
		getSelector: #isEnabled;
		setSelector: #isEnabled:;
		default: self isEnabledByDefault;
		label: self name;
		description: self descriptionForSettingsBrowser
]

{ #category : #controlling }
TestExecutionServiceCopy >> cleanUpAfterTest [
	
	isEnabled := self isEnabledByDefault
]

{ #category : #controlling }
TestExecutionServiceCopy >> disable [
	isEnabled := false
]

{ #category : #controlling }
TestExecutionServiceCopy >> enable [
	isEnabled := true
]

{ #category : #accessing }
TestExecutionServiceCopy >> executionEnvironment [
	^ executionEnvironment
]

{ #category : #accessing }
TestExecutionServiceCopy >> executionEnvironment: anObject [
	executionEnvironment := anObject
]

{ #category : #controlling }
TestExecutionServiceCopy >> handleCompletedTest [
]

{ #category : #controlling }
TestExecutionServiceCopy >> handleException: anUnhandledException [
]

{ #category : #controlling }
TestExecutionServiceCopy >> handleNewProcess: aProcess [
]

{ #category : #initialization }
TestExecutionServiceCopy >> initialize [ 
	super initialize.
	
	isEnabled := self isEnabledByDefault
]

{ #category : #accessing }
TestExecutionServiceCopy >> isEnabled [ 
	^isEnabled
]

{ #category : #accessing }
TestExecutionServiceCopy >> isEnabled: aBoolean [
	isEnabled := aBoolean
]

{ #category : #testing }
TestExecutionServiceCopy >> isEnabledByDefault [
	^self class isEnabled
]
