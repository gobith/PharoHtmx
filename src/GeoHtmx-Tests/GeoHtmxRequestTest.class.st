Class {
	#name : 'GeoHtmxRequestTest',
	#superclass : 'TestCase',
	#category : 'GeoHtmx-Tests-Tests',
	#package : 'GeoHtmx-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoHtmxRequestTest >> testHeaders [

	| zn htmx |
	zn := ZnRequest get: '/books'.
	zn headers
		at: 'HX-Request' put: 'true';
		at: 'HX-Boosted' put: 'true';
		at: 'HX-Target' put: 'book-list';
		at: 'HX-Trigger' put: 'search';
		at: 'HX-Trigger-Name' put: 'q';
		at: 'HX-Current-URL' put: 'http://localhost/books';
		at: 'HX-Prompt' put: 'yes'.
	htmx := (GeoRequest on: zn pathParameters: Dictionary new) htmx.
	self assert: htmx isHtmx.
	self assert: htmx isBoosted.
	self deny: htmx isHistoryRestore.
	self assert: htmx target equals: 'book-list'.
	self assert: htmx trigger equals: 'search'.
	self assert: htmx triggerName equals: 'q'.
	self assert: htmx currentUrl equals: 'http://localhost/books'.
	self assert: htmx prompt equals: 'yes'
]

{ #category : 'tests' }
GeoHtmxRequestTest >> testPlainRequest [

	| htmx |
	htmx := (GeoRequest on: (ZnRequest get: '/books') pathParameters: Dictionary new) htmx.
	self deny: htmx isHtmx.
	self assert: htmx target isNil
]
