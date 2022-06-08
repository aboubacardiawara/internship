"
I am a mini UI TestRunner and i present the result as a List.
"
Class {
	#name : #MiniRunnerPresenterList,
	#superclass : #AbstractRunnerPresenter,
	#category : #'TestRunner-UI'
}

{ #category : #'instance creation' }
MiniRunnerPresenterList class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterList >> initializeResultItemsPresenter [
	resultItemsPresenter := self instantiate: SpListPresenter.
	resultItemsPresenter contextMenu: self resultListContextMenu
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterList >> resultListContextMenu [

	^ self newMenu
		  addItem: [ :item | 
			  item
				  name: 'Rerun';
				  action: [ self runSelectedTest ] ];
		  addItem: [ :item | 
			  item
				  name: 'Debug';
				  action: [ self debugSelectedTest ] ]
]

{ #category : #'buttons-presenters-initialization' }
MiniRunnerPresenterList >> updateResultPresenter [

	| failures resultMessage |
	failures := runner result failures asOrderedCollection.
	resultMessage := runner result asString.
	
	resultItemsPresenter items: failures.
	resultDescriptionPresenter text: resultMessage.
]

{ #category : #'presenters-initialization' }
MiniRunnerPresenterList >> windowName [
	^ 'UIRunner (List)'
]
