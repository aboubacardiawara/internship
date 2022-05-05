Class {
	#name : #TestAnnouncementCopy,
	#superclass : #Announcement,
	#instVars : [
		'test'
	],
	#category : #'SUnit-Core2'
}

{ #category : #'instance creation' }
TestAnnouncementCopy class >> with: aTestCase [
	^self new
		test: aTestCase;
		yourself
]

{ #category : #accessing }
TestAnnouncementCopy >> test [

	^ test
]

{ #category : #accessing }
TestAnnouncementCopy >> test: aTest [

	test := aTest
]
