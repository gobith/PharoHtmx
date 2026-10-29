"
I load htmx in the head of a page. Put me in a layout with @self render: HxHtmxScript new, or pick a version with HxHtmxScript version: '2.0.4'.
"
Class {
	#name : 'HxHtmxScript',
	#superclass : 'HxComponent',
	#instVars : [
		'version'
	],
	#category : 'PharoHtmx-Razor-Htmx',
	#package : 'PharoHtmx-Razor',
	#tag : 'Htmx'
}

{ #category : 'defaults' }
HxHtmxScript class >> defaultVersion [
	"The htmx version that PharoHtmx is built and tested with."

	^ '2.0.4'
]

{ #category : 'instance creation' }
HxHtmxScript class >> version: aString [

	^ self new setVersion: aString
]

{ #category : 'rendering' }
HxHtmxScript >> render [
<script src="https://unpkg.com/htmx.org@{{ self version }}"></script>
]

{ #category : 'initialization' }
HxHtmxScript >> setVersion: aString [

	version := aString
]

{ #category : 'accessing' }
HxHtmxScript >> version [

	^ version ifNil: [ self class defaultVersion ]
]
