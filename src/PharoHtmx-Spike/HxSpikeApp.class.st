"
A small demo of the routes and the components: a book list with live search, a detail panel, and a cart with its own page. The counter in the header follows the cart by way of an htmx out-of-band swap.

#routes lists the pages and routes; /routes shows them. #layoutFor: puts every page in the layout, under the header. I hold the data they share.

There is one cart for everyone who visits; per-visitor carts need sessions.

	HxSpikeApp start.    ""http://localhost:8090""
	HxSpikeApp stop
"
Class {
	#name : 'HxSpikeApp',
	#superclass : 'HxApp',
	#instVars : [
		'catalog',
		'cart',
		'showcase'
	],
	#classInstVars : [
		'current'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'server' }
HxSpikeApp class >> start [
	"Port 8080 is taken by Docker and WSL on this machine."

	self stop.
	current := self new startOn: 8090.
	^ current
]

{ #category : 'server' }
HxSpikeApp class >> stop [

	current ifNotNil: [
			current stop.
			current := nil ]
]

{ #category : 'data' }
HxSpikeApp >> booksMatching: aString [
	"The books whose title contains aString, all books when it is empty."

	^ self catalog select: [ :book | aString isEmpty or: [ book title includesSubstring: aString caseSensitive: false ] ]
]

{ #category : 'data' }
HxSpikeApp >> cart [

	^ cart ifNil: [ cart := HxSpikeCart new ]
]

{ #category : 'data' }
HxSpikeApp >> catalog [

	^ catalog ifNil: [
			  catalog := {
				             (HxSpikeBook
					              id: 1
					              title: 'Guards! Guards!'
					              price: 1299
					              available: true).
				             (HxSpikeBook
					              id: 2
					              title: 'Mort'
					              price: 1099
					              available: false).
				             (HxSpikeBook
					              id: 3
					              title: 'Small Gods'
					              price: 1250
					              available: true).
				             (HxSpikeBook
					              id: 4
					              title: 'Going Postal'
					              price: 1399
					              available: true).
				             (HxSpikeBook
					              id: 5
					              title: 'Night Watch'
					              price: 1450
					              available: false).
				             (HxSpikeBook
					              id: 6
					              title: 'Good Omens'
					              price: 1199
					              available: true) } ]
]

{ #category : 'rendering' }
HxSpikeApp >> layoutFor: aPage [
	"Every page sits in the layout, under the header."

	^ HxSpikeLayout
		  header: (HxSpikeHeader cart: self cart)
		  page: aPage
]

{ #category : 'routes' }
HxSpikeApp >> routes [
	"The pages, components and route classes that answer requests, in the order /routes shows them. A component answers with the endpoints in its class-side methods."

	^ {
		  HxSpikeHomeRoute.
		  HxSpikeBooksPage.
		  HxSpikeBookList.
		  HxSpikeBookDetail.
		  HxSpikeCartPage.
		  HxSpikeAddButton.
		  HxSpikeCartTable.
		  HxSpikeShowcasePage.
		  HxSpikeStats.
		  HxSpikeClock.
		  HxSpikeRows.
		  HxSpikeNote.
		  HxSpikeTodoList.
		  HxSpikeTodoItem.
		  HxSpikePings.
		  HxSpikeRoutesPage }
]

{ #category : 'data' }
HxSpikeApp >> showcase [

	^ showcase ifNil: [ showcase := HxSpikeShowcase new ]
]

{ #category : 'data' }
HxSpikeApp >> withBookFrom: request do: aBlock [
	"Evaluate aBlock with the book whose id is in the path of request; 404 when there is none."

	| id |
	id := (request at: #id) asInteger.
	^ (self catalog detect: [ :book | book id = id ] ifNone: [ nil ])
		  ifNil: [ ZnResponse notFound: request znRequest url ]
		  ifNotNil: [ :book | aBlock value: book ]
]
