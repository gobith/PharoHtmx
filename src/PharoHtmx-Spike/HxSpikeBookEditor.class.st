"
The form that edits a book in the detail panel, made from the book's Magritte descriptions by HxMagritteForm. Save shows the details again and updates the book's row in the list out of band; a wrong value shows the form again with a message under the field.
"
Class {
	#name : 'HxSpikeBookEditor',
	#superclass : 'HxComponent',
	#instVars : [
		'book',
		'form'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeBookEditor class >> book: aBook [

	^ self new setBook: aBook
]

{ #category : 'endpoints' }
HxSpikeBookEditor class >> edit: request [
	"The form for a book, in place of its details."

	<get: '/books/<id>/edit'>
	^ request app withBookFrom: request do: [ :book | self book: book ]
]

{ #category : 'endpoints' }
HxSpikeBookEditor class >> save: request [
	"Store the values of the form when they are valid: answer the details and, out of band, the book's row in the list. Otherwise answer the form with its errors."

	<put: '/books/<id>'>
	^ request app withBookFrom: request do: [ :book |
			  | editor |
			  editor := self book: book.
			  (editor form saveFrom: request)
				  ifTrue: [
						  (HxHtmxResponse with: (HxSpikeBookDetail book: book))
							  addOutOfBand: (HxSpikeBookRow book: book);
							  yourself ]
				  ifFalse: [ editor ] ]
]

{ #category : 'accessing' }
HxSpikeBookEditor >> book [

	^ book
]

{ #category : 'accessing' }
HxSpikeBookEditor >> form [
	"The form of the book: Save sends a PUT, Cancel shows the details again; both answer into the detail panel."

	^ form ifNil: [
			  form := (HxMagritteForm on: book)
				          submit: (self hx
						           action: #save: with: book id;
						           target: '#detail');
				          cancel: (self hx
						           action: #show: of: HxSpikeBookDetail with: book id;
						           target: '#detail');
				          yourself ]
]

{ #category : 'rendering' }
HxSpikeBookEditor >> render [
<h2>Edit {{ book title }}</h2>
{{ self form }}
]

{ #category : 'accessing' }
HxSpikeBookEditor >> setBook: aBook [

	book := aBook
]
