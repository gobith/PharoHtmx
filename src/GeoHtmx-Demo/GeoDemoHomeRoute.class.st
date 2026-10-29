"
Send the visitor on to the book list.
"
Class {
	#name : 'GeoDemoHomeRoute',
	#superclass : 'GeoRoute',
	#category : 'GeoHtmx-Demo-Routes',
	#package : 'GeoHtmx-Demo',
	#tag : 'Routes'
}

{ #category : 'routing' }
GeoDemoHomeRoute class >> pattern [

	^ '/'
]

{ #category : 'handling' }
GeoDemoHomeRoute >> handle [

	^ ZnResponse redirect: GeoDemoBooksPage path
]
