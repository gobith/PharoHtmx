"
I am the compiler of view classes: I compile Razor-style HTML methods, by way of HxRazorParser.
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
