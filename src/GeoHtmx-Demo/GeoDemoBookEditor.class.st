"
The form that edits a book in the detail panel, made from the book's Magritte descriptions by GeoMagritteForm. Save shows the details again and updates the book's row in the list out of band; a wrong value shows the form again with a message under the field.
"
Class {
	#name : 'GeoDemoBookEditor',
	#superclass : 'GeoComponent',
	#instVars : [
		'book',
		'form'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoBookEditor class >> book: aBook [

	^ self new setBook: aBook
]

{ #category : 'endpoints' }
GeoDemoBookEditor class >> edit: request [
	"The form for a book, in place of its details."

	<get: '/books/<id>/edit'>
	^ request app withBookFrom: request do: [ :book | self book: book ]
]

{ #category : 'endpoints' }
GeoDemoBookEditor class >> save: request [
	"Store the values of the form when they are valid: answer the details and, out of band, the book's row in the list. Otherwise answer the form with its errors."

	<put: '/books/<id>'>
	^ request app withBookFrom: request do: [ :book |
			  | editor |
			  editor := self book: book.
			  (editor form saveFrom: request)
				  ifTrue: [
						  (GeoHtmxResponse with: (GeoDemoBookDetail book: book))
							  addOutOfBand: (GeoDemoBookRow book: book);
							  yourself ]
				  ifFalse: [ editor ] ]
]

{ #category : 'accessing' }
GeoDemoBookEditor >> book [

	^ book
]

{ #category : 'accessing' }
GeoDemoBookEditor >> form [
	"The form of the book: Save sends a PUT, Cancel shows the details again; both answer into the detail panel."

	^ form ifNil: [
			  form := (GeoMagritteForm on: book)
				          submit: (self hx
						           action: #save: with: book id;
						           target: '#detail');
				          cancel: (self hx
						           action: #show: of: GeoDemoBookDetail with: book id;
						           target: '#detail');
				          yourself ]
]

{ #category : 'rendering' }
GeoDemoBookEditor >> render [
<h2>Edit {{ book title }}</h2>
{{ self form }}
]

{ #category : 'accessing' }
GeoDemoBookEditor >> setBook: aBook [

	book := aBook
]
