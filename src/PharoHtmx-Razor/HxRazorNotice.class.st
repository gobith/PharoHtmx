"
I am an error in a Razor view method, at a position in the Razor source rather than at the start of a node of the generated code.
"
Class {
	#name : 'HxRazorNotice',
	#superclass : 'OCErrorNotice',
	#instVars : [
		'position'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'testing' }
HxRazorNotice >> isSyntaxError [

	^ true
]

{ #category : 'accessing' }
HxRazorNotice >> position [

	^ position
]

{ #category : 'accessing' }
HxRazorNotice >> position: anInteger [

	position := anInteger
]
