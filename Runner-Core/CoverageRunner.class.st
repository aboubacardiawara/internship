"
I am a test Coverage runner
"
Class {
	#name : #CoverageRunner,
	#superclass : #Runner,
	#instVars : [
		'classes',
		'link',
		'methods',
		'covered',
		'uncovered'
	],
	#category : #'Runner-Core-Core'
}

{ #category : #adding }
CoverageRunner >> addClass: aClass [

	self classes add: aClass.
	self updateMethods: aClass
]

{ #category : #coverage }
CoverageRunner >> addLinkToAllMethodsFromClasses [

	methods do: [ :method | method ast link: link ]
]

{ #category : #adding }
CoverageRunner >> addTestCase: aTestCase [

	self testSuiteFromClass: aTestCase
]

{ #category : #coverage }
CoverageRunner >> allClassesMethods [

	| res |
	res := OrderedCollection new.
	self classes do: [ :class | res addAll: class methods ].
	^ res
]

{ #category : #coverage }
CoverageRunner >> classes [

	^ classes ifNil: [ classes := OrderedCollection new ]
]

{ #category : #coverage }
CoverageRunner >> coverage [

	self classes isEmpty ifTrue: [ self error: 'Any classes to run' ].
	^ 100 - (100 * self unCovered size // self methods size)
]

{ #category : #testing }
CoverageRunner >> hasClassToRun [

	^ self classes size > 0
]

{ #category : #initialization }
CoverageRunner >> initialize [

	super initialize.
	link := MetaLink new
		        selector: #tagExecuted;
		        metaObject: #node
]

{ #category : #coverage }
CoverageRunner >> initializeMethods [
	methods := self allClassesMethods.
]

{ #category : #accessing }
CoverageRunner >> link [
	^ link
]

{ #category : #coverage }
CoverageRunner >> methods [

	^ methods ifNil: [ methods := OrderedCollection new ]
]

{ #category : #running }
CoverageRunner >> postExecution [

	link uninstall.
	self saveCoveredMethods.
	self saveUnCoveredMethods.
	self removeAnnotationsFromMethods
]

{ #category : #coverage }
CoverageRunner >> preExecution [
	
	self addLinkToAllMethodsFromClasses.
]

{ #category : #coverage }
CoverageRunner >> removeAnnotationsFromMethods [

	methods do: [ :each | 
		each ast removeProperty: #tagExecuted ifAbsent: [  ] ]
]

{ #category : #coverage }
CoverageRunner >> saveCoveredMethods [

	covered := methods select: [ :each | each ast hasBeenExecuted ]
]

{ #category : #coverage }
CoverageRunner >> saveUnCoveredMethods [

	uncovered := methods reject: [ :each | each ast hasBeenExecuted ]
]

{ #category : #coverage }
CoverageRunner >> unCovered [

	^ uncovered ifNil: [ uncovered := OrderedCollection new ]
]

{ #category : #adding }
CoverageRunner >> updateMethods: aClass [

	self methods addAll: aClass methods
]
