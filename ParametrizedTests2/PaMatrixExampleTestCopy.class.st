Class {
	#name : #PaMatrixExampleTestCopy,
	#superclass : #PaAbstractExampleTestCopy,
	#category : #ParametrizedTests2
}

{ #category : #private }
PaMatrixExampleTestCopy class >> testParameters [

	^ ParametrizedTestMatrixCopy new
		forSelector: #option1 addOptions: #(a b c);
		forSelector: #option2 addOptions: {[1].[2].[3]};
		yourself.
]
