"
The book list with a search field and a detail panel.
"
Class {
	#name : 'HxSpikeBooksPage',
	#superclass : 'HxPage',
	#category : 'PharoHtmx-Spike-Pages',
	#package : 'PharoHtmx-Spike',
	#tag : 'Pages'
}

{ #category : 'routing' }
HxSpikeBooksPage class >> pattern [

	^ '/books'
]

{ #category : 'accessing' }
HxSpikeBooksPage >> books [

	^ app booksMatching: self query
]

{ #category : 'accessing' }
HxSpikeBooksPage >> query [
	"The search text, from the q parameter."

	^ self at: #q ifAbsent: [ '' ]
]

{ #category : 'rendering' }
HxSpikeBooksPage >> render [
<h1>Books</h1>
<input type="search" name="q" value="{{ self query }}" placeholder="Search for a title…"
       hx-get="{{ HxSpikeBookList pathOf: #search }}" hx-trigger="input changed delay:300ms"
       hx-target="#book-list" hx-swap="outerHTML">
@self render: (HxSpikeBookList books: self books)
<div id="detail">Click a title for details.</div>
]

{ #category : 'accessing' }
HxSpikeBooksPage >> title [

	^ 'Books'
]
