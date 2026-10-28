"
I am the superclass of view classes. The methods of my subclasses are written as HTML with Razor-style Smalltalk in it (see HxRazorTranslator); I myself am plain Smalltalk.

	BookViews new bookList: books; contents
"
Class {
	#name : 'HxView',
	#superclass : 'Object',
	#instVars : [
		'html'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'compiling' }
HxView class >> compilerClass [
	"My subclasses are written in Razor-style HTML; I am plain Smalltalk."

	^ self == HxView
		  ifTrue: [ super compilerClass ]
		  ifFalse: [ HxRazorCompiler ]
]

{ #category : 'compiling' }
HxView class >> formatter [
	"Views are re-indented as Razor source; plain Smalltalk methods are formatted as usual."

	^ HxRazorFormatter new
]

{ #category : 'accessing' }
HxView >> contents [
	"Answer the HTML written so far."

	^ html contents
]

{ #category : 'initialization' }
HxView >> initialize [

	super initialize.
	html := HxHtmlWriter new
]
