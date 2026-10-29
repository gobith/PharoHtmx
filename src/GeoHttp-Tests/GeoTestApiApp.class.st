"
An app for other programs, not for browsers, which switches the CSRF check off; for GeoCsrfTest.
"
Class {
	#name : 'GeoTestApiApp',
	#superclass : 'GeoTestCsrfApp',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'security' }
GeoTestApiApp >> checksCsrf [

	^ false
]
