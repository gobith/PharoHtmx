"
I am the HTTP method and path pattern of a route, and I match requests against them.

A pattern is split into segments. A segment like <id> is a parameter and matches any value; other segments must match literally.

	(GeoRoutePattern method: #GET pattern: '/books/<id>') matchSegments: #( 'books' '42' )    ""a Dictionary(#id->'42')""
"
Class {
	#name : 'GeoRoutePattern',
	#superclass : 'Object',
	#instVars : [
		'method',
		'segments'
	],
	#category : 'GeoHttp-Routing',
	#package : 'GeoHttp',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
GeoRoutePattern class >> method: aSymbol pattern: aString [

	^ self new setMethod: aSymbol pattern: aString
]

{ #category : 'testing' }
GeoRoutePattern >> isMoreSpecificThan: aPattern [
	"A pattern with fewer parameters wins when both match, so /cart/clear goes before /cart/<id>."

	^ self parameterCount < aPattern parameterCount
]

{ #category : 'testing' }
GeoRoutePattern >> isParameter: aSegment [

	^ aSegment size > 2 and: [ aSegment first = $< and: [ aSegment last = $> ] ]
]

{ #category : 'matching' }
GeoRoutePattern >> match: aZnRequest [
	"Answer an GeoRequest when aZnRequest fits my method and pattern, nil otherwise."

	aZnRequest method = method ifFalse: [ ^ nil ].
	^ (self matchSegments: (aZnRequest url pathSegments select: [ :each | each isString ])) ifNotNil: [ :parameters |
		  GeoRequest on: aZnRequest pathParameters: parameters ]
]

{ #category : 'matching' }
GeoRoutePattern >> matchSegments: pathSegments [
	"Answer a Dictionary of the path parameters when pathSegments fit my pattern, nil otherwise."

	| parameters |
	pathSegments size = segments size ifFalse: [ ^ nil ].
	parameters := Dictionary new.
	segments with: pathSegments do: [ :pattern :actual |
			(self isParameter: pattern)
				ifTrue: [ parameters at: (self parameterName: pattern) put: actual ]
				ifFalse: [ pattern = actual ifFalse: [ ^ nil ] ] ].
	^ parameters
]

{ #category : 'accessing' }
GeoRoutePattern >> method [

	^ method
]

{ #category : 'accessing' }
GeoRoutePattern >> parameterCount [

	^ segments count: [ :each | self isParameter: each ]
]

{ #category : 'building' }
GeoRoutePattern >> parameterName: aSegment [

	^ (aSegment copyFrom: 2 to: aSegment size - 1) asSymbol
]

{ #category : 'building' }
GeoRoutePattern >> parameterNames [

	^ (segments select: [ :each | self isParameter: each ]) collect: [ :each | self parameterName: each ]
]

{ #category : 'accessing' }
GeoRoutePattern >> path [
	"Answer the pattern as a path, as in /books/<id>."

	segments ifEmpty: [ ^ '/' ].
	^ String streamContents: [ :stream |
			  segments do: [ :each |
					  stream
						  nextPut: $/;
						  nextPutAll: each ] ]
]

{ #category : 'building' }
GeoRoutePattern >> pathWith: anObject [
	"Answer my path with its parameters filled in. anObject is a Dictionary of name -> value, or, for a pattern with one parameter, the value itself. Names that are not parameters of the pattern go into the query string.
		(GeoRoutePattern method: #GET pattern: '/books/<id>') pathWith: 42    ""'/books/42'""
		(GeoRoutePattern method: #GET pattern: '/rows') pathWith: { #page -> 2 } asDictionary    ""'/rows?page=2'"""

	| values path query |
	values := anObject isDictionary
		          ifTrue: [ anObject ]
		          ifFalse: [
				          Dictionary new
					          at: self parameterNames first put: anObject;
					          yourself ].
	path := segments
		        ifEmpty: [ '/' ]
		        ifNotEmpty: [
				        String streamContents: [ :stream |
						        segments do: [ :each |
								        stream nextPut: $/.
								        (self isParameter: each)
									        ifTrue: [ stream nextPutAll: (values at: (self parameterName: each)) asString urlEncoded ]
									        ifFalse: [ stream nextPutAll: each ] ] ] ].
	query := (values keys reject: [ :each | self parameterNames includes: each asSymbol ]) sorted.
	query ifEmpty: [ ^ path ].
	^ path , '?' , ('&' join: (query collect: [ :each | each asString urlEncoded , '=' , (values at: each) asString urlEncoded ]))
]

{ #category : 'printing' }
GeoRoutePattern >> printOn: aStream [

	aStream
		nextPutAll: method;
		space;
		nextPutAll: self path
]

{ #category : 'initialization' }
GeoRoutePattern >> setMethod: aSymbol pattern: aString [

	method := aSymbol asUppercase asSymbol.
	segments := ($/ split: aString) reject: [ :each | each isEmpty ]
]
