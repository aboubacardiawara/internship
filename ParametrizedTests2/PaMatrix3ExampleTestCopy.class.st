Class {
	#name : #PaMatrix3ExampleTestCopy,
	#superclass : #PaAbstractExampleTestCopy,
	#instVars : [
		'option3'
	],
	#category : #ParametrizedTests2
}

{ #category : #private }
PaMatrix3ExampleTestCopy class >> testParameters [

	^ ParametrizedTestMatrixCopy new
		forSelector: #option1 addOptions: #(a b c);
		forSelector: #option2 addOptions: {[1].[2].[3]};
		forSelector: #option3 addOptions: #(x y z);
		yourself.
]

{ #category : #accessing }
PaMatrix3ExampleTestCopy >> option3 [
	^ option3
]

{ #category : #accessing }
PaMatrix3ExampleTestCopy >> option3: anObject [
	option3 := anObject
]
