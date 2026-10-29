Class {
	#name : 'GeoRequestTest',
	#superclass : 'TestCase',
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoRequestTest >> testAtFormField [

	| znRequest request |
	znRequest := ZnRequest post: '/cart'.
	znRequest entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'quantity' put: '3';
			 yourself).
	request := GeoRequest on: znRequest pathParameters: Dictionary new.
	self assert: (request at: #quantity) equals: '3'
]

{ #category : 'tests' }
GeoRequestTest >> testAtMissing [

	| request |
	request := GeoRequest on: (ZnRequest get: '/books') pathParameters: Dictionary new.
	self assert: (request at: #q ifAbsent: [ 'none' ]) equals: 'none'.
	self should: [ request at: #q ] raise: KeyNotFound
]

{ #category : 'tests' }
GeoRequestTest >> testAtPathParameter [

	| request |
	request := GeoRequest on: (ZnRequest get: '/books/42') pathParameters: { (#id -> '42') } asDictionary.
	self assert: (request at: #id) equals: '42'.
	self assert: (request at: 'id') equals: '42'
]

{ #category : 'tests' }
GeoRequestTest >> testAtQueryParameter [

	| request |
	request := GeoRequest on: (ZnRequest get: '/books?q=terry%20pratchett') pathParameters: Dictionary new.
	self assert: (request at: #q) equals: 'terry pratchett'
]

{ #category : 'tests' }
GeoRequestTest >> testIsHtmx [

	| znRequest |
	znRequest := ZnRequest get: '/books'.
	self deny: (GeoRequest on: znRequest pathParameters: Dictionary new) isHtmx.
	znRequest headers at: 'HX-Request' put: 'true'.
	self assert: (GeoRequest on: znRequest pathParameters: Dictionary new) isHtmx
]

{ #category : 'tests' }
GeoRequestTest >> testPathParameterWinsOverQuery [

	| request |
	request := GeoRequest on: (ZnRequest get: '/books/42?id=7') pathParameters: { (#id -> '42') } asDictionary.
	self assert: (request at: #id) equals: '42'
]
