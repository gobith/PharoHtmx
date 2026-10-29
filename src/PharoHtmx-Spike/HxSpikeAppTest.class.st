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

{ #category : 'tests - showcase' }
HxSpikeAppTest >> testAddAndDeleteTodo [

	| html request id |
	request := ZnRequest post: '/HxSpikeTodoList/add'.
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
HxSpikeAppTest >> testAddToCartUpdatesButtonAndCounter [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	html := self htmx: (ZnRequest post: '/cart/1').
	self assert: (html includesSubstring: '✓ In cart (2)').
	self assert: (html includesSubstring: '<a hx-swap-oob="true" id="cart-link" href="/cart">Cart (2)</a>').
	self assert: app cart count equals: 2
]

{ #category : 'tests' }
HxSpikeAppTest >> testBookDetail [

	| html |
	html := self htmx: (ZnRequest get: '/books/2').
	self assert: (html beginsWith: '<h2>Mort</h2>').
	self assert: (html includesSubstring: 'Sold out')
]

{ #category : 'tests' }
HxSpikeAppTest >> testBooksPageIsLayoutWithHeaderAndPage [

	| html |
	html := (app handleRequest: (ZnRequest get: '/books')) contents.
	self assert: (html beginsWith: '<!DOCTYPE html>').
	self assert: (html includesSubstring: '<title>Books · PharoHtmx</title>').
	self assert: (html includesSubstring: '<a id="cart-link" href="/cart">Cart (0)</a>').
	self assert: (html includesSubstring: '<h1>Books</h1>').
	self assert: (html includesSubstring: '<ul id="book-list">').
	self assert: (html indexOfSubCollection: '</header>') < (html indexOfSubCollection: '<h1>Books</h1>')
]

{ #category : 'tests' }
HxSpikeAppTest >> testBooksPageKeepsTheQuery [

	| html |
	html := (app handleRequest: (ZnRequest get: '/books?q=go')) contents.
	self assert: (html includesSubstring: 'value="go"').
	self assert: (html includesSubstring: 'Going Postal').
	self deny: (html includesSubstring: 'Mort')
]

{ #category : 'tests' }
HxSpikeAppTest >> testCartPage [

	| html |
	self htmx: (ZnRequest post: '/cart/1').
	self htmx: (ZnRequest post: '/cart/3').
	self htmx: (ZnRequest post: '/cart/3').
	html := (app handleRequest: (ZnRequest get: '/cart')) contents.
	self assert: (html includesSubstring: '<title>Cart · PharoHtmx</title>').
	self assert: (html includesSubstring: 'Cart (3)').
	self assert: (html includesSubstring: '€25.00').
	self assert: (html includesSubstring: '€37.99')
]

{ #category : 'tests' }
HxSpikeAppTest >> testChangeQuantities [

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
HxSpikeAppTest >> testClockAndStats [

	self assert: ((self htmx: (ZnRequest get: '/HxSpikeClock/tick')) includesSubstring: 'hx-trigger="every 1s"').
	self assert: ((self htmx: (ZnRequest get: '/HxSpikeStats/load')) includesSubstring: '<dt>Available</dt><dd>4</dd>')
]

{ #category : 'tests' }
HxSpikeAppTest >> testEmptyCartPage [

	| html |
	html := (app handleRequest: (ZnRequest get: '/cart')) contents.
	self assert: (html includesSubstring: 'Your cart is empty').
	self deny: (html includesSubstring: '<table>').
	self deny: (html includesSubstring: 'ifFalse:')
]

{ #category : 'tests - showcase' }
HxSpikeAppTest >> testInfiniteScrollPages [

	| html |
	html := self htmx: (ZnRequest get: '/HxSpikeRows/more?page=2').
	self assert: (html includesSubstring: '<td class="num">11</td>').
	self assert: (html includesSubstring: 'hx-get="/HxSpikeRows/more?page=3"').
	html := self htmx: (ZnRequest get: '/HxSpikeRows/more?page=6').
	self assert: (html includesSubstring: '<td class="num">60</td>').
	self deny: (html includesSubstring: 'hx-get')
]

{ #category : 'tests - showcase' }
HxSpikeAppTest >> testInlineEditing [

	| html request |
	html := self htmx: (ZnRequest get: '/HxSpikeNote/edit').
	self assert: (html beginsWith: '<div id="note"').
	request := ZnRequest put: '/HxSpikeNote/save'.
	request entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'text' put: 'New text';
			 yourself).
	html := self htmx: request.
	self assert: (html beginsWith: '<div id="note"').
	self assert: (html includesSubstring: '<p>New text</p>').
	self assert: app showcase note equals: 'New text'
]

{ #category : 'tests - showcase' }
HxSpikeAppTest >> testPingFiresAnEvent [

	| response |
	response := app handleRequest: (ZnRequest post: '/HxSpikePings/ping').
	self assert: (response headers at: 'HX-Trigger') equals: 'pinged'.
	self assert: ((self htmx: (ZnRequest get: '/HxSpikePings/reload')) includesSubstring: 'Pings: 1')
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
HxSpikeAppTest >> testRoutesPage [

	| html |
	html := (app handleRequest: (ZnRequest get: '/routes')) contents.
	self assert: (html includesSubstring: '<title>Routes · PharoHtmx</title>').
	self assert: (html includesSubstring: '<a href="/cart"><code>/cart</code></a>').
	self assert: (html includesSubstring: '<code>/cart/&lt;id&gt;/increment</code>').
	self assert: (html includesSubstring: '<code>HxSpikeAddButton &gt;&gt; add:</code>').
	self assert: (html includesSubstring: 'Put a book in the cart; answer the new button').
	self deny: (html includesSubstring: 'HxComponent')
]

{ #category : 'tests' }
HxSpikeAppTest >> testSearchAnswersOnlyTheList [

	| html |
	html := self htmx: (ZnRequest get: '/HxSpikeBookList/search?q=go').
	self assert: (html beginsWith: '<ul id="book-list">').
	self assert: (html includesSubstring: 'Going Postal').
	self deny: (html includesSubstring: 'Mort')
]

{ #category : 'tests' }
HxSpikeAppTest >> testSearchPutsTheQueryInTheAddressBar [

	| request response |
	request := ZnRequest get: '/HxSpikeBookList/search?q=go'.
	request headers at: 'HX-Request' put: 'true'.
	response := app handleRequest: request.
	self assert: (response headers at: 'HX-Replace-Url') equals: '/books?q=go'.
	response := app handleRequest: (ZnRequest get: '/HxSpikeBookList/search?q=').
	self assert: (response headers at: 'HX-Replace-Url') equals: '/books'
]

{ #category : 'tests - showcase' }
HxSpikeAppTest >> testShowcasePage [

	| html |
	html := (app handleRequest: (ZnRequest get: '/showcase')) contents.
	self assert: (html includesSubstring: '<title>htmx showcase · PharoHtmx</title>').
	self assert: (html allRangesOfSubstring: '<section class="demo">') size equals: 6.
	self assert: (html includesSubstring: 'hx-trigger="load"').
	self assert: (html includesSubstring: 'HxSpikeClock class &gt;&gt; tick:')
]

{ #category : 'tests - showcase' }
HxSpikeAppTest >> testShowcaseShowsTheHtml [
	"Next to the Smalltalk, the showcase shows the HTML that the components write, escaped."

	| html |
	html := (app handleRequest: (ZnRequest get: '/showcase')) contents.
	self assert: (html allRangesOfSubstring: '<div class="code-grid">') size equals: 6.
	self assert: (html includesSubstring: '&lt;span class=&quot;clock&quot;').
	self assert: (html includesSubstring: 'hx-get=&quot;/HxSpikeClock/tick&quot;')
]

{ #category : 'tests' }
HxSpikeAppTest >> testUnknownBookIsNotFound [

	self assert: (app handleRequest: (ZnRequest post: '/cart/99')) isNotFound.
	self assert: (app handleRequest: (ZnRequest get: '/books/abc')) isNotFound
]
