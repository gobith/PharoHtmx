Class {
	#name : 'HxRequestTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Routing',
	#package : 'PharoHtmx-Tests',
	#tag : 'Routing'
}

{ #category : 'tests' }
HxRequestTest >> testAtFormField [

	| znRequest request |
	znRequest := ZnRequest post: '/cart'.
	znRequest entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'quantity' put: '3';
			 yourself).
	request := HxRequest on: znRequest pathParameters: Dictionary new.
	self assert: (request at: #quantity) equals: '3'
]

{ #category : 'tests' }
HxRequestTest >> testAtMissing [

	| request |
	request := HxRequest on: (ZnRequest get: '/books') pathParameters: Dictionary new.
	self assert: (request at: #q ifAbsent: [ 'none' ]) equals: 'none'.
	self should: [ request at: #q ] raise: KeyNotFound
]

{ #category : 'tests' }
HxRequestTest >> testAtPathParameter [

	| request |
	request := HxRequest on: (ZnRequest get: '/books/42') pathParameters: { (#id -> '42') } asDictionary.
	self assert: (request at: #id) equals: '42'.
	self assert: (request at: 'id') equals: '42'
]

{ #category : 'tests' }
HxRequestTest >> testAtQueryParameter [

	| request |
	request := HxRequest on: (ZnRequest get: '/books?q=terry%20pratchett') pathParameters: Dictionary new.
	self assert: (request at: #q) equals: 'terry pratchett'
]

{ #category : 'tests' }
HxRequestTest >> testIsHtmx [

	| znRequest |
	znRequest := ZnRequest get: '/books'.
	self deny: (HxRequest on: znRequest pathParameters: Dictionary new) isHtmx.
	znRequest headers at: 'HX-Request' put: 'true'.
	self assert: (HxRequest on: znRequest pathParameters: Dictionary new) isHtmx
]

{ #category : 'tests' }
HxRequestTest >> testPathParameterWinsOverQuery [

	| request |
	request := HxRequest on: (ZnRequest get: '/books/42?id=7') pathParameters: { (#id -> '42') } asDictionary.
	self assert: (request at: #id) equals: '42'
]
