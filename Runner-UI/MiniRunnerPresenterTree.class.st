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
		roots: { 'failures' };
		children: [ :parent | 
			parent = 'failures'
				ifTrue: [ runner result failures ]
				ifFalse: '' ]
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenterTree >> updateResultPresenter [

	| resultMessage |
	runner result failures asOrderedCollection.
	resultMessage := runner result asString.
	
	resultDescriptionPresenter text: resultMessage.
	self initializeResultItemsPresenter.
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterTree >> windowName [
	^ 'UIRunner (Tree)'
]
