"
I am a test Coverage runner
"
Class {
	#name : #CoverageRunner,
	#superclass : #Runner,
	#instVars : [
		'classes'
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
CoverageRunner >> collectAllMethodsWithLink: aLink [

	| methods |
	methods := self allClassMethods.
	methods do: [ :method | method ast link: aLink ].
	^ methods
]

{ #category : #coverage }
CoverageRunner >> coverage [

	| methods link notExecuted |
	link := link := MetaLink new
		                selector: #tagExecuted;
		                metaObject: #node.
	methods := self collectAllMethodsWithLink: link.
	[ self runTestsSuites ] ensure: [ link uninstall ].
	notExecuted := methods reject: [ :each | each ast hasBeenExecuted ].
	self removeAnnotationsFrom: methods.
	^ 100 - (100 * notExecuted size // methods size)
]

{ #category : #adding }
CoverageRunner >> initialize [
	super initialize.
	classes := OrderedCollection new.
]

{ #category : #coverage }
CoverageRunner >> removeAnnotationsFrom: aMethod [

	aMethod do: [ :each | 
		each ast removeProperty: #tagExecuted ifAbsent: [  ] ]
]
