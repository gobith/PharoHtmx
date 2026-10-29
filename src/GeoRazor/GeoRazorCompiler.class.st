"
I am the compiler of component classes (see GeoComponent): their render methods are Razor views, by way of GeoRazorParser, and their other methods plain Smalltalk.
"
Class {
	#name : 'GeoRazorCompiler',
	#superclass : 'OpalCompiler',
	#category : 'GeoRazor-Compiler',
	#package : 'GeoRazor',
	#tag : 'Compiler'
}

{ #category : 'accessing' }
GeoRazorCompiler >> compilationContext [

	^ compilationContext ifNil: [ compilationContext := self compilationContextClass default parserClass: GeoRazorParser ]
]
