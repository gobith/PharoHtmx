"
I am a component with an address: a page. Like a route (see GeoTRoute), my class side gives my #pattern and an app lists me in its #routes; a new instance of me handles each request for my path.

I answer the whole document: the app's layout with me in it (see GeoApp>>layoutFor:). A subclass gives a #title and, like any component, a #render.

	BooksPage class >> pattern [ ^ '/books' ]
	BooksPage >> title [ ^ 'Books' ]
	BooksPage >> render [
	<h1>Books</h1>
	]
"
Class {
	#name : 'GeoPage',
	#superclass : 'GeoComponent',
	#traits : 'GeoTRoute',
	#classTraits : 'GeoTRoute classTrait',
	#category : 'GeoHtmx-Pages',
	#package : 'GeoHtmx',
	#tag : 'Pages'
}

{ #category : 'routing' }
GeoPage class >> endpoints [
	"A page is an endpoint itself, and may declare more in its class-side methods."

	^ { self } , super endpoints
]

{ #category : 'security' }
GeoPage >> csrfToken [
	"The CSRF token of the visitor's session, for the layout to put on the body with GeoHtmxAttributes>>csrfToken:."

	^ request csrfToken
]

{ #category : 'handling' }
GeoPage >> handle [
	"The whole document: the app's layout with me in it."

	^ (app layoutFor: self) toHtml
]

{ #category : 'accessing' }
GeoPage >> title [
	"The title of the document; the layout puts it in the head."

	^ ''
]
