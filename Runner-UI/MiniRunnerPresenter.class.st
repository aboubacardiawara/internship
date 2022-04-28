Class {
	#name : #MiniRunnerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'packages',
		'classes'
	],
	#category : #'Runner-UI'
}

{ #category : #'instance creation' }
MiniRunnerPresenter class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #initialization }
MiniRunnerPresenter >> connectClassesPresenter [
]

{ #category : #initialization }
MiniRunnerPresenter >> connectPackagesPresenter [
	packages
		transmitTo: classes
		transform: [ :aPackage | 
			aPackage
				ifNotNil: [ aPackage definedClasses asArray ]
				ifNil: [ #(  ) ] ].
]

{ #category : #initialization }
MiniRunnerPresenter >> connectPresenters [

	self connectPackagesPresenter.
]

{ #category : #initialization }
MiniRunnerPresenter >> defaultLayout [
	| packagesLayout classesLayout |
	packagesLayout := SpBoxLayout newTopToBottom
		add: 'Packages' expand: false;
		add: packages;
		yourself.
		
	classesLayout := SpBoxLayout newTopToBottom
		add: 'Classes' expand: false;
		add: classes;
		yourself.
		
	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: packagesLayout;
			add: classesLayout;
			yourself)
]

{ #category : #initialization }
MiniRunnerPresenter >> initializeClassesPresenter [
	classes := self newList.
	classes
		display: [ :class | class name];
		displayIcon: [ :class | class systemIcon ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : #initialization }
MiniRunnerPresenter >> initializePackagesPresenter [

	packages := self newList.
	packages
		display: [ :package | package name ];
		displayIcon: [ self iconNamed: #package ];
		sortingBlock: [ :a :b | a name < b name ];
		items: RPackageOrganizer default packages
]

{ #category : #initialization }
MiniRunnerPresenter >> initializePresenters [
	self initializePackagesPresenter.
	self initializeClassesPresenter.
]

{ #category : #initialization }
MiniRunnerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'MiniUI for Runner';
		initialExtent: 800 @ 600
]

{ #category : #initialization }
MiniRunnerPresenter >> updatePresenter [

]
