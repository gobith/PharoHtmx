"
I guard the layers of the Geo packages: a package may only use the Geo packages that #allowed lists for it, so a lower layer never knows a higher one. GeoRazor and GeoHttp know no other Geo package; GeoHtmx joins them; the forms and the demo sit on top.

I look at the classes each method refers to, at superclasses and at traits. When I fail, I name the package, the method or class, and the package it should not use.
"
Class {
	#name : 'GeoArchitectureTest',
	#superclass : 'TestCase',
	#category : 'GeoHtmx-Demo-Tests',
	#package : 'GeoHtmx-Demo',
	#tag : 'Tests'
}

{ #category : 'layers' }
GeoArchitectureTest >> allowed [
	"Each Geo package and the Geo packages it may use."

	^ Dictionary newFromPairs: {
			  'GeoRazor'.
			  #(  ).
			  'GeoHttp'.
			  #(  ).
			  'GeoHtmx'.
			  #( 'GeoRazor' 'GeoHttp' ).
			  'GeoHtmx-Magritte'.
			  #( 'GeoRazor' 'GeoHttp' 'GeoHtmx' ).
			  'GeoHtmx-Demo'.
			  #( 'GeoRazor' 'GeoHttp' 'GeoHtmx' 'GeoHtmx-Magritte' 'GeoRazor-Tests' 'GeoHttp-Tests' 'GeoHtmx-Tests' ).
			  'GeoRazor-Tests'.
			  #( 'GeoRazor' ).
			  'GeoHttp-Tests'.
			  #( 'GeoHttp' ).
			  'GeoHtmx-Tests'.
			  #( 'GeoRazor' 'GeoHttp' 'GeoHtmx' 'GeoHttp-Tests' ) }
]

{ #category : 'tests' }
GeoArchitectureTest >> testEveryGeoPackageHasALayer [
	"A new package in the framework's repository must say which packages it may use. Applications built on Geo live in other repositories and are not checked."

	| repository packages |
	repository := IceRepository registry
		              detect: [ :each | each includesPackageNamed: self class package name ]
		              ifNone: [ ^ self skip: 'The framework is not loaded from an Iceberg repository' ].
	packages := repository workingCopy packageNames reject: [ :each | each beginsWith: 'BaselineOf' ].
	self assert: (packages reject: [ :each | self allowed includesKey: each ]) asArray equals: #(  )
]

{ #category : 'tests' }
GeoArchitectureTest >> testLayers [
	"No package uses a Geo package above it."

	self assert: self violations asArray equals: #(  )
]

{ #category : 'layers' }
GeoArchitectureTest >> violations [
	"Answer a description of each use of a Geo package that #allowed does not list."

	| allowed violations |
	allowed := self allowed.
	violations := OrderedCollection new.
	allowed keysDo: [ :name |
			| package check |
			package := PackageOrganizer default packageNamed: name.
			check := [ :what :aClass |
				         | used |
				         used := aClass instanceSide package name.
				         ((allowed includesKey: used) and: [ used ~= name and: [ ((allowed at: name) includes: used) not ] ]) ifTrue: [
					         violations add: name , ': ' , what , ' uses ' , aClass instanceSide name , ' of ' , used ] ].
			package definedClasses do: [ :class |
					class superclass ifNotNil: [ :superclass | check value: class name value: superclass ].
					class traits do: [ :trait | check value: class name value: trait ] ].
			package methods do: [ :method |
					method literals do: [ :literal |
							(literal isVariableBinding and: [ literal value isClass or: [ literal value isTrait ] ]) ifTrue: [
								check value: method printString value: literal value ] ] ] ].
	^ violations
]
