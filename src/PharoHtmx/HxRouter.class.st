"
I dispatch a ZnRequest to the route class (see HxRoute) whose method and pattern match it. When several match, the one with the fewest parameters wins, so /cart/clear goes before /cart/<id>.

	router := HxRouter routes: { BookList. BookDetail }.
	router dispatch: (ZnRequest get: '/books/42') for: anApp

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

{ #category : 'instance creation' }
HxRouter class >> routes: aCollectionOfRouteClasses [

	^ self new setRoutes: aCollectionOfRouteClasses
]

{ #category : 'dispatching' }
HxRouter >> dispatch: aZnRequest for: anApp [
	"Answer what the matching route answers, nil when no route matches."

	^ (self match: aZnRequest) ifNotNil: [ :match |
		  match value app: anApp.
		  match key handle: match value in: anApp ]
]

{ #category : 'dispatching' }
HxRouter >> match: aZnRequest [
	"Answer routeClass -> HxRequest for the most specific route that matches aZnRequest, nil when none does."

	| best bestPattern |
	routes do: [ :routeClass |
			| pattern |
			pattern := routeClass routePattern.
			(bestPattern isNil or: [ pattern isMoreSpecificThan: bestPattern ]) ifTrue: [
					(pattern match: aZnRequest) ifNotNil: [ :request |
							best := routeClass -> request.
							bestPattern := pattern ] ] ].
	^ best
]

{ #category : 'accessing' }
HxRouter >> routes [

	^ routes
]

{ #category : 'initialization' }
HxRouter >> setRoutes: aCollectionOfRouteClasses [

	routes := aCollectionOfRouteClasses asArray
]
