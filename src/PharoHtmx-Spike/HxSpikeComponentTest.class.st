"
I test the demo app's components on their own, without requests.
"
Class {
	#name : 'HxSpikeComponentTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'tests' }
HxSpikeComponentTest >> book: anInteger [

	^ HxSpikeApp new catalog detect: [ :each | each id = anInteger ]
]

{ #category : 'tests' }
HxSpikeComponentTest >> testAddButtonStates [

	self assert: ((HxSpikeAddButton book: (self book: 1)) toHtml includesSubstring: '>Add to cart</button>').
	self assert: ((HxSpikeAddButton book: (self book: 2)) toHtml includesSubstring: 'Sold out').
	self assert: ((HxSpikeAddButton book: (self book: 1) quantity: 3) toHtml includesSubstring: '✓ In cart (3)')
]

{ #category : 'tests' }
HxSpikeComponentTest >> testCartLink [

	| cart |
	cart := HxSpikeCart new.
	cart add: (self book: 1).
	self assert: (HxSpikeCartLink cart: cart) toHtml equals: '<a id="cart-link" href="/cart">Cart (1)</a>'
]

{ #category : 'tests' }
HxSpikeComponentTest >> testChildrenWriteIntoTheSameHtml [

	| html |
	html := (HxSpikeBookList books: {
			         (self book: 1).
			         (self book: 2) }) toHtml.
	self assert: (html beginsWith: '<ul id="book-list">').
	self assert: (html allRangesOfSubstring: '<li>') size equals: 2.
	self assert: (html includesSubstring: 'Add to cart').
	self assert: (html includesSubstring: 'Sold out').
	self assert: (html trimRight endsWith: '</ul>')
]

{ #category : 'tests' }
HxSpikeComponentTest >> testEndpointPaths [

	self assert: (HxSpikeClock pathOf: #tick) equals: '/HxSpikeClock/tick'.
	self assert: (HxSpikeClock pathOf: #tick:) equals: '/HxSpikeClock/tick'.
	self assert: (HxSpikeTodoItem pathOf: #delete with: 7) equals: '/showcase/todos/7'.
	self assert: ((HxSpikeNote text: 'x') path: #edit) equals: '/HxSpikeNote/edit'.
	self assert: (HxSpikeCartTable endpoints collect: [ :each | each selector ]) asArray equals: #( #decrement: #increment: #remove: #clear: )
]

{ #category : 'tests' }
HxSpikeComponentTest >> testHtmxScript [

	self assert: HxHtmxScript new toHtml equals: '<script src="https://unpkg.com/htmx.org@' , HxHtmxScript defaultVersion , '"></script>'.
	self assert: ((HxHtmxScript version: '2.0.0') toHtml includesSubstring: 'htmx.org@2.0.0"')
]

{ #category : 'tests' }
HxSpikeComponentTest >> testNoteStates [

	| html |
	html := (HxSpikeNote text: 'Hi') toHtml.
	self assert: (html includesSubstring: '<p>Hi</p>').
	self assert: (html includesSubstring: 'hx-get="/HxSpikeNote/edit"').
	html := (HxSpikeNote text: 'Hi') beEditing; toHtml.
	self assert: (html includesSubstring: 'hx-put="/HxSpikeNote/save"').
	self assert: (html includesSubstring: 'value="Hi"').
	self assert: (html includesSubstring: 'hx-target="this" hx-swap="outerHTML"')
]

{ #category : 'tests' }
HxSpikeComponentTest >> testPageIsItsOwnEndpoint [

	self assert: HxSpikeBooksPage endpoints equals: { HxSpikeBooksPage }
]

{ #category : 'tests' }
HxSpikeComponentTest >> testUrlsComeFromTheRoutes [

	| html |
	html := (HxSpikeBookRow book: (self book: 3)) toHtml.
	self assert: (html includesSubstring: 'href="/books/3" hx-get="/books/3"').
	self assert: (html includesSubstring: 'hx-post="/cart/3"')
]
