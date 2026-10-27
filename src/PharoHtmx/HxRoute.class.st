"
I am one route: an HTTP method, a path pattern and a block that handles the request.

A pattern is split into segments. A segment like <id> is a parameter and matches any value; other segments must match literally.

	HxRoute method: #GET pattern: '/books/<id>' block: [ :req | req at: #id ]
"
Class {
	#name : 'HxRoute',
	#superclass : 'Object',
	#instVars : [
		'method',
		'segments',
		'block'
	],
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
HxRoute class >> method: aSymbol pattern: aString block: aBlock [

	^ self new setMethod: aSymbol pattern: aString block: aBlock
]

{ #category : 'accessing' }
HxRoute >> block [

	^ block
]

{ #category : 'testing' }
HxRoute >> isParameter: aSegment [

	^ aSegment size > 2 and: [ aSegment first = $< and: [ aSegment last = $> ] ]
]

{ #category : 'matching' }
HxRoute >> match: aZnRequest [
	"Answer an HxRequest when aZnRequest fits my method and pattern, nil otherwise."

	aZnRequest method = method ifFalse: [ ^ nil ].
	^ (self matchSegments: (aZnRequest url pathSegments select: [ :each | each isString ])) ifNotNil: [ :parameters |
		  HxRequest on: aZnRequest pathParameters: parameters ]
]

{ #category : 'matching' }
HxRoute >> matchSegments: pathSegments [
	"Answer a Dictionary of the path parameters when pathSegments fit my pattern, nil otherwise."

	| parameters |
	pathSegments size = segments size ifFalse: [ ^ nil ].
	parameters := Dictionary new.
	segments with: pathSegments do: [ :pattern :actual |
			(self isParameter: pattern)
				ifTrue: [ parameters at: (pattern copyFrom: 2 to: pattern size - 1) asSymbol put: actual ]
				ifFalse: [ pattern = actual ifFalse: [ ^ nil ] ] ].
	^ parameters
]

{ #category : 'accessing' }
HxRoute >> method [

	^ method
]

{ #category : 'printing' }
HxRoute >> printOn: aStream [

	aStream
		nextPutAll: method;
		space.
	segments do: [ :each |
			aStream
				nextPut: $/;
				nextPutAll: each ].
	segments ifEmpty: [ aStream nextPut: $/ ]
]

{ #category : 'initialization' }
HxRoute >> setMethod: aSymbol pattern: aString block: aBlock [

	method := aSymbol asUppercase asSymbol.
	segments := ($/ split: aString) reject: [ :each | each isEmpty ].
	block := aBlock
]
