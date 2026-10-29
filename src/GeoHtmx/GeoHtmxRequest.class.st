"
I answer what htmx tells about a request in its request headers: whether htmx sent it at all, which element triggered it, which element it will swap, and so on. Get me from a route or page with ""request htmx"".

	request htmx isHtmx    ""true for every request htmx makes""
	request htmx target    ""the id of the target element, as in 'book-list'""

All answers are nil when the header is absent.
"
Class {
	#name : 'GeoHtmxRequest',
	#superclass : 'Object',
	#instVars : [
		'znRequest'
	],
	#category : 'GeoHtmx-Htmx',
	#package : 'GeoHtmx',
	#tag : 'Htmx'
}

{ #category : 'instance creation' }
GeoHtmxRequest class >> on: aZnRequest [

	^ self new setZnRequest: aZnRequest
]

{ #category : 'accessing' }
GeoHtmxRequest >> currentUrl [
	"The URL in the browser's address bar."

	^ self headerAt: 'HX-Current-URL'
]

{ #category : 'private' }
GeoHtmxRequest >> headerAt: aName [

	^ znRequest headers at: aName ifAbsent: [ nil ]
]

{ #category : 'testing' }
GeoHtmxRequest >> isBoosted [
	"Did a link or form under hx-boost send the request?"

	^ (self headerAt: 'HX-Boosted') = 'true'
]

{ #category : 'testing' }
GeoHtmxRequest >> isHistoryRestore [
	"Does htmx ask for a whole page because the page was not in its history cache?"

	^ (self headerAt: 'HX-History-Restore-Request') = 'true'
]

{ #category : 'testing' }
GeoHtmxRequest >> isHtmx [
	"Did htmx send the request? It sends HX-Request: true with every request."

	^ (self headerAt: 'HX-Request') = 'true'
]

{ #category : 'accessing' }
GeoHtmxRequest >> prompt [
	"What the visitor typed in the prompt of hx-prompt."

	^ self headerAt: 'HX-Prompt'
]

{ #category : 'initialization' }
GeoHtmxRequest >> setZnRequest: aZnRequest [

	znRequest := aZnRequest
]

{ #category : 'accessing' }
GeoHtmxRequest >> target [
	"The id of the element htmx will swap the answer into."

	^ self headerAt: 'HX-Target'
]

{ #category : 'accessing' }
GeoHtmxRequest >> trigger [
	"The id of the element that triggered the request."

	^ self headerAt: 'HX-Trigger'
]

{ #category : 'accessing' }
GeoHtmxRequest >> triggerName [
	"The name of the element that triggered the request, such as a form field."

	^ self headerAt: 'HX-Trigger-Name'
]
