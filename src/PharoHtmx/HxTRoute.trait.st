"
I make a class answer requests: its class side says which (#httpMethod and #pattern), an instance handles one of them (#handle). An app lists such classes in its #routes. HxRoute and HxPage use me.

An instance lives for one request. It knows the app, so it can reach the app's data, and the HxRequest, so it can read the path parameters, the query and the form fields with #at:.

The first line of the class comment is the #summary that an overview of the routes shows.
"
Trait {
	#name : 'HxTRoute',
	#instVars : [
		'app',
		'request'
	],
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}

{ #category : 'routing' }
HxTRoute classSide >> endpoints [
	"A route class is its own endpoint."

	^ { self }
]

{ #category : 'routing' }
HxTRoute classSide >> handle: anHxRequest in: anApp [
	"Handle anHxRequest with a new instance of me."

	^ (self new setApp: anApp request: anHxRequest) handle
]

{ #category : 'routing' }
HxTRoute classSide >> httpMethod [
	"The HTTP method I handle. Override for anything but GET."

	^ #GET
]

{ #category : 'routing' }
HxTRoute classSide >> path [
	"My path, for a pattern without parameters."

	^ self routePattern pathWith: Dictionary new
]

{ #category : 'routing' }
HxTRoute classSide >> pathWith: anObject [
	"My path with its parameters filled in; see HxRoutePattern>>pathWith:.
		BookDetail pathWith: 3    ""'/books/3'"""

	^ self routePattern pathWith: anObject
]

{ #category : 'routing' }
HxTRoute classSide >> pattern [
	"The path I handle, as in '/books/<id>'."

	^ self subclassResponsibility
]

{ #category : 'routing' }
HxTRoute classSide >> routePattern [

	^ HxRoutePattern method: self httpMethod pattern: self pattern
]

{ #category : 'documentation' }
HxTRoute classSide >> summary [
	"The first line of my class comment, for an overview of the routes."

	^ (self comment ifNil: [ '' ]) lines ifEmpty: [ '' ] ifNotEmpty: [ :lines | lines first ]
]

{ #category : 'accessing' }
HxTRoute >> app [

	^ app
]

{ #category : 'accessing' }
HxTRoute >> at: aName [
	"The path parameter, query parameter or form field aName; nil when there is none."

	^ request at: aName
]

{ #category : 'accessing' }
HxTRoute >> at: aName ifAbsent: aBlock [

	^ request at: aName ifAbsent: aBlock
]

{ #category : 'handling' }
HxTRoute >> handle [
	"Answer the response to my request: a String (an HTML page or fragment) or a ZnResponse."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
HxTRoute >> request [

	^ request
]

{ #category : 'initialization' }
HxTRoute >> setApp: anApp request: anHxRequest [

	app := anApp.
	request := anHxRequest
]
