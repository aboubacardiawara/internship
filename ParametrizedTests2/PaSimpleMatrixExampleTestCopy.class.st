Class {
	#name : #PaSimpleMatrixExampleTestCopy,
	#superclass : #ParametrizedTestCaseCopy,
	#instVars : [
		'collectionClass',
		'item1',
		'item2'
	],
	#category : #ParametrizedTests2
}

{ #category : #'building suites' }
PaSimpleMatrixExampleTestCopy class >> testParameters [

	^ ParametrizedTestMatrixCopy new
		forSelector: #item1 addOptions: { 1. 'a'. $c };
		forSelector: #item2 addOptions: { 2. 'b'. $d };
		forSelector: #collectionClass addOptions: 	{ Set. Bag. OrderedCollection }
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> collectionClass [
	^ collectionClass
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> collectionClass: anObject [
	collectionClass := anObject
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> item1 [
	^ item1
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> item1: anObject [
	item1 := anObject
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> item2 [
	^ item2
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> item2: anObject [
	item2 := anObject
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> testAdd [
	
	| aCollection |
	aCollection := collectionClass new.
	aCollection add: item1.
	
	self assert: (aCollection includes: item1).
	self assert: aCollection size equals: 1.
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> testAddAndRemove [
	
	| aCollection |
	aCollection := collectionClass new.
	aCollection add: item1.
	aCollection add: item2.
	
	self assert: (aCollection includes: item1).
	self assert: aCollection size equals: 2.

	aCollection remove: item1.
	
	self deny: (aCollection includes: item1).
	self assert: aCollection size equals: 1.
]

{ #category : #accessing }
PaSimpleMatrixExampleTestCopy >> testIncludes [
	
	| aCollection |
	aCollection := collectionClass new.
	aCollection add: item1.
	aCollection add: item2.
	
	self assert: (aCollection includes: item1).
	self assert: (aCollection includes: item2).
]
