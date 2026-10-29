"
The book list with a search field and a detail panel.
"
Class {
	#name : 'GeoDemoBooksPage',
	#superclass : 'GeoPage',
	#category : 'GeoHtmx-Demo-Pages',
	#package : 'GeoHtmx-Demo',
	#tag : 'Pages'
}

{ #category : 'routing' }
GeoDemoBooksPage class >> pattern [

	^ '/books'
]

{ #category : 'accessing' }
GeoDemoBooksPage >> books [

	^ app booksMatching: self query
]

{ #category : 'accessing' }
GeoDemoBooksPage >> query [
	"The search text, from the q parameter."

	^ self at: #q ifAbsent: [ '' ]
]

{ #category : 'rendering' }
GeoDemoBooksPage >> render [
<h1>Books</h1>
<input type="search" name="q" value="{{ self query }}" placeholder="Search for a title…"
  {{ self hx
       action: #search: of: GeoDemoBookList;
       triggerOnInputDelay: 300 milliSeconds;
       target: '#book-list';
       swapOuter }}>
{{ GeoDemoBookList books: self books }}
<div id="detail">Click a title for details.</div>
]

{ #category : 'accessing' }
GeoDemoBooksPage >> title [

	^ 'Books'
]
