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
MiniRunnerPresenterTree >> generateTree [

	resultItemsPresenter
		roots: { #failures };
		children: [ :parent | 
			parent = #failures
				ifFalse: [ {  } ]
				ifTrue: [ runner result failures ] ]
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
				 yourself).
	self generateTree.
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
