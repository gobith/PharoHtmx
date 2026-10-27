"
I hold the routes of an app and dispatch a ZnRequest to the first route that matches its method and path.

	router := HxRouter new.
	router get: '/books/<id>' do: [ :req | 'Book ' , (req at: #id) ].
	router dispatch: (ZnRequest get: '/books/42')    ""'Book 42'""

I answer nil when no route matches.
"
Class {
	#name : 'HxRouter',
	#superclass : 'Object',
	#instVars : [
		'routes'
	],
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}

{ #category : 'adding' }
HxRouter >> add: aMethod pattern: aString do: aBlock [

	^ routes add: (HxRoute method: aMethod pattern: aString block: aBlock)
]

{ #category : 'adding' }
HxRouter >> delete: aString do: aBlock [

	^ self add: #DELETE pattern: aString do: aBlock
]

{ #category : 'dispatching' }
HxRouter >> dispatch: aZnRequest [
	"Answer what the first matching route answers, nil when no route matches."

	routes do: [ :route | (route match: aZnRequest) ifNotNil: [ :request | ^ route block value: request ] ].
	^ nil
]

{ #category : 'adding' }
HxRouter >> get: aString do: aBlock [

	^ self add: #GET pattern: aString do: aBlock
]

{ #category : 'initialization' }
HxRouter >> initialize [

	super initialize.
	routes := OrderedCollection new
]

{ #category : 'adding' }
HxRouter >> post: aString do: aBlock [

	^ self add: #POST pattern: aString do: aBlock
]

{ #category : 'adding' }
HxRouter >> put: aString do: aBlock [

	^ self add: #PUT pattern: aString do: aBlock
]

{ #category : 'accessing' }
HxRouter >> routes [

	^ routes
]
