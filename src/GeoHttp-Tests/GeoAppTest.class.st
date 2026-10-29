Class {
	#name : 'GeoAppTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'running' }
GeoAppTest >> setUp [

	super setUp.
	app := GeoTestApp new
]

{ #category : 'running' }
GeoAppTest >> tearDown [

	app stop.
	super tearDown
]

{ #category : 'tests' }
GeoAppTest >> testOnlyListedRoutesAnswer [
	"GeoTestBooksRoute is a route class too, but the app does not list it."

	self assert: app routes asArray equals: {
			GeoTestHelloRoute.
			GeoTestOldRoute }.
	self assert: (app handleRequest: (ZnRequest get: '/books')) isNotFound.
	self assert: GeoApp new routes isEmpty
]

{ #category : 'tests' }
GeoAppTest >> testOverHttp [

	| client |
	app startOn: 18731.
	client := ZnClient new.
	[
		self assert: (client get: 'http://localhost:18731/hello/world') equals: '<p>Hello world</p>'.
		client get: 'http://localhost:18731/nowhere'.
		self assert: client response isNotFound ] ensure: [ client close ]
]

{ #category : 'tests' }
GeoAppTest >> testResponsePassesThrough [

	| response |
	response := app handleRequest: (ZnRequest get: '/old').
	self assert: response isRedirect.
	self assert: response location equals: '/new'
]

{ #category : 'tests' }
GeoAppTest >> testRouteSummary [

	self assert: GeoTestBooksRoute summary equals: 'The book list.'
]

{ #category : 'tests' }
GeoAppTest >> testStringBecomesHtmlResponse [

	| response |
	response := app handleRequest: (ZnRequest get: '/hello/Georges').
	self assert: response isSuccess.
	self assert: response contentType equals: ZnMimeType textHtml.
	self assert: response contents equals: '<p>Hello Georges</p>'
]

{ #category : 'tests' }
GeoAppTest >> testUnknownPathIsNotFound [

	self assert: (app handleRequest: (ZnRequest get: '/nowhere')) isNotFound
]
