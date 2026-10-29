"
I test Razor-style view methods: translating, compiling and rendering them, and refusing source that Tonel would misread.
"
Class {
	#name : 'GeoRazorTest',
	#superclass : 'TestCase',
	#instVars : [
		'views'
	],
	#category : 'GeoRazor-Tests-Tests',
	#package : 'GeoRazor-Tests',
	#tag : 'Tests'
}

{ #category : 'helpers' }
GeoRazorTest >> books [

	^ {
		  (GeoRazorExampleBook
			   id: 1
			   title: 'Guards! Guards!'
			   price: 1299
			   available: true).
		  (GeoRazorExampleBook
			   id: 2
			   title: 'Mort'
			   price: 1099
			   available: false) }
]

{ #category : 'helpers' }
GeoRazorTest >> errorIn: aSource [
	"Compile aSource and answer the first error: its position in aSource and its message."

	^ [
		  GeoRazorExampleViews compile: aSource classified: 'test'.
		  nil ]
		  on: OCCompilationError
		  do: [ :error |
				  | notice |
				  notice := error compilationResult ast allErrorNotices first.
				  notice position -> notice messageText ]
]

{ #category : 'helpers' }
GeoRazorTest >> render: aSource [
	"Compile aSource into the example view class, render it and remove it again."

	^ self render: aSource withArguments: #(  )
]

{ #category : 'helpers' }
GeoRazorTest >> render: aSource withArguments: anArray [

	| selector |
	selector := GeoRazorExampleViews compile: aSource classified: 'test'.
	^ [
		  (GeoRazorExampleViews new
			   perform: selector withArguments: anArray;
			   yourself) contents ] ensure: [ GeoRazorExampleViews removeSelector: selector ]
]

{ #category : 'tests' }
GeoRazorTest >> testCallOtherView [

	| html |
	html := self
		        render: 'renderTestView: books
<main>
@self renderBookList: books
</main>'
		        withArguments: { self books }.
	self assert: (html beginsWith: '<main>').
	self assert: (html includesSubstring: '<ul id="book-list">').
	self assert: (html includesSubstring: 'Add to cart').
	self assert: (html includesSubstring: 'Sold out')
]

{ #category : 'tests' }
GeoRazorTest >> testCssStyling [

	| text colorAt source styler |
	source := (GeoRazorExampleViews >> #renderLayout:cart:with:) sourceCode.
	styler := SHRBTextStyler new.
	text := (SHRBTextStyler new
		         classOrMetaClass: GeoRazorExampleViews;
		         yourself) styledTextFor: source asText.
	colorAt := [ :aString |
	           (text attributesAt: (source indexOfSubCollection: aString))
		           detect: [ :each | each isKindOf: TextColor ]
		           ifNone: [ nil ] ].
	self assert: (colorAt value: 'header a {') equals: (styler attributesFor: #pragma) first.
	self assert: (colorAt value: 'font-family') equals: (styler attributesFor: #tempVar) first.
	self assert: (colorAt value: 'system-ui') equals: (styler attributesFor: #string) first.
	self assert: (colorAt value: '44rem') equals: (styler attributesFor: #number) first.
	self assert: (colorAt value: '#18181b') equals: (styler attributesFor: #number) first
]

{ #category : 'tests' }
GeoRazorTest >> testDebuggerHighlightsTheRazorSource [
	"Each place the debugger stops at maps to the HTML, {{ }} or Smalltalk it stands for."

	| selector method source highlighted |
	selector := GeoRazorExampleViews
		            compile: 'renderTestView: book
<p class="title">{{ book title }}</p>
@self renderAddButton: book
<hr>' withInternalLineEndings
		            classified: 'test'.
	[
		method := GeoRazorExampleViews >> selector.
		source := method sourceCode.
		highlighted := method symbolicBytecodes
			               select: [ :bytecode | method debugInfo shouldStopAt: bytecode offset ]
			               thenCollect: [ :bytecode |
					               | range |
					               range := method debugInfo rangeForPC: bytecode offset.
					               source copyFrom: range first to: range last ].
		self assert: (highlighted includes: '<p class="title">').
		self assert: (highlighted includes: '{{ book title }}').
		self assert: (highlighted includes: '</p>' , String cr).
		self assert: (highlighted includes: 'renderAddButton: book') ] ensure: [ GeoRazorExampleViews removeSelector: selector ]
]

{ #category : 'tests' }
GeoRazorTest >> testDebuggerStackShowsBlocksInRazor [

	| block stream |
	block := (GeoRazorExampleViews >> #renderBookList:) literals detect: [ :each | each isCompiledBlock ].
	stream := WriteStream on: String new.
	StContextPrinter printMethod: block on: stream.
	self assert: (stream contents beginsWith: '>>[ :book |').
	self assert: (stream contents includesSubstring: '<li>').
	self deny: (stream contents includesSubstring: 'html raw:')
]

{ #category : 'tests' }
GeoRazorTest >> testErrorPositionsAreInTheRazorSource [

	| source error |
	source := 'renderTestView: books
<ul>@books do: [ :book | <li>{{ book title: }}</li> ]</ul>'.
	error := self errorIn: source.
	self assert: (source copyFrom: error key to: error key + 1) equals: '}}'.
	source := 'renderTestView
<p>{{ 1 + 2 </p>'.
	error := self errorIn: source.
	self assert: (source copyFrom: error key to: error key + 1) equals: '{{'
]

{ #category : 'tests' }
GeoRazorTest >> testErrors [

	self
		should: [
				self render: 'renderTestView
<p>{{ 1 + </p>' ]
		raise: OCCompilationError.
	self
		should: [
				self render: 'renderTestView
@#( 1 ) do: [ :each | <li>{{ each }} ]' ]
		raise: OCCompilationError
]

{ #category : 'tests' }
GeoRazorTest >> testExpressionAsStatementInBlock [
	"Inside a block, a {{ }} at the start of a statement is written as in HTML."

	self
		assert: (self
				 render: 'renderTestView: books
<ul>
  @books do: [ :book |
    {{ book title }}
  ]
</ul>'
				 withArguments: { self books }) withInternalLineEndings
		equals: '<ul>
  Guards! Guards!Mort
</ul>' withInternalLineEndings
]

{ #category : 'tests' }
GeoRazorTest >> testExpressionIsEscaped [

	self
		assert: (self render: 'renderTestView
<p title="{{ ''a "b"'' }}">{{ ''<b>&'' }} {{ 3 + 4 }}</p>')
		equals: '<p title="a &quot;b&quot;">&lt;b&gt;&amp; 7</p>'
]

{ #category : 'tests' }
GeoRazorTest >> testHtmlAndCodeLinesInBlock [

	self
		assert: (self render: 'renderTestView
@#( 1 2 ) do: [ :each |
  <b>{{ each }}</b>
  @self class name size
  <i>{{ each * 10 }}</i>
]')
		equals: '<b>1</b><i>10</i><b>2</b><i>20</i>'
]

{ #category : 'tests' }
GeoRazorTest >> testIfTrueIfFalse [

	self
		assert: (self
				 render: 'renderTestView: books
@books do: [ :book |
  @book isAvailable ifTrue: [ <b>{{ book id }}</b> ] ifFalse: [ <i>{{ book id }}</i> ]
]'
				 withArguments: { self books })
		equals: '<b>1</b><i>2</i>'
]

{ #category : 'tests' }
GeoRazorTest >> testKeywordOnNextLineContinuesStatement [

	self
		assert: (self
				 render: 'renderTestView: book
@book isAvailable
  ifTrue: [
    <b>yes</b>
  ]
  ifFalse: [
    <i>no</i>
  ]
<p>klaar</p>'
				 withArguments: { self books first })
		equals: '<b>yes</b>
<p>klaar</p>' withInternalLineEndings
]

{ #category : 'tests' }
GeoRazorTest >> testLiteralAt [

	self
		assert: (self render: 'renderTestView
<p>georges@soops.nl @@razor</p>')
		equals: '<p>georges@soops.nl @razor</p>'
]

{ #category : 'tests' }
GeoRazorTest >> testLoop [

	self
		assert: (self
				 render: 'renderTestView: books
<ul>@books do: [ :book | <li>{{ book title }}</li> ]</ul>'
				 withArguments: { self books })
		equals: '<ul><li>Guards! Guards!</li><li>Mort</li></ul>'
]

{ #category : 'tests' }
GeoRazorTest >> testNestedElementsAndVoidElements [

	self
		assert: (self render: 'renderTestView
@#( 1 2 ) do: [ :each | <div><div>{{ each }}</div><br><img src="x.png" /></div> ]')
		equals: '<div><div>1</div><br><img src="x.png" /></div><div><div>2</div><br><img src="x.png" /></div>'
]

{ #category : 'tests' }
GeoRazorTest >> testPlainHtml [

	self
		assert: (self render: 'renderTestView
<p class="x">Hello</p>')
		equals: '<p class="x">Hello</p>'
]

{ #category : 'tests' }
GeoRazorTest >> testRefusesSourceTonelWouldMisread [

	#( '<p>Tom''s</p>' '<p>15" scherm</p>' '<p>[1</p>' '<p>einde]</p>' ) do: [ :body |
		self should: [ self render: 'renderTestView' , String cr , body ] raise: OCCompilationError ].
	self
		assert: (self render: 'renderTestView
<p>Tom’s &#91;1&#93;</p>')
		equals: '<p>Tom’s &#91;1&#93;</p>'
]

{ #category : 'tests' }
GeoRazorTest >> testScriptContentIsRaw [

	self
		assert: (self render: 'renderTestView
<script>if (a<b) { x = "@y" + {{ 1 + 1 }} }</script>')
		equals: '<script>if (a<b) { x = "@y" + 2 }</script>'
]

{ #category : 'tests' }
GeoRazorTest >> testSourceIsKept [

	| method |
	method := GeoRazorExampleViews >> #renderBookList:.
	self assert: (method sourceCode includesSubstring: '@books do: [ :book |').
	self assert: (method messages includesAll: #( #do: #id #title #priceString #renderAddButton: #raw: #text: ))
]

{ #category : 'tests' }
GeoRazorTest >> testStyling [

	| text colorAt source |
	source := (GeoRazorExampleViews >> #renderAddButton:) sourceCode.
	text := (SHRBTextStyler new
		         classOrMetaClass: GeoRazorExampleViews;
		         yourself) styledTextFor: source asText.
	colorAt := [ :aString |
	           (text attributesAt: (source indexOfSubCollection: aString))
		           detect: [ :each | each isKindOf: TextColor ]
		           ifNone: [ nil ] ].
	self assert: (colorAt value: '<button') equals: (SHRBTextStyler new attributesFor: #pragma) first.
	self assert: (colorAt value: 'hx-post') equals: (SHRBTextStyler new attributesFor: #tempVar) first.
	self assert: (colorAt value: '"outerHTML"') equals: (SHRBTextStyler new attributesFor: #string) first.
	self assert: (colorAt value: '{{') equals: (SHRBTextStyler new attributesFor: #return) first.
	self assert: (colorAt value: 'book isAvailable') equals: (SHRBTextStyler new attributesFor: #argument) first
]

{ #category : 'tests' }
GeoRazorTest >> testTextLineIsNoKeyword [
	"Only a lowercase word with a colon that is not followed by = or / continues a statement."

	| html |
	html := self
		        render: 'renderTestView: book
@book id
http://pharo.org
Price: 5'
		        withArguments: { self books first }.
	self assert: (html includesSubstring: 'http://pharo.org').
	self assert: (html includesSubstring: 'Price: 5')
]
