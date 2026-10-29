"
I am one route that a class declares in a class-side method, with a pragma that names the HTTP method:

	GeoDemoNote class >> edit: request [
		""Swap the text for a form that edits it.""
		<get>
		^ (self text: request app showcase note) beEditing; yourself
	]

The pragmas are <get>, <post>, <put>, <patch> and <delete>. Without a path, I get one from the class and the selector: /GeoDemoNote/edit. Give a path when it needs a parameter or when people see it, as in <get: '/books/<id>'>.

The method gets the GeoRequest, which knows the app (request app) and the path parameters, query and form fields (request at: #id). It answers a component, an GeoHtmxResponse, a String of HTML or a ZnResponse.

A template asks for my path with ""self path: #edit:"" or ""self path: #delete: with: todo id"". ""GeoEndpoint allIn: aClass"" answers the endpoints of a class; an app lists the class in its #routes. The first line of the method comment is my #summary.
"
Class {
	#name : 'GeoEndpoint',
	#superclass : 'Object',
	#instVars : [
		'method'
	],
	#category : 'GeoHttp-Routing',
	#package : 'GeoHttp',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
GeoEndpoint class >> allIn: aClass [
	"The endpoints that aClass declares in its class-side methods, ordered by path and HTTP method."

	^ (aClass classSide methods select: [ :each | self isEndpoint: each ] thenCollect: [ :each | self method: each ]) sorted: [ :a :b |
			  a pattern = b pattern
				  ifTrue: [ a httpMethod <= b httpMethod ]
				  ifFalse: [ a pattern <= b pattern ] ]
]

{ #category : 'instance creation' }
GeoEndpoint class >> in: aClass selector: aSelector [
	"The endpoint of aClass in its class-side method aSelector, as in #tick:."

	| method |
	method := aClass classSide compiledMethodAt: aSelector asSymbol ifAbsent: [ ^ self noEndpoint: aSelector in: aClass ].
	(self isEndpoint: method) ifFalse: [ ^ self notAnEndpoint: method ].
	^ self method: method
]

{ #category : 'pragmas' }
GeoEndpoint class >> isEndpoint: aCompiledMethod [
	"Does aCompiledMethod have a <get>, <post>, <put>, <patch> or <delete> pragma?"

	^ aCompiledMethod pragmas anySatisfy: [ :each | self pragmaSelectors includes: each selector ]
]

{ #category : 'instance creation' }
GeoEndpoint class >> method: aCompiledMethod [

	^ self new setMethod: aCompiledMethod
]

{ #category : 'errors' }
GeoEndpoint class >> noEndpoint: aSelector in: aClass [
	"aClass has no class-side method aSelector. When it has one with a colon more, the colon is what is missing."

	((aSelector endsWith: ':') not and: [ aClass classSide includesSelector: (aSelector , ':') asSymbol ]) ifTrue: [
		^ self error: aClass name , ' has no endpoint #' , aSelector , '; write #' , aSelector , ': with the colon' ].
	^ self error: aClass name , ' has no endpoint #' , aSelector
]

{ #category : 'errors' }
GeoEndpoint class >> notAnEndpoint: aCompiledMethod [
	"aCompiledMethod exists but has no endpoint pragma."

	^ self error: aCompiledMethod methodClass instanceSide name , ' class>>#' , aCompiledMethod selector
		  , ' is not an endpoint: it has no <get>, <post>, <put>, <patch> or <delete> pragma'
]

{ #category : 'pragmas' }
GeoEndpoint class >> pragmaSelectors [
	"The pragmas that declare an endpoint: one per HTTP method, without or with a path."

	^ #( #get #post #put #patch #delete #get: #post: #put: #patch: #delete: )
]

{ #category : 'comparing' }
GeoEndpoint >> = anObject [

	^ self class = anObject class and: [ method = anObject method ]
]

{ #category : 'handling' }
GeoEndpoint >> handle: aGeoRequest in: anApp [
	"Answer what my method answers for aGeoRequest."

	^ method methodClass instanceSide perform: method selector with: aGeoRequest
]

{ #category : 'comparing' }
GeoEndpoint >> hash [

	^ method hash
]

{ #category : 'routing' }
GeoEndpoint >> httpMethod [

	^ (self pragma selector copyWithout: $:) asUppercase asSymbol
]

{ #category : 'accessing' }
GeoEndpoint >> method [

	^ method
]

{ #category : 'documentation' }
GeoEndpoint >> name [
	"The class and the selector, for an overview of the routes."

	^ method methodClass instanceSide name , ' >> ' , method selector
]

{ #category : 'routing' }
GeoEndpoint >> path [
	"My path, for a pattern without parameters."

	^ self routePattern pathWith: Dictionary new
]

{ #category : 'routing' }
GeoEndpoint >> pathWith: anObject [
	"My path with its parameters filled in; see GeoRoutePattern>>pathWith:."

	^ self routePattern pathWith: anObject
]

{ #category : 'routing' }
GeoEndpoint >> pattern [
	"The path of the pragma, as in <get: '/books/<id>'>. A pragma without a path, as in <get>, gets one from my class and selector, as in /GeoDemoNote/edit."

	self pragma arguments ifNotEmpty: [ :arguments | ^ arguments first ].
	^ '/' , method methodClass instanceSide name , '/' , (method selector copyWithout: $:)
]

{ #category : 'accessing' }
GeoEndpoint >> pragma [

	^ method pragmas detect: [ :each | self class pragmaSelectors includes: each selector ]
]

{ #category : 'printing' }
GeoEndpoint >> printOn: aStream [

	aStream
		print: self routePattern;
		nextPutAll: ' -> ';
		nextPutAll: self name
]

{ #category : 'routing' }
GeoEndpoint >> routePattern [

	^ GeoRoutePattern method: self httpMethod pattern: self pattern
]

{ #category : 'accessing' }
GeoEndpoint >> selector [

	^ method selector
]

{ #category : 'initialization' }
GeoEndpoint >> setMethod: aCompiledMethod [

	method := aCompiledMethod
]

{ #category : 'documentation' }
GeoEndpoint >> summary [
	"The first line of my method's comment."

	^ (method comment ifNil: [ '' ]) lines
		  ifEmpty: [ '' ]
		  ifNotEmpty: [ :lines | lines first ]
]
