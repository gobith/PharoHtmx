"
An app with the test routes, for GeoAppTest.
"
Class {
	#name : 'GeoTestApp',
	#superclass : 'GeoApp',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routes' }
GeoTestApp >> routes [

	^ {
		  GeoTestHelloRoute.
		  GeoTestOldRoute }
]
