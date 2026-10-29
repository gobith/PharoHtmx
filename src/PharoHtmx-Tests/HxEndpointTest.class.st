Class {
	#name : 'HxEndpointTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Routing',
	#package : 'PharoHtmx-Tests',
	#tag : 'Routing'
}

{ #category : 'tests' }
HxEndpointTest >> testAllIn [
	"Ordered by path, then HTTP method."

	| endpoints |
	endpoints := HxEndpoint allIn: HxTestGreeter.
	self assert: (endpoints collect: [ :each | each routePattern printString ]) asArray equals: #( 'GET /HxTestGreeter/wave' 'POST /greet' 'GET /greet/<name>' )
]

{ #category : 'tests' }
HxEndpointTest >> testClearErrors [
	"A selector without its colon, an unknown selector and a method without an endpoint pragma each say what is wrong."

	| messageOf |
	messageOf := [ :selector | [ HxEndpoint in: HxTestGreeter selector: selector. nil ] on: Error do: [ :error | error messageText ] ].
	self assert: ((messageOf value: #wave) includesSubstring: 'write #wave: with the colon').
	self assert: ((messageOf value: #wav:) includesSubstring: 'HxTestGreeter has no endpoint #wav:').
	self assert: ((messageOf value: #notAnEndpoint) includesSubstring: 'is not an endpoint')
]

{ #category : 'tests' }
HxEndpointTest >> testDescription [

	| endpoint |
	endpoint := HxEndpoint in: HxTestGreeter selector: #hello:.
	self assert: endpoint httpMethod equals: #GET.
	self assert: endpoint pattern equals: '/greet/<name>'.
	self assert: endpoint name equals: 'HxTestGreeter >> hello:'.
	self assert: endpoint summary equals: 'Greet someone by name.'.
	self assert: (endpoint pathWith: 'Ann') equals: '/greet/Ann'
]

{ #category : 'tests' }
HxEndpointTest >> testDispatch [
	"The router passes the request, which knows the app, to the endpoint method."

	| router app |
	router := HxRouter routes: (HxEndpoint allIn: HxTestGreeter).
	app := HxTestApp new.
	self assert: (router dispatch: (ZnRequest get: '/greet/Ann') for: app) equals: '<p>Hello Ann</p>'.
	self assert: (router dispatch: (ZnRequest post: '/greet') for: app) equals: #HxTestApp.
	self assert: (router dispatch: (ZnRequest get: '/greet') for: app) isNil
]

{ #category : 'tests' }
HxEndpointTest >> testGeneratedPath [

	| endpoint router |
	endpoint := HxEndpoint in: HxTestGreeter selector: #wave:.
	self assert: endpoint httpMethod equals: #GET.
	self assert: endpoint pattern equals: '/HxTestGreeter/wave'.
	router := HxRouter routes: (HxEndpoint allIn: HxTestGreeter).
	self assert: (router dispatch: (ZnRequest get: '/HxTestGreeter/wave') for: HxTestApp new) equals: '<p>Hi</p>'
]

{ #category : 'tests' }
HxEndpointTest >> testRouteClassIsItsOwnEndpoint [

	self assert: HxTestBooksRoute endpoints equals: { HxTestBooksRoute }
]
