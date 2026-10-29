"
The detail panel of one book.
"
Class {
	#name : 'HxSpikeBookDetail',
	#superclass : 'HxComponent',
	#instVars : [
		'book'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeBookDetail class >> book: aBook [

	^ self new setBook: aBook
]

{ #category : 'endpoints' }
HxSpikeBookDetail class >> show: request [
	"The detail panel of one book."
	<get: '/books/<id>'>

	^ request app withBookFrom: request do: [ :book | self book: book ]
]

{ #category : 'accessing' }
HxSpikeBookDetail >> book [

	^ book
]

{ #category : 'rendering' }
HxSpikeBookDetail >> render [
<h2>{{ book title }}</h2>
<p>Price: {{ book priceString }}</p>
{{ HxSpikeAddButton book: book }}
<button
  {{ self hx
       action: #edit: of: HxSpikeBookEditor with: book id;
       target: '#detail' }}>
  Edit
</button>
]

{ #category : 'initialization' }
HxSpikeBookDetail >> setBook: aBook [

	book := aBook
]
