"
I test the demo app through its request handling, without a server.
"
Class {
	#name : 'HxSpikeAppTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'helpers' }
HxSpikeAppTest >> htmx: aZnRequest [
	"Answer the body of the response to aZnRequest sent the way htmx sends it."

	aZnRequest headers at: 'HX-Request' put: 'true'.
	^ (app handleRequest: aZnRequest) contents
]

{ #category : 'running' }
HxSpikeAppTest >> setUp [

	super setUp.
	app := HxSpikeApp new
]

{ #category : 'tests' }
HxSpikeAppTest >> testAddToCartUpdatesButtonAndCounter [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	html := self htmx: (ZnRequest post: '/cart/1').
	self assert: (html includesSubstring: '✓ In mandje (2)').
	self assert: (html includesSubstring: '<a id="cart-link" href="/cart" hx-swap-oob="true">Mandje (2)</a>').
	self assert: app cart count equals: 2
]

{ #category : 'tests' }
HxSpikeAppTest >> testCartPage [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	self htmx: (ZnRequest post: '/cart/3').
	self htmx: (ZnRequest post: '/cart/3').
	html := (app handleRequest: (ZnRequest get: '/cart')) contents.
	self assert: (html includesSubstring: '<title>Mandje · PharoHtmx</title>').
	self assert: (html includesSubstring: 'Mandje (3)').
	self assert: (html includesSubstring: '€ 25,00').
	self assert: (html includesSubstring: '€ 37,99')
]

{ #category : 'tests' }
HxSpikeAppTest >> testChangeQuantities [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	html := self htmx: (ZnRequest post: '/cart/1/increment').
	self assert: (html beginsWith: '<section id="cart"').
	self assert: (html includesSubstring: 'Mandje (2)').
	self htmx: (ZnRequest post: '/cart/1/decrement').
	self assert: (app cart quantityOf: (app catalog at: 1)) equals: 1.
	html := self htmx: (ZnRequest post: '/cart/1/decrement').
	self assert: app cart isEmpty.
	self assert: (html includesSubstring: 'Je mandje is leeg')
]

{ #category : 'tests' }
HxSpikeAppTest >> testEmptyCartPage [

	| html |
	html := (app handleRequest: (ZnRequest get: '/cart')) contents.
	self assert: (html includesSubstring: 'Je mandje is leeg').
	self deny: (html includesSubstring: '<table>').
	self deny: (html includesSubstring: 'ifFalse:')
]

{ #category : 'tests' }
HxSpikeAppTest >> testRemoveAndClear [

	self htmx: (ZnRequest post: '/cart/1').
	self htmx: (ZnRequest post: '/cart/3').
	self htmx: (ZnRequest post: '/cart/1/remove').
	self assert: app cart count equals: 1.
	self htmx: (ZnRequest post: '/cart/clear').
	self assert: app cart isEmpty
]

{ #category : 'tests' }
HxSpikeAppTest >> testSearchAnswersOnlyTheList [

	| html |
	html := self htmx: (ZnRequest get: '/books?q=go').
	self assert: (html beginsWith: '<ul id="book-list">').
	self assert: (html includesSubstring: 'Going Postal').
	self deny: (html includesSubstring: 'Mort')
]

{ #category : 'tests' }
HxSpikeAppTest >> testUnknownBookIsNotFound [

	self assert: (app handleRequest: (ZnRequest post: '/cart/99')) isNotFound.
	self assert: (app handleRequest: (ZnRequest get: '/books/abc')) isNotFound
]
