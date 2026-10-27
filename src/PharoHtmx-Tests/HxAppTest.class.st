Class {
	#name : 'HxAppTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'PharoHtmx-Tests-Core',
	#package : 'PharoHtmx-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
HxAppTest >> setUp [

	super setUp.
	app := HxApp new.
	app router
		get: '/hello/<name>' do: [ :req | '<p>Hallo ' , (req at: #name) , '</p>' ];
		get: '/old' do: [ :req | ZnResponse redirect: '/new' ]
]

{ #category : 'running' }
HxAppTest >> tearDown [

	app stop.
	super tearDown
]

{ #category : 'tests' }
HxAppTest >> testOverHttp [

	| client |
	app startOn: 18731.
	client := ZnClient new.
	[
		self assert: (client get: 'http://localhost:18731/hello/wereld') equals: '<p>Hallo wereld</p>'.
		client get: 'http://localhost:18731/nowhere'.
		self assert: client response isNotFound ] ensure: [ client close ]
]

{ #category : 'tests' }
HxAppTest >> testResponsePassesThrough [

	| response |
	response := app handleRequest: (ZnRequest get: '/old').
	self assert: response isRedirect.
	self assert: response location equals: '/new'
]

{ #category : 'tests' }
HxAppTest >> testStringBecomesHtmlResponse [

	| response |
	response := app handleRequest: (ZnRequest get: '/hello/Georges').
	self assert: response isSuccess.
	self assert: response contentType equals: ZnMimeType textHtml.
	self assert: response contents equals: '<p>Hallo Georges</p>'
]

{ #category : 'tests' }
HxAppTest >> testUnknownPathIsNotFound [

	self assert: (app handleRequest: (ZnRequest get: '/nowhere')) isNotFound
]
