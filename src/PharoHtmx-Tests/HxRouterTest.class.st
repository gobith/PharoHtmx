Class {
	#name : 'HxRouterTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Routing',
	#package : 'PharoHtmx-Tests',
	#tag : 'Routing'
}

{ #category : 'tests' }
HxRouterTest >> testDispatchToMatchingRoute [

	| router |
	router := HxRouter routes: {
			          HxTestBooksRoute.
			          HxTestBookRoute.
			          HxTestUpdateBookRoute }.
	self assert: (router dispatch: (ZnRequest get: '/books') for: nil) equals: 'list'.
	self assert: (router dispatch: (ZnRequest get: '/books/42') for: nil) equals: 'book 42'.
	self assert: (router dispatch: (ZnRequest post: '/books/42') for: nil) equals: 'updated 42'
]

{ #category : 'tests' }
HxRouterTest >> testDispatchWithoutMatch [

	| router |
	router := HxRouter routes: { HxTestBooksRoute }.
	self assert: (router dispatch: (ZnRequest get: '/authors') for: nil) isNil.
	self assert: (router dispatch: (ZnRequest delete: '/books') for: nil) isNil
]

{ #category : 'tests' }
HxRouterTest >> testMostSpecificRouteWins [
	"A literal segment beats a parameter, whatever the order of the routes."

	#( #( HxTestNewBookRoute HxTestBookRoute ) #( HxTestBookRoute HxTestNewBookRoute ) ) do: [ :names |
			| router |
			router := HxRouter routes: (names collect: [ :each | self class environment at: each ]).
			self assert: (router dispatch: (ZnRequest get: '/books/new') for: nil) equals: 'form'.
			self assert: (router dispatch: (ZnRequest get: '/books/1') for: nil) equals: 'book 1' ]
]

{ #category : 'tests' }
HxRouterTest >> testRouteClassBuildsItsPath [

	self assert: HxTestBooksRoute path equals: '/books'.
	self assert: (HxTestBookRoute pathWith: 42) equals: '/books/42'
]

{ #category : 'tests' }
HxRouterTest >> testRouteKnowsAppAndRequest [

	| app match route |
	app := HxTestApp new.
	match := app router match: (ZnRequest get: '/hello/world').
	self assert: match key equals: HxTestHelloRoute.
	route := match key new setApp: app request: match value.
	self assert: route app identicalTo: app.
	self assert: (route at: #name) equals: 'world'
]
