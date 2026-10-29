"
I am the superclass of components. A component is one piece of UI in one class: its props are instance variables, its logic is plain Smalltalk, and its HTML is in its render methods.

A method whose selector starts with render is a Razor view (see HxRazorTranslator); every other method is plain Smalltalk. #render writes the component; a template renders a child component into the same HTML with @self render: (BookRow book: book).

	BookRow class >> book: aBook [ ^ self new setBook: aBook ]
	BookRow >> setBook: aBook [ book := aBook ]
	BookRow >> render [
	<li>{{ book title }}</li>
	]

	(BookRow book: aBook) toHtml

A component answers requests in class-side endpoint methods (see HxEndpoint); its templates point at them with self path: #edit:.

Components are built anew for every request and keep no state between requests.
"
Class {
	#name : 'HxComponent',
	#superclass : 'Object',
	#instVars : [
		'html'
	],
	#category : 'PharoHtmx-Razor-Components',
	#package : 'PharoHtmx-Razor',
	#tag : 'Components'
}

{ #category : 'compiling' }
HxComponent class >> compilerClass [
	"The render methods of my subclasses are Razor views, their other methods plain Smalltalk; I myself am plain Smalltalk."

	^ self == HxComponent
		  ifTrue: [ Object compilerClass ]
		  ifFalse: [ HxRazorCompiler ]
]

{ #category : 'routing' }
HxComponent class >> endpoints [
	"The endpoints in my class-side methods; see HxEndpoint."

	^ HxEndpoint allIn: self
]

{ #category : 'compiling' }
HxComponent class >> formatter [
	"Views are re-indented as Razor source; plain Smalltalk methods are formatted as usual."

	^ HxRazorFormatter new
]

{ #category : 'routing' }
HxComponent class >> pathOf: anAction [
	"The path of my endpoint anAction, as in HxSpikeClock pathOf: #tick:."

	^ (HxEndpoint in: self selector: anAction) path
]

{ #category : 'routing' }
HxComponent class >> pathOf: anAction with: anObject [
	"The path of my endpoint anAction with its parameters filled in, as in HxSpikeTodoItem pathOf: #delete: with: todo id."

	^ (HxEndpoint in: self selector: anAction) pathWith: anObject
]

{ #category : 'converting' }
HxComponent >> asZnResponse [
	"Answer me as an HTML response, so a route or page can answer a component."

	^ ZnResponse ok: (ZnEntity html: self toHtml)
]

{ #category : 'accessing' }
HxComponent >> contents [
	"Answer the HTML written so far."

	^ html contents
]

{ #category : 'htmx' }
HxComponent >> hx [
	"New htmx attributes for an element of mine, to build with a cascade in a view; #action: names my endpoints. See HxHtmxAttributes.
		<button {{ self hx
		             action: #edit:;
		             swapOuter }}>Edit</button>"

	^ HxHtmxAttributes for: self class
]

{ #category : 'initialization' }
HxComponent >> initialize [

	super initialize.
	html := HxHtmlWriter new
]

{ #category : 'routing' }
HxComponent >> path: anAction [
	"The path of my endpoint anAction, as in self path: #edit: for the class-side method edit:."

	^ self class pathOf: anAction
]

{ #category : 'routing' }
HxComponent >> path: anAction with: anObject [
	"The path of my endpoint anAction with its parameters filled in, as in self path: #delete: with: todo id."

	^ self class pathOf: anAction with: anObject
]

{ #category : 'rendering' }
HxComponent >> render [
	"Write me. In a subclass this is a Razor view."

	self subclassResponsibility
]

{ #category : 'rendering' }
HxComponent >> render: aComponent [
	"Write aComponent into my HTML, as a child of mine."

	aComponent
		setHtml: html;
		render
]

{ #category : 'initialization' }
HxComponent >> setHtml: anHtmlWriter [

	html := anHtmlWriter
]

{ #category : 'rendering' }
HxComponent >> toHtml [
	"Render me and answer the HTML."

	self render.
	^ self contents
]

{ #category : 'rendering' }
HxComponent >> writeHtmlOn: anHtmlWriter [
	"Render me where a {{ }} stands for me in a view: {{ HxSpikeTodoItem todo: todo }}."

	self
		setHtml: anHtmlWriter;
		render
]
