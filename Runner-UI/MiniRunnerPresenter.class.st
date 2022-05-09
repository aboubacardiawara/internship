Class {
	#name : #MiniRunnerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'packagesPresenter',
		'classesPresenter',
		'actionBarPresenter',
		'resultPresenter',
		'runner',
		'result',
		'selectedPackages',
		'selectedClasses'
	],
	#category : #'Runner-UI'
}

{ #category : #'instance creation' }
MiniRunnerPresenter class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #'presenters-connection' }
MiniRunnerPresenter >> allDefinedTestCases: aCollectionOfPackage [

	"return all the defined test cases from the giving pavkage"

	^ aCollectionOfPackage collectAll: [ :package | 
		  self definedTestCases: package ]
]

{ #category : #'presenters-connection' }
MiniRunnerPresenter >> connectPackagesPresenter [

	packagesPresenter
		transmitTo: classesPresenter
		transform: [ :aCollectionOfPackage | 
			aCollectionOfPackage
				ifNotNil: [ self allDefinedTestCases: aCollectionOfPackage ]
				ifNil: [ #(  ) ] ]
]

{ #category : #initialization }
MiniRunnerPresenter >> connectPresenters [

	self connectPackagesPresenter
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> containsTestCase: aPackage [

	^ aPackage definedClasses anySatisfy: [ :class | class isTestCase ]
]

{ #category : #initialization }
MiniRunnerPresenter >> defaultLayout [

	| packagesLayout classesLayout resultLayout |
	packagesLayout := SpBoxLayout newTopToBottom
		                  add: 'Packages (Number of TestCases)' expand: false;
		                  add: packagesPresenter;
		                  yourself.

	classesLayout := SpBoxLayout newTopToBottom
		                 add: 'Classes' expand: false;
		                 add: classesPresenter;
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

	^ aPackage definedClasses asOrderedCollection select: [ :class | 
		  class isTestCase and: class isAbstract not ]
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> execute: aCollectionOfClasses [

	self initializeRunner.

	aCollectionOfClasses
		do: [ :testCase | runner runCase: testCase ]
		displayingProgress: 'Running Tests'.
	self updateResultPresenter
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> informUser: aMsgContain [

	self inform: 'Info: ' , aMsgContain
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> initialize [

	super initialize
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> initializeActionBarPresenter [

	actionBarPresenter := self newActionBar
		                      add: self runTestsButtonPresenter;
		                      add: self rerunFailuresButtonPresenter;
		                      yourself
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializeClassesPresenter [

	classesPresenter := self instantiate: SpFilteringListPresenter.
	classesPresenter listPresenter beMultipleSelection.
	classesPresenter
		display: [ :class | class name ];
		displayIcon: [ :class | class systemIcon ];
		whenSelectionChangedDo: [ :selectionItemMode | 
			selectionItemMode isEmpty ifFalse: [ 
					self selectedClasses: selectionItemMode selectedItems ] ]
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializePackagesPresenter [

	packagesPresenter := self instantiate: SpFilteringListPresenter.
	packagesPresenter listPresenter beMultipleSelection.
	packagesPresenter
		display: [ :package | 
			package name , ' ('
			, (self definedTestCases: package) size asString , ')' ];
		displayIcon: [ self iconNamed: #package ];
		items: self packagesWithTests
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializePresenters [

	self initializePackagesPresenter.
	self initializeClassesPresenter.
	self initializeresultPresenter.
	self initializeActionBarPresenter
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> initializeRunner [

	self runner: self defaultRunnerClass new accumulateResult
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'MiniUI for Runner';
		initialExtent: 800 @ 600
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> initializeresultPresenter [

	resultPresenter := SpTextPresenter new beNotEditable
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> packagesWithTests [

	^ RPackageOrganizer default packages select: [ :package | 
		  self containsTestCase: package ]
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> rerunFailuresButtonPresenter [

	^ self newButton
		  label: 'Run failures';
		  help: 'run failures';
		  action: [ 
			  self inform: 'rerunning failures'.
			  self runner rerunFailures.
			  self updateResultPresenter ];
		  yourself
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> runTestsButtonPresenter [

	^ self newButton
		  label: 'Run';
		  help: 'Run the selected tests';
		  action: [ self execute: self selectedClasses ];
		  yourself
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> runner [

	^ runner
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> runner: aRunner [

	runner := aRunner
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> selectedClasses [

	^ selectedClasses ifNil: [ selectedClasses := OrderedCollection new ]
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> selectedClasses: aCollectionOfClasses [

	selectedClasses := aCollectionOfClasses
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenter >> updateClassPresenter: aCollectionOfPackages [

	classesPresenter items:
		(aCollectionOfPackages collectAll: [ :package | 
			 self definedTestCases: package ])
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenter >> updateResultPresenter [

	resultPresenter text: runner result asString
]