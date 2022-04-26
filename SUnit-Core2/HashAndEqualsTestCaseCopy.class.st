Class {
	#name : #HashAndEqualsTestCaseCopy,
	#superclass : #TestCaseCopy,
	#instVars : [
		'prototypes'
	],
	#category : #'SUnit-Core2'
}

{ #category : #tests }
HashAndEqualsTestCaseCopy class >> isAbstract [ 

	^self == HashAndEqualsTestCaseCopy
]

{ #category : #running }
HashAndEqualsTestCaseCopy >> setUp [
	"Subclasses will add their prototypes into this collection"

	super setUp.
	prototypes := OrderedCollection new
]

{ #category : #tests }
HashAndEqualsTestCaseCopy >> testEquality [
	"Check that prototypes report equality correctly"

	prototypes do: [:p | self assert: (EqualityTesterCopy with: p) result ]
]

{ #category : #tests }
HashAndEqualsTestCaseCopy >> testHash [
	"Check prototypes with equality method hash correctly"

	prototypes do: [:p | self assert: (HashTesterCopy with: p) result ]
]
