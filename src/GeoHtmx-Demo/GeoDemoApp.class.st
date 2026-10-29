"
A small demo of the routes and the components: a book list with live search, a detail panel, and a cart with its own page. The counter in the header follows the cart by way of an htmx out-of-band swap.

#routes lists the pages and routes; /routes shows them. #layoutFor: puts every page in the layout, under the header. I hold the data they share.

There is one cart for everyone who visits; per-visitor carts need sessions.

	GeoDemoApp start.    ""http://localhost:8090""
	GeoDemoApp stop
"
Class {
	#name : 'GeoDemoApp',
	#superclass : 'GeoApp',
	#instVars : [
		'catalog',
		'cart',
		'showcase'
	],
	#classInstVars : [
		'current'
	],
	#category : 'GeoHtmx-Demo-App',
	#package : 'GeoHtmx-Demo',
	#tag : 'App'
}

{ #category : 'server' }
GeoDemoApp class >> start [
	"Port 8080 is taken by Docker and WSL on this machine."

	self stop.
	current := self new startOn: 8090.
	^ current
]

{ #category : 'server' }
GeoDemoApp class >> stop [

	current ifNotNil: [
			current stop.
			current := nil ]
]

{ #category : 'data' }
GeoDemoApp >> booksMatching: aString [
	"The books whose title contains aString, all books when it is empty."

	^ self catalog select: [ :book | aString isEmpty or: [ book title includesSubstring: aString caseSensitive: false ] ]
]

{ #category : 'data' }
GeoDemoApp >> cart [

	^ cart ifNil: [ cart := GeoDemoCart new ]
]

{ #category : 'data' }
GeoDemoApp >> catalog [

	^ catalog ifNil: [
			  catalog := {
				             (GeoDemoBook
					              id: 1
					              title: 'Guards! Guards!'
					              price: 1299
					              available: true).
				             (GeoDemoBook
					              id: 2
					              title: 'Mort'
					              price: 1099
					              available: false).
				             (GeoDemoBook
					              id: 3
					              title: 'Small Gods'
					              price: 1250
					              available: true).
				             (GeoDemoBook
					              id: 4
					              title: 'Going Postal'
					              price: 1399
					              available: true).
				             (GeoDemoBook
					              id: 5
					              title: 'Night Watch'
					              price: 1450
					              available: false).
				             (GeoDemoBook
					              id: 6
					              title: 'Good Omens'
					              price: 1199
					              available: true) } ]
]

{ #category : 'rendering' }
GeoDemoApp >> layoutFor: aPage [
	"Every page sits in the layout, under the header."

	^ GeoDemoLayout
		  header: (GeoDemoHeader cart: self cart)
		  page: aPage
]

{ #category : 'routes' }
GeoDemoApp >> routes [
	"The pages, components and route classes that answer requests, in the order /routes shows them. A component answers with the endpoints in its class-side methods."

	^ {
		  GeoDemoHomeRoute.
		  GeoDemoBooksPage.
		  GeoDemoBookList.
		  GeoDemoBookDetail.
		  GeoDemoBookEditor.
		  GeoDemoCartPage.
		  GeoDemoAddButton.
		  GeoDemoCartTable.
		  GeoDemoShowcasePage.
		  GeoDemoStats.
		  GeoDemoClock.
		  GeoDemoRows.
		  GeoDemoNote.
		  GeoDemoTodoList.
		  GeoDemoTodoItem.
		  GeoDemoPings.
		  GeoDemoProfileCard.
		  GeoDemoRoutesPage }
]

{ #category : 'data' }
GeoDemoApp >> showcase [

	^ showcase ifNil: [ showcase := GeoDemoShowcase new ]
]

{ #category : 'data' }
GeoDemoApp >> withBookFrom: request do: aBlock [
	"Evaluate aBlock with the book whose id is in the path of request; 404 when there is none."

	| id |
	id := (request at: #id) asInteger.
	^ (self catalog detect: [ :book | book id = id ] ifNone: [ nil ])
		  ifNil: [ ZnResponse notFound: request znRequest url ]
		  ifNotNil: [ :book | aBlock value: book ]
]
