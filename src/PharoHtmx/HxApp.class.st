"
I am the superclass of a web app. I am the delegate of a ZnServer: I dispatch each request through my router and turn the answer of the route into a ZnResponse.

Subclasses override #routes: to declare their routes.

	MyApp new startOn: 8080.
	...
	app stop
"
Class {
	#name : 'HxApp',
	#superclass : 'Object',
	#instVars : [
		'router',
		'server'
	],
	#category : 'PharoHtmx-Core',
	#package : 'PharoHtmx',
	#tag : 'Core'
}

{ #category : 'request handling' }
HxApp >> handleRequest: aZnRequest [
	"Called by the ZnServer for every request."

	^ self responseFor: (router dispatch: aZnRequest) request: aZnRequest
]

{ #category : 'initialization' }
HxApp >> initialize [

	super initialize.
	router := HxRouter new.
	self routes: router
]

{ #category : 'request handling' }
HxApp >> responseFor: anObject request: aZnRequest [
	"A route answers a ZnResponse, or a String that becomes an HTML page. nil means no route matched."

	anObject ifNil: [ ^ ZnResponse notFound: aZnRequest url ].
	(anObject isKindOf: ZnResponse) ifTrue: [ ^ anObject ].
	^ ZnResponse ok: (ZnEntity html: anObject asString)
]

{ #category : 'accessing' }
HxApp >> router [

	^ router
]

{ #category : 'routes' }
HxApp >> routes: aRouter [
	"Override to declare the routes of the app, as in
		aRouter get: '/books/<id>' do: [ :req | self book: req ]"

	
]

{ #category : 'accessing' }
HxApp >> server [

	^ server
]

{ #category : 'server' }
HxApp >> startOn: aPort [

	self stop.
	server := (ZnServer on: aPort)
		          delegate: self;
		          start;
		          yourself
]

{ #category : 'server' }
HxApp >> stop [

	server ifNotNil: [
			server stop.
			server := nil ]
]
