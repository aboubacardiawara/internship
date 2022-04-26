Class {
	#name : #ClassFactoryWithOrganizationCopy,
	#superclass : #ClassFactoryForTestCaseCopy,
	#instVars : [
		'organization'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'instance creation' }
ClassFactoryWithOrganizationCopy class >> newWithOrganization: aSystemOrganizer [
	^self new
		organization: aSystemOrganizer;
		yourself
]

{ #category : #cleaning }
ClassFactoryWithOrganizationCopy >> deletePackage [

	| categoriesMatchString |
	categoriesMatchString := self packageName , '-*'.
	self organization
		removeCategoriesMatching: categoriesMatchString;
		removeEmptyCategories
]

{ #category : #creating }
ClassFactoryWithOrganizationCopy >> newClassNamed: aString 
	subclassOf: aClass 
	instanceVariableNames: ivNamesString 
	classVariableNames:  classVarsString [ 
	
	^ self 
		newClassNamed: aString
		subclassOf: aClass 
		instanceVariableNames: ivNamesString 
		classVariableNames: classVarsString 
		category:  (self packageName, '-', self defaultTagPostfix) asSymbol.
]

{ #category : #creating }
ClassFactoryWithOrganizationCopy >> newClassNamed: aString subclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString category: category [

	| newClass |
	newClass := aClass classInstaller make: [ :builder | 
		            builder
			            superclass: aClass;
			            name: aString;
			            layoutClass: aClass classLayout class;
			            slots: ivNamesString asSlotCollection;
			            sharedVariablesFromString: classVarsString;
			            sharedPools: '';
			            category: category asSymbol;
			            environment: self organization environment ].
	self createdClasses add: newClass.
	^ newClass
]

{ #category : #creating }
ClassFactoryWithOrganizationCopy >> newSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString [

	^ self
		  newSubclassOf: aClass
		  instanceVariableNames: ivNamesString
		  classVariableNames: classVarsString
		  category:
		  (self packageName , '-' , self defaultTagPostfix) asSymbol
]

{ #category : #creating }
ClassFactoryWithOrganizationCopy >> newSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString category: category [

	| newClass |
	newClass := aClass classInstaller make: [ :builder | 
		            builder
			            superclass: aClass;
			            name: self newClassName;
			            layoutClass: aClass classLayout class;
			            slots: ivNamesString asSlotCollection;
			            sharedVariablesFromString: classVarsString;
			            sharedPools: '';
			            category: category asSymbol;
			            environment: self organization environment ].
	self createdClasses add: newClass.
	^ newClass
]

{ #category : #accessing }
ClassFactoryWithOrganizationCopy >> organization [

	^ organization
]

{ #category : #accessing }
ClassFactoryWithOrganizationCopy >> organization: aSystemOrganizer [
	organization := aSystemOrganizer
]
