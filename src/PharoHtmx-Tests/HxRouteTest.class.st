Class {
	#name : 'HxRouteTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Routing',
	#package : 'PharoHtmx-Tests',
	#tag : 'Routing'
}

{ #category : 'tests' }
HxRouteTest >> testIgnoresTrailingSlash [

	| route |
	route := HxRoute method: #GET pattern: '/books/' block: [ :req | nil ].
	self assert: (route match: (ZnRequest get: '/books')) isNotNil.
	self assert: (route match: (ZnRequest get: '/books/')) isNotNil
]

{ #category : 'tests' }
HxRouteTest >> testMatchesLiteralPath [

	| route |
	route := HxRoute method: #GET pattern: '/books' block: [ :req | nil ].
	self assert: (route matchSegments: #( 'books' )) isEmpty.
	self assert: (route matchSegments: #( 'authors' )) isNil.
	self assert: (route matchSegments: #( 'books' 'extra' )) isNil
]

{ #category : 'tests' }
HxRouteTest >> testMatchesMethod [

	| route |
	route := HxRoute method: #post pattern: '/cart' block: [ :req | nil ].
	self assert: route method equals: #POST.
	self assert: (route match: (ZnRequest post: '/cart')) isNotNil.
	self assert: (route match: (ZnRequest get: '/cart')) isNil
]

{ #category : 'tests' }
HxRouteTest >> testMatchesParameters [

	| route parameters |
	route := HxRoute method: #GET pattern: '/books/<id>/reviews/<review>' block: [ :req | nil ].
	parameters := route matchSegments: #( 'books' '42' 'reviews' '7' ).
	self assert: (parameters at: #id) equals: '42'.
	self assert: (parameters at: #review) equals: '7'.
	self assert: (route matchSegments: #( 'books' '42' 'comments' '7' )) isNil
]

{ #category : 'tests' }
HxRouteTest >> testMatchesRoot [

	| route |
	route := HxRoute method: #GET pattern: '/' block: [ :req | nil ].
	self assert: (route match: (ZnRequest get: '/')) isNotNil.
	self assert: (route match: (ZnRequest get: '/books')) isNil
]

{ #category : 'tests' }
HxRouteTest >> testPrintOn [

	self assert: (HxRoute method: #GET pattern: '/books/<id>' block: [ :req | nil ]) printString equals: 'GET /books/<id>'.
	self assert: (HxRoute method: #GET pattern: '/' block: [ :req | nil ]) printString equals: 'GET /'
]
