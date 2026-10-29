"
The list of books; the search field replaces it.
"
Class {
	#name : 'HxSpikeBookList',
	#superclass : 'HxComponent',
	#instVars : [
		'books'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeBookList class >> books: aCollection [

	^ self new setBooks: aCollection
]

{ #category : 'endpoints' }
HxSpikeBookList class >> search: request [
	"The list for the text in the search field. It also puts the search in the address bar, so a reload or a shared link shows the same search."
	<get>

	| query |
	query := request at: #q ifAbsent: [ '' ].
	^ (HxHtmxResponse with: (self books: (request app booksMatching: query)))
		  replaceUrl: (query isEmpty
				   ifTrue: [ HxSpikeBooksPage path ]
				   ifFalse: [ HxSpikeBooksPage path , '?q=' , query urlEncoded ]);
		  yourself
]

{ #category : 'accessing' }
HxSpikeBookList >> books [

	^ books
]

{ #category : 'rendering' }
HxSpikeBookList >> render [
<ul id="book-list">
  @books do: [ :book |
    {{ HxSpikeBookRow book: book }}
  ]
</ul>
]

{ #category : 'initialization' }
HxSpikeBookList >> setBooks: aCollection [

	books := aCollection
]
