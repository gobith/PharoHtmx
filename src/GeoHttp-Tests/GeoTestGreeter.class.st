"
A class with endpoints in its class-side methods, for GeoEndpointTest.
"
Class {
	#name : 'GeoTestGreeter',
	#superclass : 'Object',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestGreeter class >> endpoints [

	^ GeoEndpoint allIn: self
]

{ #category : 'endpoints' }
GeoTestGreeter class >> hello: request [
	"Greet someone by name.
	A second line that the summary leaves out."
	<get: '/greet/<name>'>

	^ '<p>Hello ' , (request at: #name) , '</p>'
]

{ #category : 'helpers' }
GeoTestGreeter class >> notAnEndpoint [

	^ 42
]

{ #category : 'endpoints' }
GeoTestGreeter class >> wave: request [
	"An endpoint without a path of its own."
	<get>

	^ '<p>Hi</p>'
]

{ #category : 'endpoints' }
GeoTestGreeter class >> whoAmI: request [
	"Answer the name of the app's class."
	<post: '/greet'>

	^ request app class name
]
