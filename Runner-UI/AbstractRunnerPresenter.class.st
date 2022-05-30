"
I am an abstract mini ui runner for tests. 
"
Class {
	#name : #AbstractRunnerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'packagesPresenter',
		'classesPresenter',
		'actionBarPresenter',
		'runner',
		'selectedClasses',
		'resultItemsPresenter',
		'resultDescriptionPresenter'
	],
	#category : #'Runner-UI'
}

{ #category : #'instance creation' }
AbstractRunnerPresenter class >> open [

	<script>
	self subclassResponsibility
]

{ #category : #'presenters-connection' }
AbstractRunnerPresenter >> allDefinedTestCases: aCollectionOfPackage [

	"return all the defined test cases from the giving pavkage"

	^ aCollectionOfPackage collectAll: [ :package | 
		  self definedTestCases: package ]
]

{ #category : #'presenters-connection' }
AbstractRunnerPresenter >> connectPackagesPresenter [

	packagesPresenter
		transmitTo: classesPresenter
		transform: [ :aCollectionOfPackage | 
			aCollectionOfPackage
				ifNotNil: [ self allDefinedTestCases: aCollectionOfPackage ]
				ifNil: [ #(  ) ] ]
]

{ #category : #initialization }
AbstractRunnerPresenter >> connectPresenters [
	super connectPresenters.
	self connectPackagesPresenter
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> containsTestCase: aPackage [

	^ aPackage definedClasses anySatisfy: [ :class | class isTestCase ]
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> debugSelectedTest [

	self rerunSelectedTestAs: [ :test | runner debugFailure: test ]
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> debugerOn1stFailureButtonPresenters [

	^ self newButton
		  label: 'Debug';
		  help: 'Open the debuger on the first failure if some fail';
		  action: [ self runSelectedTestsWithDebugFirstRunner ];
		  yourself
]

{ #category : #initialization }
AbstractRunnerPresenter >> defaultLayout [

	| packagesLayout classesLayout resultLayout |
	packagesLayout := SpBoxLayout newTopToBottom
		                  add: 'Packages (Number of TestCases)'
		                  expand: false;
		                  add: packagesPresenter;
		                  yourself.

	classesLayout := SpBoxLayout newTopToBottom
		                 add: 'Classes' expand: false;
		                 add: classesPresenter;
		                 yourself.

	resultLayout := SpBoxLayout newTopToBottom
		                spacing: 1;
		                add: 'Execution result' expand: false;
		                add: resultDescriptionPresenter height: 70;
		                add: resultItemsPresenter;
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
AbstractRunnerPresenter >> defaultRunnerClass [

	^ TestRunner2
]

{ #category : #'presenters-connection' }
AbstractRunnerPresenter >> definedClasses: aPackage [

	"return all the defined classes from the package either 
	their are test case or not"

	^ aPackage definedClasses
]

{ #category : #'presenters-connection' }
AbstractRunnerPresenter >> definedTestCases: aPackage [

	^ aPackage definedClasses asOrderedCollection select: [ :class | 
		  class isTestCase and: class isAbstract not ]
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> execute: aCollectionOfClasses [

	self initializeRunner.
	aCollectionOfClasses
		do: [ :testCase | 
			runner runCase: testCase.
			self updateResultPresenter ]
		displayingProgress: 'Running Tests'
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> informInProgress [

	resultDescriptionPresenter  text: 'In progress ...'
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> initialize [
	self initializeRunner.
	super initialize
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> initializeActionBarPresenter [

	actionBarPresenter := SpBoxLayout newLeftToRight
		                      spacing: 5;
		                      add: self runTestsButtonPresenter expand: false;
		                      add: self rerunFailuresButtonPresenter expand: false;
		                      add: self debugerOn1stFailureButtonPresenters expand: false;
		                      yourself
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializeClassesPresenter [

	classesPresenter := self instantiate: SpFilteringListPresenter.
	classesPresenter listPresenter beMultipleSelection.
	classesPresenter listPresenter sortingBlock: [ :a :b | 
		a name < b name ].
	classesPresenter
		display: [ :class | 
			class name , ' (' , class testSelectors size asString, ')' ];
		displayIcon: [ :class | class systemIcon ];
		whenSelectionChangedDo: [ :selectionItemMode | 
			selectionItemMode isEmpty ifFalse: [ 
					self selectedClasses: selectionItemMode selectedItems ] ]
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializePackagesPresenter [

	packagesPresenter := self instantiate: SpFilteringListPresenter.
	packagesPresenter listPresenter beMultipleSelection.
	packagesPresenter listPresenter sortingBlock: [ :a :b | 
		a name < b name ].
	packagesPresenter
		display: [ :package | 
			package name , ' ('
			, (self definedTestCases: package) size asString , ')' ];
		displayIcon: [ self iconNamed: #package ];
		items: self packagesWithTests
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializePresenters [

	self initializePackagesPresenter.
	self initializeClassesPresenter.
	self initializeResultPresenter.
	self initializeActionBarPresenter
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializeResultDescriptionPresenter [
	resultDescriptionPresenter := self newText beNotEditable
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializeResultItemsPresenter [
	self subclassResponsibility
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializeResultPresenter [
	self initializeResultDescriptionPresenter.
	self initializeResultItemsPresenter.
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> initializeRunner [

	self runner: (self defaultRunnerClass new
			 accumulateResult;
			 suitePreparator: ShuffleSuitePreparator)
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self windowName;
		initialExtent: 800 @ 600
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> packagesWithTests [

	^ RPackageOrganizer default packages select: [ :package | 
		  self containsTestCase: package ]
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> rerunFailedTests [

	self inform: 'rerunning failures'.
	self runner runFailures.
	self updateResultPresenter
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> rerunFailuresButtonPresenter [

	^ self newButton
		  label: 'Run failures';
		  help: 'run failures';
		  action: [ self rerunFailedTests ];
		  yourself
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> rerunSelectedTestAs: aBlock [
	
	aBlock value: resultItemsPresenter selection selectedItem.
	self updateResultPresenter
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> runSelectedTest [

	self rerunSelectedTestAs: [ :test | runner runFailure: test ]
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> runSelectedTestsWithDebugFirstRunner [

	self runner switchToDebugMode.
	selectedClasses
		do: [ :testCase | 
			runner runCase: testCase.
			self updateResultPresenter ]
		displayingProgress: 'Running Tests'.
	self runner switchToRunMode
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> runTestsButtonPresenter [

	^ self newButton
		  label: 'Run';
		  help: 'Run the selected tests';
		  action: [ self execute: self selectedClasses ];
		  yourself
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> runner [

	^ runner
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> runner: aRunner [

	runner := aRunner
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> selectedClasses [

	^ selectedClasses ifNil: [ selectedClasses := OrderedCollection new ]
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> selectedClasses: aCollectionOfClasses [

	selectedClasses := aCollectionOfClasses
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> updateClassPresenter: aCollectionOfPackages [

	classesPresenter items:
		(aCollectionOfPackages collectAll: [ :package | 
			 self definedTestCases: package ])
]

{ #category : #'buttons-presenters-initialization' }
AbstractRunnerPresenter >> updateResultPresenter [

	| failures resultMessage |
	failures := runner result failures asOrderedCollection.
	resultMessage := runner result asString.
	
	resultItemsPresenter items: failures.
	resultDescriptionPresenter text: resultMessage.
]

{ #category : #'presenters-initialization' }
AbstractRunnerPresenter >> windowName [
	self subclassResponsibility
]
