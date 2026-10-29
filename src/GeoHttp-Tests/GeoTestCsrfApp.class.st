"
An app with an endpoint that changes something (GeoTestGreeter class>>#whoAmI:, a POST), for GeoCsrfTest.
"
Class {
	#name : 'GeoTestCsrfApp',
	#superclass : 'GeoApp',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routes' }
GeoTestCsrfApp >> routes [

	^ { GeoTestGreeter }
]
