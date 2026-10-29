"
I am an error in a Razor view method, at a position in the Razor source rather than at the start of a node of the generated code.
"
Class {
	#name : 'GeoRazorNotice',
	#superclass : 'OCErrorNotice',
	#instVars : [
		'position'
	],
	#category : 'GeoRazor-Compiler',
	#package : 'GeoRazor',
	#tag : 'Compiler'
}

{ #category : 'testing' }
GeoRazorNotice >> isSyntaxError [

	^ true
]

{ #category : 'accessing' }
GeoRazorNotice >> position [

	^ position
]

{ #category : 'accessing' }
GeoRazorNotice >> position: anInteger [

	position := anInteger
]
