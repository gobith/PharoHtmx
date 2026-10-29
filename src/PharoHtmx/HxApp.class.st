"
I am the superclass of a web app. I am the delegate of a ZnServer: I dispatch each request to one of my route classes (see HxRoute) and turn its answer into a ZnResponse.

Subclasses override #routes to list their route classes. The list is read for every request, so a change to it works at once on a running server.

	MyApp new startOn: 8080.
	...
	app stop
"
Class {
	#name : 'HxApp',
	#superclass : 'Object',
	#instVars : [
		'server'
	],
	#category : 'PharoHtmx-Core',
	#package : 'PharoHtmx',
	#tag : 'Core'
}

{ #category : 'routes' }
HxApp >> endpoints [
	"The endpoints of my routes: a route class or page is one endpoint, a component has one per endpoint method."

	^ self routes flatCollect: [ :each | each endpoints ]
]

{ #category : 'request handling' }
HxApp >> handleRequest: aZnRequest [
	"Called by the ZnServer for every request."

	^ self responseFor: (self router dispatch: aZnRequest for: self) request: aZnRequest
]

{ #category : 'rendering' }
HxApp >> layoutFor: aPage [
	"The component that is the whole document around aPage. Override to put pages in a layout; by default a page is the whole document itself."

	^ aPage
]

{ #category : 'request handling' }
HxApp >> responseFor: anObject request: aZnRequest [
	"A route answers a ZnResponse, something that converts itself with #asZnResponse (a component, an HxHtmxResponse), or a String that becomes an HTML page. nil means no route matched."

	anObject ifNil: [ ^ ZnResponse notFound: aZnRequest url ].
	(anObject isKindOf: ZnResponse) ifTrue: [ ^ anObject ].
	(anObject respondsTo: #asZnResponse) ifTrue: [ ^ anObject asZnResponse ].
	^ ZnResponse ok: (ZnEntity html: anObject asString)
]

{ #category : 'routes' }
HxApp >> router [

	^ HxRouter routes: self endpoints
]

{ #category : 'routes' }
HxApp >> routes [
	"Override to answer the route classes of the app (see HxRoute), as in
		^ { BookList. BookDetail }"

	^ #(  )
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
