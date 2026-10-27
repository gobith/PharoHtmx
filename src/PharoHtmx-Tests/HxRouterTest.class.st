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
	router := HxRouter new.
	router get: '/books' do: [ :req | 'list' ].
	router get: '/books/<id>' do: [ :req | 'book ' , (req at: #id) ].
	router post: '/books/<id>' do: [ :req | 'updated ' , (req at: #id) ].
	self assert: (router dispatch: (ZnRequest get: '/books')) equals: 'list'.
	self assert: (router dispatch: (ZnRequest get: '/books/42')) equals: 'book 42'.
	self assert: (router dispatch: (ZnRequest post: '/books/42')) equals: 'updated 42'
]

{ #category : 'tests' }
HxRouterTest >> testDispatchWithoutMatch [

	| router |
	router := HxRouter new.
	router get: '/books' do: [ :req | 'list' ].
	self assert: (router dispatch: (ZnRequest get: '/authors')) isNil.
	self assert: (router dispatch: (ZnRequest delete: '/books')) isNil
]

{ #category : 'tests' }
HxRouterTest >> testFirstMatchingRouteWins [

	| router |
	router := HxRouter new.
	router get: '/books/new' do: [ :req | 'form' ].
	router get: '/books/<id>' do: [ :req | 'book' ].
	self assert: (router dispatch: (ZnRequest get: '/books/new')) equals: 'form'.
	self assert: (router dispatch: (ZnRequest get: '/books/1')) equals: 'book'
]
