Class {
	#name : 'HxRoutePatternTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Routing',
	#package : 'PharoHtmx-Tests',
	#tag : 'Routing'
}

{ #category : 'tests' }
HxRoutePatternTest >> testExtraValuesGoInTheQuery [

	| pattern |
	pattern := HxRoutePattern method: #GET pattern: '/books/<id>'.
	self assert: (pattern pathWith: { #id -> 3. #tab -> 'reviews'. #q -> 'a b' } asDictionary) equals: '/books/3?q=a%20b&tab=reviews'
]

{ #category : 'tests' }
HxRoutePatternTest >> testIgnoresTrailingSlash [

	| route |
	route := HxRoutePattern method: #GET pattern: '/books/'.
	self assert: (route match: (ZnRequest get: '/books')) isNotNil.
	self assert: (route match: (ZnRequest get: '/books/')) isNotNil
]

{ #category : 'tests' }
HxRoutePatternTest >> testMatchesLiteralPath [

	| route |
	route := HxRoutePattern method: #GET pattern: '/books'.
	self assert: (route matchSegments: #( 'books' )) isEmpty.
	self assert: (route matchSegments: #( 'authors' )) isNil.
	self assert: (route matchSegments: #( 'books' 'extra' )) isNil
]

{ #category : 'tests' }
HxRoutePatternTest >> testMatchesMethod [

	| route |
	route := HxRoutePattern method: #post pattern: '/cart'.
	self assert: route method equals: #POST.
	self assert: (route match: (ZnRequest post: '/cart')) isNotNil.
	self assert: (route match: (ZnRequest get: '/cart')) isNil
]

{ #category : 'tests' }
HxRoutePatternTest >> testMatchesParameters [

	| route parameters |
	route := HxRoutePattern method: #GET pattern: '/books/<id>/reviews/<review>'.
	parameters := route matchSegments: #( 'books' '42' 'reviews' '7' ).
	self assert: (parameters at: #id) equals: '42'.
	self assert: (parameters at: #review) equals: '7'.
	self assert: (route matchSegments: #( 'books' '42' 'comments' '7' )) isNil
]

{ #category : 'tests' }
HxRoutePatternTest >> testMatchesRoot [

	| route |
	route := HxRoutePattern method: #GET pattern: '/'.
	self assert: (route match: (ZnRequest get: '/')) isNotNil.
	self assert: (route match: (ZnRequest get: '/books')) isNil
]

{ #category : 'tests' }
HxRoutePatternTest >> testPathWith [

	| pattern |
	pattern := HxRoutePattern method: #GET pattern: '/books/<id>/reviews/<review>'.
	self assert: pattern parameterNames asArray equals: #( #id #review ).
	self assert: (pattern pathWith: (Dictionary new at: #id put: 42; at: #review put: 'a b'; yourself)) equals: '/books/42/reviews/a%20b'.
	self assert: ((HxRoutePattern method: #POST pattern: '/cart/<id>') pathWith: 7) equals: '/cart/7'.
	self assert: ((HxRoutePattern method: #GET pattern: '/') pathWith: Dictionary new) equals: '/'
]

{ #category : 'tests' }
HxRoutePatternTest >> testPrintOn [

	self assert: (HxRoutePattern method: #GET pattern: '/books/<id>') printString equals: 'GET /books/<id>'.
	self assert: (HxRoutePattern method: #GET pattern: '/') printString equals: 'GET /'
]
