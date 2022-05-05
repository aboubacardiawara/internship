Class {
	#name : #ParametrizedTestOptionCopy,
	#superclass : #Object,
	#instVars : [
		'selector',
		'values'
	],
	#category : #ParametrizedTests2
}

{ #category : #accessing }
ParametrizedTestOptionCopy >> expand [
	^ values
		collect: [ :each | 
			ParametrizedTestExpandedParameterCopy new
				selector: selector;
				valuable: each ]
]

{ #category : #accessing }
ParametrizedTestOptionCopy >> selector [
	^ selector
]

{ #category : #accessing }
ParametrizedTestOptionCopy >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
ParametrizedTestOptionCopy >> values [
	^ values
]

{ #category : #accessing }
ParametrizedTestOptionCopy >> values: anObject [
	values := anObject
]
