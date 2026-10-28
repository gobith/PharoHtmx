"
A small demo of the router and the Razor views: a book list with live search, a detail panel, and a cart with its own page. The counter in the header follows the cart by way of an htmx out-of-band swap.

There is one cart for everyone who visits; per-visitor carts need sessions.

	HxSpikeApp start.    ""http://localhost:8090""
	HxSpikeApp stop
"
Class {
	#name : 'HxSpikeApp',
	#superclass : 'HxApp',
	#instVars : [
		'catalog',
		'cart'
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

{ #category : 'handlers' }
HxSpikeApp >> books: req [
	"The full page, or only the list when htmx asks for it from the search field."

	| query books |
	query := req at: #q ifAbsent: [ '' ].
	books := self catalog select: [ :book | query isEmpty or: [ book title includesSubstring: query caseSensitive: false ] ].
	^ req isHtmx
		  ifTrue: [ (self views bookList: books) contents ]
		  ifFalse: [ (self views booksPage: books cart: self cart) contents ]
]

{ #category : 'data' }
HxSpikeApp >> cart [

	^ cart ifNil: [ cart := HxSpikeCart new ]
]

{ #category : 'handlers' }
HxSpikeApp >> cartChanged [
	"The cart contents for the cart page, plus the counter in the header."

	^ (self views cartChanged: self cart) contents
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

{ #category : 'routes' }
HxSpikeApp >> routes: aRouter [

	aRouter
		get: '/' do: [ :req | ZnResponse redirect: '/books' ];
		get: '/books' do: [ :req | self books: req ];
		get: '/books/<id>' do: [ :req | self withBookFrom: req do: [ :book | (self views bookDetail: book) contents ] ];
		get: '/cart' do: [ :req | (self views cartPage: self cart) contents ];
		post: '/cart/clear' do: [ :req |
				self cart removeAll.
				self cartChanged ];
		post: '/cart/<id>' do: [ :req |
				self withBookFrom: req do: [ :book |
							self cart add: book.
							(self views addedToCart: book cart: self cart) contents ] ];
		post: '/cart/<id>/increment' do: [ :req |
				self withBookFrom: req do: [ :book |
							self cart add: book.
							self cartChanged ] ];
		post: '/cart/<id>/decrement' do: [ :req |
				self withBookFrom: req do: [ :book |
							self cart decrement: book.
							self cartChanged ] ];
		post: '/cart/<id>/remove' do: [ :req |
				self withBookFrom: req do: [ :book |
							self cart remove: book.
							self cartChanged ] ]
]

{ #category : 'accessing' }
HxSpikeApp >> views [

	^ HxSpikeBookViews new
]

{ #category : 'handlers' }
HxSpikeApp >> withBookFrom: req do: aBlock [
	"Evaluate aBlock with the book whose id is in the path; 404 when there is none."

	| id |
	id := (req at: #id) asInteger.
	^ (self catalog detect: [ :book | book id = id ] ifNone: [ nil ])
		  ifNil: [ ZnResponse notFound: req znRequest url ]
		  ifNotNil: [ :book | aBlock value: book ]
]
