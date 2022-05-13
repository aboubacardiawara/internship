Class {
	#name : #MiniRunnerPresenterList,
	#superclass : #AbstractRunnerPresenter,
	#category : #'Runner-UI'
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
