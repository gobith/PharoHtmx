"
I am one route that a class declares in a class-side method, with a pragma that names the HTTP method:

	HxSpikeNote class >> edit: request [
		""Swap the text for a form that edits it.""
		<get>
		^ (self text: request app showcase note) beEditing; yourself
	]

The pragmas are <get>, <post>, <put>, <patch> and <delete>. Without a path, I get one from the class and the selector: /HxSpikeNote/edit. Give a path when it needs a parameter or when people see it, as in <get: '/books/<id>'>.

The method gets the HxRequest, which knows the app (request app) and the path parameters, query and form fields (request at: #id). It answers a component, an HxHtmxResponse, a String of HTML or a ZnResponse.

A template asks for my path with ""self path: #edit:"" or ""self path: #delete: with: todo id"". ""HxEndpoint allIn: aClass"" answers the endpoints of a class; an app lists the class in its #routes. The first line of the method comment is my #summary.
"
Class {
	#name : 'HxEndpoint',
	#superclass : 'Object',
	#instVars : [
		'method'
	],
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
HxEndpoint class >> allIn: aClass [
	"The endpoints that aClass declares in its class-side methods, ordered by path and HTTP method."

	^ (aClass classSide methods select: [ :each | self isEndpoint: each ] thenCollect: [ :each | self method: each ]) sorted: [ :a :b |
			  a pattern = b pattern
				  ifTrue: [ a httpMethod <= b httpMethod ]
				  ifFalse: [ a pattern <= b pattern ] ]
]

{ #category : 'instance creation' }
HxEndpoint class >> in: aClass selector: aSelector [
	"The endpoint of aClass in its class-side method aSelector, as in #tick:."

	| method |
	method := aClass classSide compiledMethodAt: aSelector asSymbol ifAbsent: [ ^ self noEndpoint: aSelector in: aClass ].
	(self isEndpoint: method) ifFalse: [ ^ self notAnEndpoint: method ].
	^ self method: method
]

{ #category : 'pragmas' }
HxEndpoint class >> isEndpoint: aCompiledMethod [
	"Does aCompiledMethod have a <get>, <post>, <put>, <patch> or <delete> pragma?"

	^ aCompiledMethod pragmas anySatisfy: [ :each | self pragmaSelectors includes: each selector ]
]

{ #category : 'instance creation' }
HxEndpoint class >> method: aCompiledMethod [

	^ self new setMethod: aCompiledMethod
]

{ #category : 'errors' }
HxEndpoint class >> noEndpoint: aSelector in: aClass [
	"aClass has no class-side method aSelector. When it has one with a colon more, the colon is what is missing."

	((aSelector endsWith: ':') not and: [ aClass classSide includesSelector: (aSelector , ':') asSymbol ]) ifTrue: [
		^ self error: aClass name , ' has no endpoint #' , aSelector , '; write #' , aSelector , ': with the colon' ].
	^ self error: aClass name , ' has no endpoint #' , aSelector
]

{ #category : 'errors' }
HxEndpoint class >> notAnEndpoint: aCompiledMethod [
	"aCompiledMethod exists but has no endpoint pragma."

	^ self error: aCompiledMethod methodClass instanceSide name , ' class>>#' , aCompiledMethod selector
		  , ' is not an endpoint: it has no <get>, <post>, <put>, <patch> or <delete> pragma'
]

{ #category : 'pragmas' }
HxEndpoint class >> pragmaSelectors [
	"The pragmas that declare an endpoint: one per HTTP method, without or with a path."

	^ #( #get #post #put #patch #delete #get: #post: #put: #patch: #delete: )
]

{ #category : 'comparing' }
HxEndpoint >> = anObject [

	^ self class = anObject class and: [ method = anObject method ]
]

{ #category : 'handling' }
HxEndpoint >> handle: anHxRequest in: anApp [
	"Answer what my method answers for anHxRequest."

	^ method methodClass instanceSide perform: method selector with: anHxRequest
]

{ #category : 'comparing' }
HxEndpoint >> hash [

	^ method hash
]

{ #category : 'routing' }
HxEndpoint >> httpMethod [

	^ (self pragma selector copyWithout: $:) asUppercase asSymbol
]

{ #category : 'accessing' }
HxEndpoint >> method [

	^ method
]

{ #category : 'documentation' }
HxEndpoint >> name [
	"The class and the selector, for an overview of the routes."

	^ method methodClass instanceSide name , ' >> ' , method selector
]

{ #category : 'routing' }
HxEndpoint >> path [
	"My path, for a pattern without parameters."

	^ self routePattern pathWith: Dictionary new
]

{ #category : 'routing' }
HxEndpoint >> pathWith: anObject [
	"My path with its parameters filled in; see HxRoutePattern>>pathWith:."

	^ self routePattern pathWith: anObject
]

{ #category : 'routing' }
HxEndpoint >> pattern [
	"The path of the pragma, as in <get: '/books/<id>'>. A pragma without a path, as in <get>, gets one from my class and selector, as in /HxSpikeNote/edit."

	self pragma arguments ifNotEmpty: [ :arguments | ^ arguments first ].
	^ '/' , method methodClass instanceSide name , '/' , (method selector copyWithout: $:)
]

{ #category : 'accessing' }
HxEndpoint >> pragma [

	^ method pragmas detect: [ :each | self class pragmaSelectors includes: each selector ]
]

{ #category : 'printing' }
HxEndpoint >> printOn: aStream [

	aStream
		print: self routePattern;
		nextPutAll: ' -> ';
		nextPutAll: self name
]

{ #category : 'routing' }
HxEndpoint >> routePattern [

	^ HxRoutePattern method: self httpMethod pattern: self pattern
]

{ #category : 'accessing' }
HxEndpoint >> selector [

	^ method selector
]

{ #category : 'initialization' }
HxEndpoint >> setMethod: aCompiledMethod [

	method := aCompiledMethod
]

{ #category : 'documentation' }
HxEndpoint >> summary [
	"The first line of my method's comment."

	^ (method comment ifNil: [ '' ]) lines
		  ifEmpty: [ '' ]
		  ifNotEmpty: [ :lines | lines first ]
]
