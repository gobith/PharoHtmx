"
One item of the to-do list on the showcase page.
"
Class {
	#name : 'HxSpikeTodo',
	#superclass : 'Object',
	#instVars : [
		'id',
		'text'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
HxSpikeTodo class >> id: anInteger text: aString [

	^ self new setId: anInteger text: aString
]

{ #category : 'accessing' }
HxSpikeTodo >> id [

	^ id
]

{ #category : 'initialization' }
HxSpikeTodo >> setId: anInteger text: aString [

	id := anInteger.
	text := aString
]

{ #category : 'accessing' }
HxSpikeTodo >> text [

	^ text
]
