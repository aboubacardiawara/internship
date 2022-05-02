Class {
	#name : #MiniRunnerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'packages',
		'classes',
		'actionBarPresenter',
		'resultPresenter',
		'selectedClass',
		'runner',
		'result'
	],
	#category : #'Runner-UI'
}

{ #category : #'instance creation' }
MiniRunnerPresenter class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #'presenters-connection' }
MiniRunnerPresenter >> connectClassesPresenter [
]

{ #category : #'presenters-connection' }
MiniRunnerPresenter >> connectPackagesPresenter [
	packages
		transmitTo: classes
		transform: [ :aPackage | 
			aPackage
				ifNotNil: [ self definedTestCases: aPackage ]
				ifNil: [ #(  ) ] ].
]

{ #category : #initialization }
MiniRunnerPresenter >> connectPresenters [

	self connectPackagesPresenter.
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> containsTestCase: aPackage [
	^ aPackage definedClasses anySatisfy: [ :class | class isTestCase ] 
]

{ #category : #initialization }
MiniRunnerPresenter >> defaultLayout [

	| packagesLayout classesLayout resultLayout |
	packagesLayout := SpBoxLayout newTopToBottom
		                  add: 'Packages' expand: false;
		                  add: packages;
		                  yourself.

	classesLayout := SpBoxLayout newTopToBottom
		                 add: 'Classes' expand: false;
		                 add: classes;
		                 yourself.

	resultLayout := SpBoxLayout newTopToBottom
		                add: 'Execution result' expand: false;
		                add: resultPresenter;
		                yourself.

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: packagesLayout;
				   add: classesLayout;
				   add: resultLayout;
				   yourself);
		  addLast: actionBarPresenter expand: false;
		  yourself
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> defaultRunnerClass [
	^ Runner
]

{ #category : #'presenters-connection' }
MiniRunnerPresenter >> definedClasses: aPackage [

	"return all the defined classes from the package either 
	their are test case or not"

	^ aPackage definedClasses
]

{ #category : #'presenters-connection' }
MiniRunnerPresenter >> definedTestCases: aPackage [

	"return all the defined test cases from the giving pavkage"

	^ aPackage definedClasses select: [ :class | class isTestCase ]
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> execute: aClass [

	aClass isTestCase ifTrue: [ 
		result := self runner
			          testSuiteFromClass: aClass;
			          run. ].
		result inspect.
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> informUser: aMsgContain [
	 self inform: 'Info: ', aMsgContain
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> initialize [
	super initialize.
	self runner: self defaultRunnerClass new
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> initializeActionBarPresenter [
	actionBarPresenter := (self newActionBar 
		add: self runTestsButtonPresenter;
		yourself
	)
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializeClassesPresenter [

	classes := self newList.
	classes
		display: [ :class | 
			| label |
			label := class isTestCase
				         ifTrue: ' +'
				         ifFalse: ' -'.
			class name , label ];
		displayIcon: [ :class | class systemIcon ];
		whenSelectionChangedDo: [ :selectionItemMode | 
			selectionItemMode isEmpty ifFalse: [ 
					self selectedClass: selectionItemMode selectedItem ] ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializePackagesPresenter [

	packages := self newList.
	packages
		display: [ :package | package name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		whenSelectionChangedDo: [ :selectionMode | 
			selectionMode isEmpty ifFalse: [ 
					self inform: 'oooh a package is selected' ] ];
		items: self packagesWithTests
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializePresenters [
	self initializePackagesPresenter.
	self initializeClassesPresenter.
	self initializeresultPresenter.
	self initializeActionBarPresenter.
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'MiniUI for Runner';
		initialExtent: 800 @ 600
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializeresultPresenter [

	resultPresenter := self newPresenter
		layout: (SpBoxLayout newTopToBottom
			add: self newList;
			yourself);
		yourself.
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> packagesWithTests [

	^ RPackageOrganizer default packages select: [ :package | 
			self containsTestCase: package
		].
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> runTestsButtonPresenter [
	^ self newButton
		label: 'Start';
		help: 'Run the selected tests';
		action: [self informUser: selectedClass name. self execute: selectedClass];
		yourself.
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> runner [
	^ runner
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> runner: aRunner [
	runner := aRunner 
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> selectedClass: aClass [

	selectedClass := aClass
]

{ #category : #initialization }
MiniRunnerPresenter >> updatePresenter [

]
