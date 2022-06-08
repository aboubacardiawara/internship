"
I am a mini UI TestRunner and i present the result as a List.
"
Class {
	#name : #TestRunnerListPresenter,
	#superclass : #TestRunnerAbstractPresenter,
	#category : #'TestRunner-UI'
}

{ #category : #'instance creation' }
TestRunnerListPresenter class >> open [ 
	<script>
	
	^ self new open
]

{ #category : #'presenters-initialization' }
TestRunnerListPresenter >> initializeResultItemsPresenter [
	resultItemsPresenter := self instantiate: SpListPresenter.
	resultItemsPresenter contextMenu: self resultListContextMenu
]

{ #category : #'presenters-initialization' }
TestRunnerListPresenter >> resultListContextMenu [

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

{ #category : #'presenters-initialization' }
TestRunnerListPresenter >> windowName [
	^ 'UIRunner (List)'
]
