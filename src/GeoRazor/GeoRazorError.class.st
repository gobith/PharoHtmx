"
I am signalled when the Razor source of a view method cannot be translated, such as an unclosed {{ or a missing closing tag.
"
Class {
	#name : 'GeoRazorError',
	#superclass : 'Error',
	#instVars : [
		'position'
	],
	#category : 'GeoRazor-Compiler',
	#package : 'GeoRazor',
	#tag : 'Compiler'
}

{ #category : 'signalling' }
GeoRazorError class >> signal: aString at: aPosition [

	^ self new
		  position: aPosition;
		  signal: aString
]

{ #category : 'accessing' }
GeoRazorError >> position [
	"The position in the Razor source where the problem is."

	^ position
]

{ #category : 'accessing' }
GeoRazorError >> position: anInteger [

	position := anInteger
]
