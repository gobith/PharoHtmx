"
I wrap a ZnRequest together with the path parameters of the route that matched it.

#at: looks a name up in the path parameters, then the query, then the form fields of a POST. #isHtmx tells whether htmx sent the request, so a handler can answer a fragment instead of a full page.
"
Class {
	#name : 'HxRequest',
	#superclass : 'Object',
	#instVars : [
		'znRequest',
		'pathParameters',
		'app'
	],
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
HxRequest class >> on: aZnRequest pathParameters: aDictionary [

	^ self new setZnRequest: aZnRequest pathParameters: aDictionary
]

{ #category : 'accessing' }
HxRequest >> app [
	"The app that handles me."

	^ app
]

{ #category : 'initialization' }
HxRequest >> app: anApp [

	app := anApp
]

{ #category : 'accessing' }
HxRequest >> at: aName [

	^ self at: aName ifAbsent: [ KeyNotFound signalFor: aName ]
]

{ #category : 'accessing' }
HxRequest >> at: aName ifAbsent: aBlock [
	"Look aName up in the path parameters, then the query, then the form fields."

	| entity |
	pathParameters at: aName asSymbol ifPresent: [ :value | ^ value ].
	(znRequest url queryAt: aName asString ifAbsent: [ nil ]) ifNotNil: [ :value | ^ value ].
	entity := znRequest entity.
	(entity isKindOf: ZnApplicationFormUrlEncodedEntity) ifTrue: [ ^ entity at: aName asString ifAbsent: aBlock ].
	^ aBlock value
]

{ #category : 'accessing' }
HxRequest >> headerAt: aName [
	"Answer the value of the header aName, nil when it is absent."

	^ znRequest headers at: aName ifAbsent: [ nil ]
]

{ #category : 'accessing' }
HxRequest >> htmx [
	"What htmx tells about this request; see HxHtmxRequest."

	^ HxHtmxRequest on: znRequest
]

{ #category : 'testing' }
HxRequest >> isHtmx [
	"Did htmx send this request?"

	^ self htmx isHtmx
]

{ #category : 'accessing' }
HxRequest >> pathParameters [

	^ pathParameters
]

{ #category : 'initialization' }
HxRequest >> setZnRequest: aZnRequest pathParameters: aDictionary [

	znRequest := aZnRequest.
	pathParameters := aDictionary
]

{ #category : 'accessing' }
HxRequest >> znRequest [

	^ znRequest
]
