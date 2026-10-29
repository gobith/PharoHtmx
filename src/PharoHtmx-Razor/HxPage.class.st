"
I am a component with an address: a page. Like a route (see HxTRoute), my class side gives my #pattern and an app lists me in its #routes; a new instance of me handles each request for my path.

I answer the whole document: the app's layout with me in it (see HxApp>>layoutFor:). A subclass gives a #title and, like any component, a #render.

	BooksPage class >> pattern [ ^ '/books' ]
	BooksPage >> title [ ^ 'Books' ]
	BooksPage >> render [
	<h1>Books</h1>
	]
"
Class {
	#name : 'HxPage',
	#superclass : 'HxComponent',
	#traits : 'HxTRoute',
	#classTraits : 'HxTRoute classTrait',
	#category : 'PharoHtmx-Razor-Components',
	#package : 'PharoHtmx-Razor',
	#tag : 'Components'
}

{ #category : 'routing' }
HxPage class >> endpoints [
	"A page is an endpoint itself, and may declare more in its class-side methods."

	^ { self } , super endpoints
]

{ #category : 'handling' }
HxPage >> handle [
	"The whole document: the app's layout with me in it."

	^ (app layoutFor: self) toHtml
]

{ #category : 'accessing' }
HxPage >> title [
	"The title of the document; the layout puts it in the head."

	^ ''
]
