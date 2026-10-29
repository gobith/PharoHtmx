"
I am the compiler of component classes (see HxComponent): their render methods are Razor views, by way of HxRazorParser, and their other methods plain Smalltalk.
"
Class {
	#name : 'HxRazorCompiler',
	#superclass : 'OpalCompiler',
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'accessing' }
HxRazorCompiler >> compilationContext [

	^ compilationContext ifNil: [ compilationContext := self compilationContextClass default parserClass: HxRazorParser ]
]
