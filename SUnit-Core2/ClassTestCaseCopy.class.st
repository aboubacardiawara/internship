Class {
	#name : #ClassTestCaseCopy,
	#superclass : #AbstractEnvironmentTestCaseCopy,
	#category : #'SUnit-Core2'
}

{ #category : #testing }
ClassTestCaseCopy class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self name = #ClassTestCaseCopy
]

{ #category : #testing }
ClassTestCaseCopy class >> mustTestCoverage [

	^ false
]

{ #category : #private }
ClassTestCaseCopy >> categoriesForClass: aClass [

	^ aClass organization allMethodSelectors collect: [ :each | 
		  aClass organization categoryOfElement: each ]
]

{ #category : #coverage }
ClassTestCaseCopy >> classToBeTested [
	
	^ self subclassResponsibility
]

{ #category : #utilities }
ClassTestCaseCopy >> differentMethodsWithSameSelectorBetween: firstClass and: secondClass [

	| repeatedSelectors differentMethodsWithSameSelector |	
	repeatedSelectors := firstClass localSelectors intersection: secondClass localSelectors.
	
	differentMethodsWithSameSelector := repeatedSelectors select: [ :selector | | m1 m2| 
										 m1 := firstClass>>selector. 
										 m2 := secondClass>>selector.
										 m1 sourceCode ~= m2 sourceCode].
									
	^ differentMethodsWithSameSelector
]

{ #category : #utilities }
ClassTestCaseCopy >> repeatedMethodsThatDoNotAccessInstanceVariablesBetween: firstClass and: secondClass [

	| repeatedSelectors repeatedMethodsThatDoNotAccessInstanceVariables |	
	repeatedSelectors := firstClass localSelectors intersection: secondClass localSelectors.
	
	repeatedMethodsThatDoNotAccessInstanceVariables := repeatedSelectors select: [ :selector | | m1 m2| 
										 m1 := firstClass>>selector. 
										 m2 := secondClass>>selector.
										((m1 sourceCode = m2 sourceCode) and: [ m1 hasInstVarRef not ]) and: [ m2 hasInstVarRef not ]].
									
	^ repeatedMethodsThatDoNotAccessInstanceVariables
]

{ #category : #coverage }
ClassTestCaseCopy >> selectorsNotTested [

	^ self selectorsToBeTested difference: self selectorsTested
]

{ #category : #coverage }
ClassTestCaseCopy >> selectorsTested [

	| literals |
	literals := Set new.
	self class selectorsAndMethodsDo: [ :s :m | 
		(s beginsWith: 'test') ifTrue: [ literals addAll: m messages ] ].
	^ literals asArray sort
]

{ #category : #coverage }
ClassTestCaseCopy >> selectorsToBeIgnored [

	^ #(  )
]

{ #category : #coverage }
ClassTestCaseCopy >> selectorsToBeTested [

	^ ({ 
		   self classToBeTested.
		   self classToBeTested class } flatCollect: [ :c | c selectors ]) 
		  difference: self selectorsToBeIgnored
]

{ #category : #private }
ClassTestCaseCopy >> targetClass [

	[ ^ self classToBeTested ]
		on: Error
		do: [ 
			| className |
			className := self class name asString
				             copyFrom: 1
				             to: self class name size - 4.
			^ testingEnvironment at: className asString asSymbol ]
]

{ #category : #tests }
ClassTestCaseCopy >> testCoverage [

	| untested |
	self class mustTestCoverage ifTrue: [ 
		untested := self selectorsNotTested.
		self
			assert: untested isEmpty
			description: untested size asString , ' selectors are not covered' ]
]

{ #category : #tests }
ClassTestCaseCopy >> testNew [

	self targetClass new
]

{ #category : #tests }
ClassTestCaseCopy >> testUnCategorizedMethods [

	| uncategorizedMethods |
	uncategorizedMethods := self targetClass selectorsInProtocol:
		                        Protocol unclassified.
	self
		assert: uncategorizedMethods isEmpty
		description: uncategorizedMethods asString
]
