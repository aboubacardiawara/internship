Class {
	#name : #PaCasesMatrixTestCopy,
	#superclass : #PaAbstractExampleTestCopy,
	#category : #ParametrizedTests2
}

{ #category : #private }
PaCasesMatrixTestCopy class >> testParameters [

	^ ParametrizedTestMatrixCopy new
		addCase: { #option1 -> 'a'. #option2 -> 1};
		addCase: { #option1 -> 'b'. #option2 -> 2};		
		addCase: { #option1 -> 'c'. #option2 -> 3};		
		yourself.
]
