Class {
	#name : 'GeoEndpointTest',
	#superclass : 'TestCase',
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoEndpointTest >> testAllIn [
	"Ordered by path, then HTTP method."

	| endpoints |
	endpoints := GeoEndpoint allIn: GeoTestGreeter.
	self assert: (endpoints collect: [ :each | each routePattern printString ]) asArray equals: #( 'GET /GeoTestGreeter/wave' 'POST /greet' 'GET /greet/<name>' )
]

{ #category : 'tests' }
GeoEndpointTest >> testClearErrors [
	"A selector without its colon, an unknown selector and a method without an endpoint pragma each say what is wrong."

	| messageOf |
	messageOf := [ :selector | [ GeoEndpoint in: GeoTestGreeter selector: selector. nil ] on: Error do: [ :error | error messageText ] ].
	self assert: ((messageOf value: #wave) includesSubstring: 'write #wave: with the colon').
	self assert: ((messageOf value: #wav:) includesSubstring: 'GeoTestGreeter has no endpoint #wav:').
	self assert: ((messageOf value: #notAnEndpoint) includesSubstring: 'is not an endpoint')
]

{ #category : 'tests' }
GeoEndpointTest >> testDescription [

	| endpoint |
	endpoint := GeoEndpoint in: GeoTestGreeter selector: #hello:.
	self assert: endpoint httpMethod equals: #GET.
	self assert: endpoint pattern equals: '/greet/<name>'.
	self assert: endpoint name equals: 'GeoTestGreeter >> hello:'.
	self assert: endpoint summary equals: 'Greet someone by name.'.
	self assert: (endpoint pathWith: 'Ann') equals: '/greet/Ann'
]

{ #category : 'tests' }
GeoEndpointTest >> testDispatch [
	"The router passes the request, which knows the app, to the endpoint method."

	| router app |
	router := GeoRouter routes: (GeoEndpoint allIn: GeoTestGreeter).
	app := GeoTestApp new.
	self assert: (router dispatch: (ZnRequest get: '/greet/Ann') for: app) equals: '<p>Hello Ann</p>'.
	self assert: (router dispatch: (ZnRequest post: '/greet') for: app) equals: #GeoTestApp.
	self assert: (router dispatch: (ZnRequest get: '/greet') for: app) isNil
]

{ #category : 'tests' }
GeoEndpointTest >> testGeneratedPath [

	| endpoint router |
	endpoint := GeoEndpoint in: GeoTestGreeter selector: #wave:.
	self assert: endpoint httpMethod equals: #GET.
	self assert: endpoint pattern equals: '/GeoTestGreeter/wave'.
	router := GeoRouter routes: (GeoEndpoint allIn: GeoTestGreeter).
	self assert: (router dispatch: (ZnRequest get: '/GeoTestGreeter/wave') for: GeoTestApp new) equals: '<p>Hi</p>'
]

{ #category : 'tests' }
GeoEndpointTest >> testRouteClassIsItsOwnEndpoint [

	self assert: GeoTestBooksRoute endpoints equals: { GeoTestBooksRoute }
]
