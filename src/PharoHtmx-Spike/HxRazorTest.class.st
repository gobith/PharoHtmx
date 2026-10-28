"
I test Razor-style view methods: translating, compiling and rendering them, and refusing source that Tonel would misread.
"
Class {
	#name : 'HxRazorTest',
	#superclass : 'TestCase',
	#instVars : [
		'views'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'helpers' }
HxRazorTest >> books [

	^ {
		  (HxSpikeBook
			   id: 1
			   title: 'Guards! Guards!'
			   price: 1299
			   available: true).
		  (HxSpikeBook
			   id: 2
			   title: 'Mort'
			   price: 1099
			   available: false) }
]

{ #category : 'helpers' }
HxRazorTest >> errorIn: aSource [
	"Compile aSource and answer the first error: its position in aSource and its message."

	^ [
		  HxSpikeBookViews compile: aSource classified: 'test'.
		  nil ]
		  on: OCCompilationError
		  do: [ :error |
				  | notice |
				  notice := error compilationResult ast allErrorNotices first.
				  notice position -> notice messageText ]
]

{ #category : 'helpers' }
HxRazorTest >> render: aSource [
	"Compile aSource into the example view class, render it and remove it again."

	^ self render: aSource withArguments: #(  )
]

{ #category : 'helpers' }
HxRazorTest >> render: aSource withArguments: anArray [

	| selector |
	selector := HxSpikeBookViews compile: aSource classified: 'test'.
	^ [
		  (HxSpikeBookViews new
			   perform: selector withArguments: anArray;
			   yourself) contents ] ensure: [ HxSpikeBookViews removeSelector: selector ]
]

{ #category : 'tests' }
HxRazorTest >> testCallOtherView [

	| html |
	html := self
		        render: 'testView: books
<main>
@self bookList: books
</main>'
		        withArguments: { self books }.
	self assert: (html beginsWith: '<main>').
	self assert: (html includesSubstring: '<ul id="book-list">').
	self assert: (html includesSubstring: 'In mandje').
	self assert: (html includesSubstring: 'Uitverkocht')
]

{ #category : 'tests' }
HxRazorTest >> testCssStyling [

	| text colorAt source styler |
	source := (HxSpikeBookViews >> #layout:cart:with:) sourceCode.
	styler := SHRBTextStyler new.
	text := (SHRBTextStyler new
		         classOrMetaClass: HxSpikeBookViews;
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
HxRazorTest >> testDebuggerHighlightsTheRazorSource [
	"Each place the debugger stops at maps to the HTML, {{ }} or Smalltalk it stands for."

	| selector method source highlighted |
	selector := HxSpikeBookViews
		            compile: 'testView: book
<p class="title">{{ book title }}</p>
@self addButton: book
<hr>' withInternalLineEndings
		            classified: 'test'.
	[
		method := HxSpikeBookViews >> selector.
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
		self assert: (highlighted includes: 'addButton: book') ] ensure: [ HxSpikeBookViews removeSelector: selector ]
]

{ #category : 'tests' }
HxRazorTest >> testDebuggerStackShowsBlocksInRazor [

	| block stream |
	block := (HxSpikeBookViews >> #bookList:) literals detect: [ :each | each isCompiledBlock ].
	stream := WriteStream on: String new.
	StContextPrinter printMethod: block on: stream.
	self assert: (stream contents beginsWith: '>>[ :book |').
	self assert: (stream contents includesSubstring: '<li>').
	self deny: (stream contents includesSubstring: 'html raw:')
]

{ #category : 'tests' }
HxRazorTest >> testErrorPositionsAreInTheRazorSource [

	| source error |
	source := 'testView: books
<ul>@books do: [ :book | <li>{{ book title: }}</li> ]</ul>'.
	error := self errorIn: source.
	self assert: (source copyFrom: error key to: error key + 1) equals: '}}'.
	source := 'testView
<p>{{ 1 + 2 </p>'.
	error := self errorIn: source.
	self assert: (source copyFrom: error key to: error key + 1) equals: '{{'
]

{ #category : 'tests' }
HxRazorTest >> testErrors [

	self
		should: [
				self render: 'testView
<p>{{ 1 + </p>' ]
		raise: OCCompilationError.
	self
		should: [
				self render: 'testView
@#( 1 ) do: [ :each | <li>{{ each }} ]' ]
		raise: OCCompilationError
]

{ #category : 'tests' }
HxRazorTest >> testExpressionIsEscaped [

	self
		assert: (self render: 'testView
<p title="{{ ''a "b"'' }}">{{ ''<b>&'' }} {{ 3 + 4 }}</p>')
		equals: '<p title="a &quot;b&quot;">&lt;b&gt;&amp; 7</p>'
]

{ #category : 'tests' }
HxRazorTest >> testHtmlAndCodeLinesInBlock [

	self
		assert: (self render: 'testView
@#( 1 2 ) do: [ :each |
  <b>{{ each }}</b>
  @self class name size
  <i>{{ each * 10 }}</i>
]')
		equals: '<b>1</b><i>10</i><b>2</b><i>20</i>'
]

{ #category : 'tests' }
HxRazorTest >> testIfTrueIfFalse [

	self
		assert: (self
				 render: 'testView: books
@books do: [ :book |
  @book isAvailable ifTrue: [ <b>{{ book id }}</b> ] ifFalse: [ <i>{{ book id }}</i> ]
]'
				 withArguments: { self books })
		equals: '<b>1</b><i>2</i>'
]

{ #category : 'tests' }
HxRazorTest >> testKeywordOnNextLineContinuesStatement [

	self
		assert: (self
				 render: 'testView: book
@book isAvailable
  ifTrue: [
    <b>ja</b>
  ]
  ifFalse: [
    <i>nee</i>
  ]
<p>klaar</p>'
				 withArguments: { self books first })
		equals: '<b>ja</b>
<p>klaar</p>' withInternalLineEndings
]

{ #category : 'tests' }
HxRazorTest >> testLiteralAt [

	self
		assert: (self render: 'testView
<p>georges@soops.nl @@razor</p>')
		equals: '<p>georges@soops.nl @razor</p>'
]

{ #category : 'tests' }
HxRazorTest >> testLoop [

	self
		assert: (self
				 render: 'testView: books
<ul>@books do: [ :book | <li>{{ book title }}</li> ]</ul>'
				 withArguments: { self books })
		equals: '<ul><li>Guards! Guards!</li><li>Mort</li></ul>'
]

{ #category : 'tests' }
HxRazorTest >> testNestedElementsAndVoidElements [

	self
		assert: (self render: 'testView
@#( 1 2 ) do: [ :each | <div><div>{{ each }}</div><br><img src="x.png" /></div> ]')
		equals: '<div><div>1</div><br><img src="x.png" /></div><div><div>2</div><br><img src="x.png" /></div>'
]

{ #category : 'tests' }
HxRazorTest >> testPlainHtml [

	self
		assert: (self render: 'testView
<p class="x">Hallo</p>')
		equals: '<p class="x">Hallo</p>'
]

{ #category : 'tests' }
HxRazorTest >> testRefusesSourceTonelWouldMisread [

	#( '<p>Tom''s</p>' '<p>15" scherm</p>' '<p>[1</p>' '<p>einde]</p>' ) do: [ :body |
		self should: [ self render: 'testView' , String cr , body ] raise: OCCompilationError ].
	self
		assert: (self render: 'testView
<p>Tom’s &#91;1&#93;</p>')
		equals: '<p>Tom’s &#91;1&#93;</p>'
]

{ #category : 'tests' }
HxRazorTest >> testScriptContentIsRaw [

	self
		assert: (self render: 'testView
<script>if (a<b) { x = "@y" + {{ 1 + 1 }} }</script>')
		equals: '<script>if (a<b) { x = "@y" + 2 }</script>'
]

{ #category : 'tests' }
HxRazorTest >> testSourceIsKept [

	| method |
	method := HxSpikeBookViews >> #bookList:.
	self assert: (method sourceCode includesSubstring: '@books do: [ :book |').
	self assert: (method messages includesAll: #( #do: #id #title #priceString #addButton: #raw: #text: ))
]

{ #category : 'tests' }
HxRazorTest >> testStyling [

	| text colorAt source |
	source := (HxSpikeBookViews >> #addButton:) sourceCode.
	text := (SHRBTextStyler new
		         classOrMetaClass: HxSpikeBookViews;
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
HxRazorTest >> testTextLineIsNoKeyword [
	"Only a lowercase word with a colon that is not followed by = or / continues a statement."

	| html |
	html := self
		        render: 'testView: book
@book id
http://pharo.org
Prijs: 5'
		        withArguments: { self books first }.
	self assert: (html includesSubstring: 'http://pharo.org').
	self assert: (html includesSubstring: 'Prijs: 5')
]
