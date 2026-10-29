"
I load htmx in the head of a page. Put me in a layout with @self render: GeoHtmxScript new, or pick a version with GeoHtmxScript version: '2.0.4'.
"
Class {
	#name : 'GeoHtmxScript',
	#superclass : 'GeoComponent',
	#instVars : [
		'version'
	],
	#category : 'GeoHtmx-Htmx',
	#package : 'GeoHtmx',
	#tag : 'Htmx'
}

{ #category : 'defaults' }
GeoHtmxScript class >> defaultVersion [
	"The htmx version that PharoHtmx is built and tested with."

	^ '2.0.4'
]

{ #category : 'instance creation' }
GeoHtmxScript class >> version: aString [

	^ self new setVersion: aString
]

{ #category : 'rendering' }
GeoHtmxScript >> render [
<script src="https://unpkg.com/htmx.org@{{ self version }}"></script>
]

{ #category : 'initialization' }
GeoHtmxScript >> setVersion: aString [

	version := aString
]

{ #category : 'accessing' }
GeoHtmxScript >> version [

	^ version ifNil: [ self class defaultVersion ]
]
