Class {
	#name : #PaCombinedMatrixExampleTestCopy,
	#superclass : #PaAbstractExampleTestCopy,
	#instVars : [
		'option3'
	],
	#category : #ParametrizedTests2
}

{ #category : #'building suites' }
PaCombinedMatrixExampleTestCopy class >> testParameters [

	^ ParametrizedTestMatrixCopy new
		addCase: { #option1 -> 'a'. #option2 -> 1};
		addCase: { #option1 -> 'b'. #option2 -> 2};		
		addCase: { #option1 -> 'c'. #option2 -> 3};		
		forSelector: #option3 addOptions: #(a b);
		yourself.
]

{ #category : #accessing }
PaCombinedMatrixExampleTestCopy >> option3 [
	^ option3
]

{ #category : #accessing }
PaCombinedMatrixExampleTestCopy >> option3: aString [ 
	option3 := aString
]
