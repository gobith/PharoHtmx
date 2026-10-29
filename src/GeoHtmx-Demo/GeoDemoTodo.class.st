"
One item of the to-do list on the showcase page.
"
Class {
	#name : 'GeoDemoTodo',
	#superclass : 'Object',
	#instVars : [
		'id',
		'text'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
GeoDemoTodo class >> id: anInteger text: aString [

	^ self new setId: anInteger text: aString
]

{ #category : 'accessing' }
GeoDemoTodo >> id [

	^ id
]

{ #category : 'initialization' }
GeoDemoTodo >> setId: anInteger text: aString [

	id := anInteger.
	text := aString
]

{ #category : 'accessing' }
GeoDemoTodo >> text [

	^ text
]
