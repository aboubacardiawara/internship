Class {
	#name : #MiniRunnerPresenterTree,
	#superclass : #AbstractRunnerPresenter,
	#category : #'Runner-UI'
}

{ #category : #'instance creation' }
MiniRunnerPresenterTree class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> childreenFor: aParent [

	aParent = #failures ifTrue: [ ^ runner result failures ].
	aParent = #errors ifTrue: [ ^ runner result errors ].
	"..."
	^ {  }
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> generateTree [

	runner allTestPassed ifTrue: [ ^ self ].
	resultItemsPresenter
		roots: self rootCandidates;
		children: [ :parent | 
			(self childreenFor: parent) asOrderedCollection ];
		expandPath: #(1)
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> initializeResultItemsPresenter [

	resultItemsPresenter := self newTreeTable.
	resultItemsPresenter
		addColumn: (SpCompositeTableColumn new
				 title: 'tests';
				 addColumn: (SpStringTableColumn evaluated: #asString);
				 yourself);
		addColumn: (SpCompositeTableColumn new
				 width: 50;
				 title: 'total';
				 yourself);
		contextMenu: self menu.
	self generateTree
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> menu [

	^ self newMenu
		  title: 'Context menu example';
		  addGroup: [ :aGroup | 
			  aGroup
				  addItem: [ :anItem | 
					  anItem
						  name: 'Run';
						  description: 'Run the selected test';
						  action: [ self runSelectedTest ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Debug';
						  description: 'Debug the selected test';
						  action: [ self debugSelectedTest ] ] ]
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> rootCandidates [

	| rootCandidats |
	rootCandidats := OrderedCollection new.
	runner someTestFailed ifTrue: [ rootCandidats add: #failures ].
	runner someTestCausesError ifTrue: [ rootCandidats add: #errors ].
	^ rootCandidats
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenterTree >> updateResultPresenter [

	| resultMessage |
	resultMessage := runner result asString.

	resultDescriptionPresenter text: resultMessage.
	self generateTree
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> windowName [
	^ 'UIRunner (Tree)'
]
