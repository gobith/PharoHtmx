"
I am signalled when the Razor source of a view method cannot be translated, such as an unclosed {{ or a missing closing tag.
"
Class {
	#name : 'HxRazorError',
	#superclass : 'Error',
	#instVars : [
		'position'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'signalling' }
HxRazorError class >> signal: aString at: aPosition [

	^ self new
		  position: aPosition;
		  signal: aString
]

{ #category : 'accessing' }
HxRazorError >> position [
	"The position in the Razor source where the problem is."

	^ position
]

{ #category : 'accessing' }
HxRazorError >> position: anInteger [

	position := anInteger
]
