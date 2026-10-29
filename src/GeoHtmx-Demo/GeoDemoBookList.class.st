"
The list of books; the search field replaces it.
"
Class {
	#name : 'GeoDemoBookList',
	#superclass : 'GeoComponent',
	#instVars : [
		'books'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoBookList class >> books: aCollection [

	^ self new setBooks: aCollection
]

{ #category : 'endpoints' }
GeoDemoBookList class >> search: request [
	"The list for the text in the search field. It also puts the search in the address bar, so a reload or a shared link shows the same search."
	<get>

	| query |
	query := request at: #q ifAbsent: [ '' ].
	^ (GeoHtmxResponse with: (self books: (request app booksMatching: query)))
		  replaceUrl: (query isEmpty
				   ifTrue: [ GeoDemoBooksPage path ]
				   ifFalse: [ GeoDemoBooksPage path , '?q=' , query urlEncoded ]);
		  yourself
]

{ #category : 'accessing' }
GeoDemoBookList >> books [

	^ books
]

{ #category : 'rendering' }
GeoDemoBookList >> render [
<ul id="book-list">
  @books do: [ :book |
    {{ GeoDemoBookRow book: book }}
  ]
</ul>
]

{ #category : 'initialization' }
GeoDemoBookList >> setBooks: aCollection [

	books := aCollection
]
