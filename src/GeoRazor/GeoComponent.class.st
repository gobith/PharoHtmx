"
I am the superclass of components. A component is one piece of UI in one class: its props are instance variables, its logic is plain Smalltalk, and its HTML is in its render methods.

A method whose selector starts with render is a Razor view (see GeoRazorTranslator); every other method is plain Smalltalk. #render writes the component; a template renders a child component into the same HTML with @self render: (BookRow book: book).

	BookRow class >> book: aBook [ ^ self new setBook: aBook ]
	BookRow >> setBook: aBook [ book := aBook ]
	BookRow >> render [
	<li>{{ book title }}</li>
	]

	(BookRow book: aBook) toHtml

A component answers requests in class-side endpoint methods (see GeoEndpoint); its templates point at them with self path: #edit:.

Components are built anew for every request and keep no state between requests.
"
Class {
	#name : 'GeoComponent',
	#superclass : 'Object',
	#instVars : [
		'html'
	],
	#category : 'GeoRazor-Components',
	#package : 'GeoRazor',
	#tag : 'Components'
}

{ #category : 'compiling' }
GeoComponent class >> compilerClass [
	"The render methods of my subclasses are Razor views, their other methods plain Smalltalk; I myself am plain Smalltalk."

	^ self == GeoComponent
		  ifTrue: [ Object compilerClass ]
		  ifFalse: [ GeoRazorCompiler ]
]

{ #category : 'compiling' }
GeoComponent class >> formatter [
	"Views are re-indented as Razor source; plain Smalltalk methods are formatted as usual."

	^ GeoRazorFormatter new
]

{ #category : 'accessing' }
GeoComponent >> contents [
	"Answer the HTML written so far."

	^ html contents
]

{ #category : 'initialization' }
GeoComponent >> initialize [

	super initialize.
	html := GeoHtmlWriter new
]

{ #category : 'rendering' }
GeoComponent >> render [
	"Write me. In a subclass this is a Razor view."

	self subclassResponsibility
]

{ #category : 'rendering' }
GeoComponent >> render: aComponent [
	"Write aComponent into my HTML, as a child of mine."

	aComponent
		setHtml: html;
		render
]

{ #category : 'initialization' }
GeoComponent >> setHtml: anHtmlWriter [

	html := anHtmlWriter
]

{ #category : 'rendering' }
GeoComponent >> toHtml [
	"Render me and answer the HTML."

	self render.
	^ self contents
]

{ #category : 'rendering' }
GeoComponent >> writeHtmlOn: anHtmlWriter [
	"Render me where a {{ }} stands for me in a view: {{ GeoDemoTodoItem todo: todo }}."

	self
		setHtml: anHtmlWriter;
		render
]
