"
A class with endpoints in its class-side methods, for HxEndpointTest.
"
Class {
	#name : 'HxTestGreeter',
	#superclass : 'Object',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestGreeter class >> endpoints [

	^ HxEndpoint allIn: self
]

{ #category : 'endpoints' }
HxTestGreeter class >> hello: request [
	"Greet someone by name.
	A second line that the summary leaves out."
	<get: '/greet/<name>'>

	^ '<p>Hello ' , (request at: #name) , '</p>'
]

{ #category : 'helpers' }
HxTestGreeter class >> notAnEndpoint [

	^ 42
]

{ #category : 'endpoints' }
HxTestGreeter class >> wave: request [
	"An endpoint without a path of its own."
	<get>

	^ '<p>Hi</p>'
]

{ #category : 'endpoints' }
HxTestGreeter class >> whoAmI: request [
	"Answer the name of the app's class."
	<post: '/greet'>

	^ request app class name
]
