Class {
	#name : 'HxHtmxRequestTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Htmx',
	#package : 'PharoHtmx-Tests',
	#tag : 'Htmx'
}

{ #category : 'tests' }
HxHtmxRequestTest >> testHeaders [

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
	htmx := (HxRequest on: zn pathParameters: Dictionary new) htmx.
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
HxHtmxRequestTest >> testPlainRequest [

	| htmx |
	htmx := (HxRequest on: (ZnRequest get: '/books') pathParameters: Dictionary new) htmx.
	self deny: htmx isHtmx.
	self assert: htmx target isNil
]
