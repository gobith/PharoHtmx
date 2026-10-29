"
The detail panel of one book.
"
Class {
	#name : 'GeoDemoBookDetail',
	#superclass : 'GeoComponent',
	#instVars : [
		'book'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoBookDetail class >> book: aBook [

	^ self new setBook: aBook
]

{ #category : 'endpoints' }
GeoDemoBookDetail class >> show: request [
	"The detail panel of one book."
	<get: '/books/<id>'>

	^ request app withBookFrom: request do: [ :book | self book: book ]
]

{ #category : 'accessing' }
GeoDemoBookDetail >> book [

	^ book
]

{ #category : 'rendering' }
GeoDemoBookDetail >> render [
<h2>{{ book title }}</h2>
<p>Price: {{ book priceString }}</p>
{{ GeoDemoAddButton book: book }}
<button
  {{ self hx
       action: #edit: of: GeoDemoBookEditor with: book id;
       target: '#detail' }}>
  Edit
</button>
]

{ #category : 'initialization' }
GeoDemoBookDetail >> setBook: aBook [

	book := aBook
]
