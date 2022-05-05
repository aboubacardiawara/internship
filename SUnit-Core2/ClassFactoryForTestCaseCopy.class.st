Class {
	#name : #ClassFactoryForTestCaseCopy,
	#superclass : #Object,
	#instVars : [
		'createdClasses',
		'createdTraits',
		'createdSilently'
	],
	#classVars : [
		'Counter'
	],
	#category : #'SUnit-Core2'
}

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> cleanUp [

	| createdClassNames createdTraitNames |
	createdClassNames := self createdClassNames.
	createdTraitNames := self createdTraitNames.

	self 
		deleteClasses;
		deleteTraits;
		deletePackage;
		cleanUpChangeSetForClassNames: createdClassNames;
		cleanUpChangeSetForClassNames: createdTraitNames
]

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> cleanUpChangeSetForClassNames: classeNames [

	self class environment at: #ChangeSet ifPresent: [ :aChangeSetClass |
		| changeSet |
		changeSet := aChangeSetClass current.
		classeNames do: [:name|	
			changeSet 
				removeClassChanges: name;
				removeClassChanges: name, ' class']]
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> createdClassNames [

	^ self createdClasses collect: [ :class | class name ]
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> createdClasses [

	^ createdClasses
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> createdTraitNames [

	^ self createdTraits collect: [ :trait | trait name ]
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> createdTraits [

	^ createdTraits
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> defaultCategory [

	^ (self packageName , '-' , self defaultTagPostfix) asSymbol
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> defaultSuperclass [

	^ Object
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> defaultTagPostfix [

	^ #Default
]

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> delete: aBehavior [

	aBehavior isObsolete ifTrue: [ ^ self ].
	self class environment
		at: #ChangeSet
		ifPresent: [ aBehavior removeFromChanges ].
	(createdSilently includes: aBehavior)
		ifTrue: [ aBehavior removeFromSystemUnlogged ]
		ifFalse: [ aBehavior removeFromSystem ]
]

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> deleteClass: aClass [

	self createdClasses remove: aClass.
	self delete: aClass
]

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> deleteClasses [

	self createdClasses do: [ :class | self delete: class ]
]

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> deletePackage [

	| categoriesMatchString |
	categoriesMatchString := self packageName , '-*'.
	SystemOrganization removeCategoriesMatching: categoriesMatchString
]

{ #category : #cleaning }
ClassFactoryForTestCaseCopy >> deleteTraits [

	self createdTraits do: [ :trait | self delete: trait ]
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> duplicateClass: aClass withNewName: name [

	| newClass |
	newClass := aClass duplicateClassWithNewName: name.
	self createdClasses add: newClass.
	^ newClass
]

{ #category : #initialization }
ClassFactoryForTestCaseCopy >> initialize [

	super initialize.
	createdClasses := IdentitySet new.
	createdTraits := IdentitySet new.
	createdSilently := IdentitySet new
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newClass [

	^ self
		  newSubclassOf: self defaultSuperclass
		  instanceVariableNames: ''
		  classVariableNames: ''
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newClassInCategory: category [

	^ self
		  newSubclassOf: self defaultSuperclass
		  instanceVariableNames: ''
		  classVariableNames: ''
		  category: category
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newClassName [

	| postFix |
	postFix := self nextCount printString.
	^ (#ClassForTestToBeDeleted , postFix) asSymbol
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newClassUsing: aTraitComposition [

	^ self
		  newSubclassOf: self defaultSuperclass
		  uses: aTraitComposition
		  instanceVariableNames: ''
		  classVariableNames: ''
		  category: self defaultTagPostfix
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newClassWithInstanceVariableNames: aString [

	^ self
		  newSubclassOf: self defaultSuperclass
		  instanceVariableNames: aString
		  classVariableNames: ''
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newSubclassOf: aClass [

	^ self
		  newSubclassOf: aClass
		  instanceVariableNames: ''
		  classVariableNames: ''
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString [

	^ self
		  newSubclassOf: aClass
		  uses: {  }
		  instanceVariableNames: ivNamesString
		  classVariableNames: classVarsString
		  category: self defaultTagPostfix
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString category: category [

	^ self
		  newSubclassOf: aClass
		  uses: {  }
		  instanceVariableNames: ivNamesString
		  classVariableNames: classVarsString
		  category: category
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newSubclassOf: aClass uses: aTraitComposition instanceVariableNames: ivNamesString classVariableNames: classVarsString category: category [

	^ self
		  newSubclassOf: aClass
		  uses: aTraitComposition
		  instanceVariableNames: ivNamesString
		  classVariableNames: classVarsString
		  poolDictionaries: ''
		  category: category
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newSubclassOf: aClass uses: aTraitComposition instanceVariableNames: ivNamesString classVariableNames: classVarsString poolDictionaries: poolNamesString category: category [

	| newClass |
	newClass := self class classInstaller make: [ :aBuilder | 
		            aBuilder
			            name: self newClassName;
			            superclass: aClass;
			            traitComposition: aTraitComposition asTraitComposition;
			            slots: ivNamesString asSlotCollection;
			            sharedVariablesFromString: classVarsString;
			            sharedPools: poolNamesString;
			            package: (self packageName , '-' , category) asSymbol ].

	self createdClasses add: newClass.
	^ newClass
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newSubclassOf: aClass using: aTraitComposition [

	^ self
		  newSubclassOf: aClass
		  uses: aTraitComposition
		  instanceVariableNames: ''
		  classVariableNames: ''
		  category: self defaultTagPostfix
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newTrait [

	^ self
		  newTraitNamed: self newTraitName
		  uses: Array new
		  tag: self defaultTagPostfix
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newTraitInTag: aTag [

	^ self
		  newTraitNamed: self newTraitName
		  uses: Array new
		  tag: aTag asSymbol
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newTraitName [

	| postFix |
	postFix := (self createdTraits size + 1) printString.
	^ (#TraitForTestToBeDeleted , postFix) asSymbol
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newTraitNamed: aTraitName uses: aTraitComposition tag: aTag [

	| newTrait |
	newTrait := self class classInstaller make: [ :aBuilder | 
		            aBuilder
			            name: aTraitName;
			            traitComposition: aTraitComposition asTraitComposition;
			            package: (self packageName , '-' , aTag) asSymbol;
			            beTrait ].

	self createdTraits add: newTrait.
	^ newTrait
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> newTraitUsing: aTraitComposition [

	^ self
		  newTraitNamed: self newTraitName
		  uses: aTraitComposition
		  tag: self defaultTagPostfix
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> nextCount [
	"Global counter to avoid name clash between test runs, in case of some previous failure."

	^ Counter := (Counter ifNil: [ 0 ]) + 1
]

{ #category : #accessing }
ClassFactoryForTestCaseCopy >> packageName [

	^ #CategoryForTestToBeDeleted
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> redefineClass: aClass category: aString [

	^ self
		  redefineClass: aClass
		  subclassOf: aClass superclass
		  uses: aClass traitComposition
		  instanceVariableNames: aClass instanceVariablesString
		  classVariableNames: aClass classVariablesString
		  poolDictionaries: aClass sharedPoolsString
		  package: aString
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> redefineClass: aClass instanceVariableNames: aString [

	^ self
		  redefineClass: aClass
		  subclassOf: aClass superclass
		  uses: aClass traitComposition
		  instanceVariableNames: aString
		  classVariableNames: aClass classVariablesString
		  poolDictionaries: aClass sharedPoolsString
		  package: aClass category
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> redefineClass: aClass subclassOf: aSuperclass uses: aTraitComposition instanceVariableNames: ivNamesString classVariableNames: classVarsString poolDictionaries: poolNamesString package: aPackageName [

	| newClass |
	newClass := self class classInstaller make: [ :aBuilder | 
		            aBuilder
			            name: aClass name;
			            superclass: aSuperclass;
			            traitComposition: aTraitComposition asTraitComposition;
			            slots: ivNamesString asSlotCollection;
			            sharedVariablesFromString: classVarsString;
			            sharedPools: poolNamesString;
			            package: aPackageName asSymbol ].

	self createdClasses add: newClass.
	^ newClass
]

{ #category : #'creating - silently' }
ClassFactoryForTestCaseCopy >> silentlyNewClassInCategory: category [

	^ self
		  silentlyNewSubclassOf: self defaultSuperclass
		  instanceVariableNames: ''
		  classVariableNames: ''
		  category: category
]

{ #category : #'creating - silently' }
ClassFactoryForTestCaseCopy >> silentlyNewSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString [
	
	^ self
		silentlyNewSubclassOf: aClass
		instanceVariableNames: ivNamesString
		classVariableNames: classVarsString
		category: self defaultTagPostfix
]

{ #category : #'creating - silently' }
ClassFactoryForTestCaseCopy >> silentlyNewSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString category: category [

	^ self
		  silentlyNewSubclassOf: aClass
		  instanceVariableNames: ivNamesString
		  classVariableNames: classVarsString
		  package: (self packageName , '-' , category) asSymbol
]

{ #category : #'creating - silently' }
ClassFactoryForTestCaseCopy >> silentlyNewSubclassOf: aClass instanceVariableNames: ivNamesString classVariableNames: classVarsString package: packageName [

	SystemAnnouncer uniqueInstance suspendAllWhile: [ 
		^ self
			  newSubclassOf: aClass
			  uses: #(  )
			  instanceVariableNames: ivNamesString
			  classVariableNames: classVarsString
			  poolDictionaries: ''
			  category: packageName ]
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> withNotificationsNewClass [

	^ self withNotificationsNewClassWithInstanceVariableNames: ''
]

{ #category : #creating }
ClassFactoryForTestCaseCopy >> withNotificationsNewClassWithInstanceVariableNames: instanceVariableNames [

	^ self
		  newSubclassOf: Object
		  instanceVariableNames: instanceVariableNames
		  classVariableNames: ''
		  category: self defaultTagPostfix
]
