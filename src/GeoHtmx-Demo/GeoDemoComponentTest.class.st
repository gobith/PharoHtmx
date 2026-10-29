"
I test the demo app's components on their own, without requests.
"
Class {
	#name : 'GeoDemoComponentTest',
	#superclass : 'TestCase',
	#category : 'GeoHtmx-Demo-Tests',
	#package : 'GeoHtmx-Demo',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoDemoComponentTest >> book: anInteger [

	^ GeoDemoApp new catalog detect: [ :each | each id = anInteger ]
]

{ #category : 'tests' }
GeoDemoComponentTest >> testActionTakesTheMethodFromTheEndpoint [

	| html |
	html := (GeoDemoNote text: 'Hi') beEditing; toHtml.
	self assert: (html includesSubstring: '<form class="note-form" hx-put="/GeoDemoNote/save">').
	self assert: (html includesSubstring: '<div id="note" class="box note" hx-target="this" hx-swap="outerHTML">').
	html := (GeoDemoTodoItem todo: (GeoDemoTodo id: 7 text: 'x')) toHtml.
	self assert: (html includesSubstring: 'hx-delete="/showcase/todos/7" hx-confirm="Delete this item?" hx-target="closest li" hx-swap="outerHTML"')
]

{ #category : 'tests' }
GeoDemoComponentTest >> testAddButtonStates [

	self assert: ((GeoDemoAddButton book: (self book: 1)) toHtml includesSubstring: '>Add to cart</button>').
	self assert: ((GeoDemoAddButton book: (self book: 2)) toHtml includesSubstring: 'Sold out').
	self assert: ((GeoDemoAddButton book: (self book: 1) quantity: 3) toHtml includesSubstring: '✓ In cart (3)')
]

{ #category : 'tests' }
GeoDemoComponentTest >> testCartLink [

	| cart |
	cart := GeoDemoCart new.
	cart add: (self book: 1).
	self assert: (GeoDemoCartLink cart: cart) toHtml equals: '<a id="cart-link" href="/cart">Cart (1)</a>'
]

{ #category : 'tests' }
GeoDemoComponentTest >> testChildrenWriteIntoTheSameHtml [

	| html |
	html := (GeoDemoBookList books: {
			         (self book: 1).
			         (self book: 2) }) toHtml.
	self assert: (html beginsWith: '<ul id="book-list">').
	self assert: (html allRangesOfSubstring: '<li id="book-') size equals: 2.
	self assert: (html includesSubstring: 'Add to cart').
	self assert: (html includesSubstring: 'Sold out').
	self assert: (html trimRight endsWith: '</ul>')
]

{ #category : 'tests' }
GeoDemoComponentTest >> testComponentInDoubleBraces [
	"{{ aComponent }} renders the component into the same HTML, unescaped."

	| writer |
	writer := GeoHtmlWriter new.
	writer text: (GeoDemoCartLink cart: GeoDemoCart new).
	self assert: writer contents equals: '<a id="cart-link" href="/cart">Cart (0)</a>'
]

{ #category : 'tests' }
GeoDemoComponentTest >> testEndpointPaths [

	self assert: (GeoDemoClock pathOf: #tick:) equals: '/GeoDemoClock/tick'.
	self assert: (GeoDemoClock pathOf: #tick:) equals: '/GeoDemoClock/tick'.
	self assert: (GeoDemoTodoItem pathOf: #delete: with: 7) equals: '/showcase/todos/7'.
	self assert: ((GeoDemoNote text: 'x') path: #edit:) equals: '/GeoDemoNote/edit'.
	self assert: (GeoDemoCartTable endpoints collect: [ :each | each selector ]) asArray equals: #( #decrement: #increment: #remove: #clear: )
]

{ #category : 'tests' }
GeoDemoComponentTest >> testHtmxScript [

	self assert: GeoHtmxScript new toHtml equals: '<script src="https://unpkg.com/htmx.org@' , GeoHtmxScript defaultVersion , '"></script>'.
	self assert: ((GeoHtmxScript version: '2.0.0') toHtml includesSubstring: 'htmx.org@2.0.0"')
]

{ #category : 'tests' }
GeoDemoComponentTest >> testNoteStates [

	| html |
	html := (GeoDemoNote text: 'Hi') toHtml.
	self assert: (html includesSubstring: '<p>Hi</p>').
	self assert: (html includesSubstring: 'hx-get="/GeoDemoNote/edit"').
	html := (GeoDemoNote text: 'Hi') beEditing; toHtml.
	self assert: (html includesSubstring: 'hx-put="/GeoDemoNote/save"').
	self assert: (html includesSubstring: 'value="Hi"').
	self assert: (html includesSubstring: 'hx-target="this" hx-swap="outerHTML"')
]

{ #category : 'tests' }
GeoDemoComponentTest >> testPageIsItsOwnEndpoint [

	self assert: GeoDemoBooksPage endpoints equals: { GeoDemoBooksPage }
]

{ #category : 'tests' }
GeoDemoComponentTest >> testUrlsComeFromTheRoutes [

	| html |
	html := (GeoDemoBookRow book: (self book: 3)) toHtml.
	self assert: (html includesSubstring: 'href="/books/3"').
	self assert: (html includesSubstring: 'hx-get="/books/3" hx-target="#detail"').
	self assert: (html includesSubstring: 'hx-post="/cart/3" hx-swap="outerHTML"')
]
