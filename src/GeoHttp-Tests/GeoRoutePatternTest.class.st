Class {
	#name : 'GeoRoutePatternTest',
	#superclass : 'TestCase',
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoRoutePatternTest >> testExtraValuesGoInTheQuery [

	| pattern |
	pattern := GeoRoutePattern method: #GET pattern: '/books/<id>'.
	self assert: (pattern pathWith: { #id -> 3. #tab -> 'reviews'. #q -> 'a b' } asDictionary) equals: '/books/3?q=a%20b&tab=reviews'
]

{ #category : 'tests' }
GeoRoutePatternTest >> testIgnoresTrailingSlash [

	| route |
	route := GeoRoutePattern method: #GET pattern: '/books/'.
	self assert: (route match: (ZnRequest get: '/books')) isNotNil.
	self assert: (route match: (ZnRequest get: '/books/')) isNotNil
]

{ #category : 'tests' }
GeoRoutePatternTest >> testMatchesLiteralPath [

	| route |
	route := GeoRoutePattern method: #GET pattern: '/books'.
	self assert: (route matchSegments: #( 'books' )) isEmpty.
	self assert: (route matchSegments: #( 'authors' )) isNil.
	self assert: (route matchSegments: #( 'books' 'extra' )) isNil
]

{ #category : 'tests' }
GeoRoutePatternTest >> testMatchesMethod [

	| route |
	route := GeoRoutePattern method: #post pattern: '/cart'.
	self assert: route method equals: #POST.
	self assert: (route match: (ZnRequest post: '/cart')) isNotNil.
	self assert: (route match: (ZnRequest get: '/cart')) isNil
]

{ #category : 'tests' }
GeoRoutePatternTest >> testMatchesParameters [

	| route parameters |
	route := GeoRoutePattern method: #GET pattern: '/books/<id>/reviews/<review>'.
	parameters := route matchSegments: #( 'books' '42' 'reviews' '7' ).
	self assert: (parameters at: #id) equals: '42'.
	self assert: (parameters at: #review) equals: '7'.
	self assert: (route matchSegments: #( 'books' '42' 'comments' '7' )) isNil
]

{ #category : 'tests' }
GeoRoutePatternTest >> testMatchesRoot [

	| route |
	route := GeoRoutePattern method: #GET pattern: '/'.
	self assert: (route match: (ZnRequest get: '/')) isNotNil.
	self assert: (route match: (ZnRequest get: '/books')) isNil
]

{ #category : 'tests' }
GeoRoutePatternTest >> testPathWith [

	| pattern |
	pattern := GeoRoutePattern method: #GET pattern: '/books/<id>/reviews/<review>'.
	self assert: pattern parameterNames asArray equals: #( #id #review ).
	self assert: (pattern pathWith: (Dictionary new at: #id put: 42; at: #review put: 'a b'; yourself)) equals: '/books/42/reviews/a%20b'.
	self assert: ((GeoRoutePattern method: #POST pattern: '/cart/<id>') pathWith: 7) equals: '/cart/7'.
	self assert: ((GeoRoutePattern method: #GET pattern: '/') pathWith: Dictionary new) equals: '/'
]

{ #category : 'tests' }
GeoRoutePatternTest >> testPrintOn [

	self assert: (GeoRoutePattern method: #GET pattern: '/books/<id>') printString equals: 'GET /books/<id>'.
	self assert: (GeoRoutePattern method: #GET pattern: '/') printString equals: 'GET /'
]
