Class {
	#name : 'GeoRouterTest',
	#superclass : 'TestCase',
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoRouterTest >> testDispatchToMatchingRoute [

	| router |
	router := GeoRouter routes: {
			          GeoTestBooksRoute.
			          GeoTestBookRoute.
			          GeoTestUpdateBookRoute }.
	self assert: (router dispatch: (ZnRequest get: '/books') for: nil) equals: 'list'.
	self assert: (router dispatch: (ZnRequest get: '/books/42') for: nil) equals: 'book 42'.
	self assert: (router dispatch: (ZnRequest post: '/books/42') for: nil) equals: 'updated 42'
]

{ #category : 'tests' }
GeoRouterTest >> testDispatchWithoutMatch [

	| router |
	router := GeoRouter routes: { GeoTestBooksRoute }.
	self assert: (router dispatch: (ZnRequest get: '/authors') for: nil) isNil.
	self assert: (router dispatch: (ZnRequest delete: '/books') for: nil) isNil
]

{ #category : 'tests' }
GeoRouterTest >> testMostSpecificRouteWins [
	"A literal segment beats a parameter, whatever the order of the routes."

	#( #( GeoTestNewBookRoute GeoTestBookRoute ) #( GeoTestBookRoute GeoTestNewBookRoute ) ) do: [ :names |
			| router |
			router := GeoRouter routes: (names collect: [ :each | self class environment at: each ]).
			self assert: (router dispatch: (ZnRequest get: '/books/new') for: nil) equals: 'form'.
			self assert: (router dispatch: (ZnRequest get: '/books/1') for: nil) equals: 'book 1' ]
]

{ #category : 'tests' }
GeoRouterTest >> testRouteClassBuildsItsPath [

	self assert: GeoTestBooksRoute path equals: '/books'.
	self assert: (GeoTestBookRoute pathWith: 42) equals: '/books/42'
]

{ #category : 'tests' }
GeoRouterTest >> testRouteKnowsAppAndRequest [

	| app match route |
	app := GeoTestApp new.
	match := app router match: (ZnRequest get: '/hello/world').
	self assert: match key equals: GeoTestHelloRoute.
	route := match key new setApp: app request: match value.
	self assert: route app identicalTo: app.
	self assert: (route at: #name) equals: 'world'
]
