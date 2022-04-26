Class {
	#name : #ManifestSUnitCoreCopy,
	#superclass : #PackageManifest,
	#category : #'SUnit-Core2'
}

{ #category : #'code-critics' }
ManifestSUnitCoreCopy class >> ruleExcessiveArgumentsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ClassFactoryForTestCaseCopy #newSubclassOf:uses:instanceVariableNames:classVariableNames:category: #false)) #'2021-12-05T23:11:40.799968+01:00') #(#(#RGMethodDefinition #(#ClassFactoryForTestCaseCopy #newSubclassOf:uses:instanceVariableNames:classVariableNames:poolDictionaries:category: #false)) #'2021-12-05T23:12:15.813959+01:00') #(#(#RGMethodDefinition #(#ClassFactoryForTestCaseCopy #redefineClass:subclassOf:uses:instanceVariableNames:classVariableNames:poolDictionaries:package: #false)) #'2021-12-05T23:13:13.110809+01:00') )
]

{ #category : #'code-critics' }
ManifestSUnitCoreCopy class >> ruleStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ClassFactoryForTestCaseCopy #cleanUpChangeSetForClassNames: #false)) #'2021-12-05T23:07:46.009058+01:00') )
]

{ #category : #'code-critics' }
ManifestSUnitCoreCopy class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ClassTestCaseCopy #categoriesForClass: #false)) #'2021-12-05T23:37:26.237093+01:00') )
]
