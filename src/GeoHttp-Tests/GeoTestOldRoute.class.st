"
A route that answers a ZnResponse.
"
Class {
	#name : 'GeoTestOldRoute',
	#superclass : 'GeoTestRoute',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestOldRoute class >> pattern [

	^ '/old'
]

{ #category : 'handling' }
GeoTestOldRoute >> handle [

	^ ZnResponse redirect: '/new'
]
