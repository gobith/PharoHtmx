"
I test the demo app through its request handling, without a server.
"
Class {
	#name : 'GeoDemoAppTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'cookie',
		'token'
	],
	#category : 'GeoHtmx-Demo-Tests',
	#package : 'GeoHtmx-Demo',
	#tag : 'Tests'
}

{ #category : 'helpers' }
GeoDemoAppTest >> htmx: aZnRequest [
	"Answer the body of the response to aZnRequest sent the way htmx sends it."

	aZnRequest headers at: 'HX-Request' put: 'true'.
	^ (self send: aZnRequest) contents
]

{ #category : 'helpers' }
GeoDemoAppTest >> send: aZnRequest [
	"Send aZnRequest as a browser on one of the app's pages does: with the session cookie and the CSRF token of the page. Keep the cookie the app sets."

	| response |
	cookie ifNotNil: [ aZnRequest headers at: 'Cookie' put: cookie ].
	token ifNotNil: [ aZnRequest headers at: 'X-CSRF-Token' put: token ].
	response := app handleRequest: aZnRequest.
	response cookies do: [ :each | each name = app sessions cookieName ifTrue: [ cookie := each nameValueString ] ].
	^ response
]

{ #category : 'running' }
GeoDemoAppTest >> setUp [
	"A fresh app, visited once as a browser would, which gives the session cookie and the CSRF token of the page."

	super setUp.
	app := GeoDemoApp new.
	token := self tokenIn: (self send: (ZnRequest get: '/books')) contents
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testAddAndDeleteTodo [

	| html request id |
	request := ZnRequest post: '/GeoDemoTodoList/add'.
	request entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'text' put: 'Buy milk';
			 yourself).
	html := self htmx: request.
	self assert: (html includesSubstring: '<span>Buy milk</span>').
	id := app showcase todos last id.
	self assert: (self htmx: (ZnRequest delete: '/showcase/todos/' , id printString)) isEmpty.
	self deny: (app showcase todos anySatisfy: [ :each | each id = id ])
]

{ #category : 'tests' }
GeoDemoAppTest >> testAddToCartUpdatesButtonAndCounter [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	html := self htmx: (ZnRequest post: '/cart/1').
	self assert: (html includesSubstring: '✓ In cart (2)').
	self assert: (html includesSubstring: '<a hx-swap-oob="true" id="cart-link" href="/cart">Cart (2)</a>').
	self assert: app cart count equals: 2
]

{ #category : 'tests' }
GeoDemoAppTest >> testBookDetail [

	| html |
	html := self htmx: (ZnRequest get: '/books/2').
	self assert: (html beginsWith: '<h2>Mort</h2>').
	self assert: (html includesSubstring: 'Sold out')
]

{ #category : 'tests' }
GeoDemoAppTest >> testBooksPageIsLayoutWithHeaderAndPage [

	| html |
	html := (self send: (ZnRequest get: '/books')) contents.
	self assert: (html beginsWith: '<!DOCTYPE html>').
	self assert: (html includesSubstring: '<title>Books · PharoHtmx</title>').
	self assert: (html includesSubstring: '<a id="cart-link" href="/cart">Cart (0)</a>').
	self assert: (html includesSubstring: '<h1>Books</h1>').
	self assert: (html includesSubstring: '<ul id="book-list">').
	self assert: (html indexOfSubCollection: '</header>') < (html indexOfSubCollection: '<h1>Books</h1>')
]

{ #category : 'tests' }
GeoDemoAppTest >> testBooksPageKeepsTheQuery [

	| html |
	html := (self send: (ZnRequest get: '/books?q=go')) contents.
	self assert: (html includesSubstring: 'value="go"').
	self assert: (html includesSubstring: 'Going Postal').
	self deny: (html includesSubstring: 'Mort')
]

{ #category : 'tests' }
GeoDemoAppTest >> testCartPage [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	self htmx: (ZnRequest post: '/cart/3').
	self htmx: (ZnRequest post: '/cart/3').
	html := (self send: (ZnRequest get: '/cart')) contents.
	self assert: (html includesSubstring: '<title>Cart · PharoHtmx</title>').
	self assert: (html includesSubstring: 'Cart (3)').
	self assert: (html includesSubstring: '€25.00').
	self assert: (html includesSubstring: '€37.99')
]

{ #category : 'tests' }
GeoDemoAppTest >> testChangeQuantities [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	html := self htmx: (ZnRequest post: '/cart/1/increment').
	self assert: (html beginsWith: '<section id="cart"').
	self assert: (html includesSubstring: 'Cart (2)').
	self htmx: (ZnRequest post: '/cart/1/decrement').
	self assert: (app cart quantityOf: (app catalog at: 1)) equals: 1.
	html := self htmx: (ZnRequest post: '/cart/1/decrement').
	self assert: app cart isEmpty.
	self assert: (html includesSubstring: 'Your cart is empty')
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testClockAndStats [

	self assert: ((self htmx: (ZnRequest get: '/GeoDemoClock/tick')) includesSubstring: 'hx-trigger="every 1s"').
	self assert: ((self htmx: (ZnRequest get: '/GeoDemoStats/load')) includesSubstring: '<dt>Available</dt><dd>4</dd>')
]

{ #category : 'tests' }
GeoDemoAppTest >> testEmptyCartPage [

	| html |
	html := (self send: (ZnRequest get: '/cart')) contents.
	self assert: (html includesSubstring: 'Your cart is empty').
	self deny: (html includesSubstring: '<table>').
	self deny: (html includesSubstring: 'ifFalse:')
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testInfiniteScrollPages [

	| html |
	html := self htmx: (ZnRequest get: '/GeoDemoRows/more?page=2').
	self assert: (html includesSubstring: '<td class="num">11</td>').
	self assert: (html includesSubstring: 'hx-get="/GeoDemoRows/more?page=3"').
	html := self htmx: (ZnRequest get: '/GeoDemoRows/more?page=6').
	self assert: (html includesSubstring: '<td class="num">60</td>').
	self deny: (html includesSubstring: 'hx-get')
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testInlineEditing [

	| html request |
	html := self htmx: (ZnRequest get: '/GeoDemoNote/edit').
	self assert: (html beginsWith: '<div id="note"').
	request := ZnRequest put: '/GeoDemoNote/save'.
	request entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'text' put: 'New text';
			 yourself).
	html := self htmx: request.
	self assert: (html beginsWith: '<div id="note"').
	self assert: (html includesSubstring: '<p>New text</p>').
	self assert: app showcase note equals: 'New text'
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testPingFiresAnEvent [

	| response |
	response := self send: (ZnRequest post: '/GeoDemoPings/ping').
	self assert: (response headers at: 'HX-Trigger') equals: 'pinged'.
	self assert: ((self htmx: (ZnRequest get: '/GeoDemoPings/reload')) includesSubstring: 'Pings: 1')
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testProfileForm [
	"The profile card edits the profile with a form from its Magritte descriptions; wrong values come back with messages and change nothing."

	| html request |
	html := self htmx: (ZnRequest get: '/GeoDemoProfileCard/edit').
	self assert: (html includesSubstring: '<form class="geo-form" hx-put="/GeoDemoProfileCard/save">').
	self assert: (html includesSubstring: '<textarea id="bio" name="bio" rows="4">').
	request := ZnRequest put: '/GeoDemoProfileCard/save'.
	request entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'name' put: '';
			 at: 'email' put: 'nobody';
			 at: 'age' put: '200';
			 yourself).
	html := self htmx: request.
	self assert: (html includesSubstring: 'Input is required but no input given').
	self assert: (html includesSubstring: 'An e-mail address has an @ and a dot').
	self assert: (html includesSubstring: 'Input must be between 0 and 130').
	self assert: app showcase profile name equals: 'Ada Lovelace'.
	request := ZnRequest put: '/GeoDemoProfileCard/save'.
	request entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'name' put: 'Grace Hopper';
			 at: 'email' put: 'grace@example.org';
			 at: 'age' put: '85';
			 at: 'bio' put: 'Found the first bug.';
			 yourself).
	html := self htmx: request.
	self assert: (html includesSubstring: '<dt>Name</dt>').
	self assert: (html includesSubstring: 'Grace Hopper').
	self assert: (html includesSubstring: '<dt>Newsletter</dt>').
	self assert: (html includesSubstring: '<dd>No</dd>').
	self assert: app showcase profile age equals: 85
]

{ #category : 'tests' }
GeoDemoAppTest >> testRemoveAndClear [

	self htmx: (ZnRequest post: '/cart/1').
	self htmx: (ZnRequest post: '/cart/3').
	self htmx: (ZnRequest post: '/cart/1/remove').
	self assert: app cart count equals: 1.
	self htmx: (ZnRequest post: '/cart/clear').
	self assert: app cart isEmpty
]

{ #category : 'tests' }
GeoDemoAppTest >> testRoutesPage [

	| html |
	html := (self send: (ZnRequest get: '/routes')) contents.
	self assert: (html includesSubstring: '<title>Routes · PharoHtmx</title>').
	self assert: (html includesSubstring: '<a href="/cart"><code>/cart</code></a>').
	self assert: (html includesSubstring: '<code>/cart/&lt;id&gt;/increment</code>').
	self assert: (html includesSubstring: '<code>GeoDemoAddButton &gt;&gt; add:</code>').
	self assert: (html includesSubstring: 'Put a book in the cart; answer the new button').
	self deny: (html includesSubstring: 'GeoComponent')
]

{ #category : 'tests' }
GeoDemoAppTest >> testSearchAnswersOnlyTheList [

	| html |
	html := self htmx: (ZnRequest get: '/GeoDemoBookList/search?q=go').
	self assert: (html beginsWith: '<ul id="book-list">').
	self assert: (html includesSubstring: 'Going Postal').
	self deny: (html includesSubstring: 'Mort')
]

{ #category : 'tests' }
GeoDemoAppTest >> testSearchPutsTheQueryInTheAddressBar [

	| request response |
	request := ZnRequest get: '/GeoDemoBookList/search?q=go'.
	request headers at: 'HX-Request' put: 'true'.
	response := self send: request.
	self assert: (response headers at: 'HX-Replace-Url') equals: '/books?q=go'.
	response := self send: (ZnRequest get: '/GeoDemoBookList/search?q=').
	self assert: (response headers at: 'HX-Replace-Url') equals: '/books'
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testShowcasePage [

	| html |
	html := (self send: (ZnRequest get: '/showcase')) contents.
	self assert: (html includesSubstring: '<title>htmx showcase · PharoHtmx</title>').
	self assert: (html allRangesOfSubstring: '<section class="demo">') size equals: 7.
	self assert: (html includesSubstring: 'hx-trigger="load"').
	self assert: (html includesSubstring: 'GeoDemoClock class &gt;&gt; tick:')
]

{ #category : 'tests - showcase' }
GeoDemoAppTest >> testShowcaseShowsTheHtml [
	"Next to the Smalltalk, the showcase shows the HTML that the components write, escaped."

	| html |
	html := (self send: (ZnRequest get: '/showcase')) contents.
	self assert: (html allRangesOfSubstring: '<div class="code-grid">') size equals: 7.
	self assert: (html includesSubstring: '&lt;span class=&quot;clock&quot;').
	self assert: (html includesSubstring: 'hx-get=&quot;/GeoDemoClock/tick&quot;')
]

{ #category : 'tests' }
GeoDemoAppTest >> testUnknownBookIsNotFound [

	self assert: (self send: (ZnRequest post: '/cart/99')) isNotFound.
	self assert: (self send: (ZnRequest get: '/books/abc')) isNotFound
]

{ #category : 'helpers' }
GeoDemoAppTest >> tokenIn: aString [
	"The CSRF token that the layout puts on the body."

	| marker start |
	marker := 'X-CSRF-Token&quot;:&quot;'.
	start := (aString indexOfSubCollection: marker) + marker size.
	^ aString copyFrom: start to: start + 63
]
