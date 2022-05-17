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

	classes add: aClass
]

{ #category : #adding }
CoverageRunner >> addTestCase: aTestCase [

	self testSuiteFromClass: aTestCase
]

{ #category : #coverage }
CoverageRunner >> allClassMethods [

	| res |
	res := OrderedCollection new.
	self classes do: [ :class | res addAll: class methods ].
	^ res
]

{ #category : #coverage }
CoverageRunner >> classes [

	^ classes
]

{ #category : #coverage }
CoverageRunner >> collectAllMethodsWithLink [

	methods := self allClassMethods.
	methods do: [ :method | method ast link: link ]
]

{ #category : #coverage }
CoverageRunner >> coverage [

	^ 100 - (100 * self unCovered size // methods size)
]

{ #category : #initialization }
CoverageRunner >> initialize [

	super initialize.
	classes := OrderedCollection new.
	link := MetaLink new
		        selector: #tagExecuted;
		        metaObject: #node
]

{ #category : #coverage }
CoverageRunner >> methods [

	^ methods
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
	
	self collectAllMethodsWithLink.
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

	^ uncovered
]
