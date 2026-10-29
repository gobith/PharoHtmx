"
Tests for HxRazorFormatter and the Format command in a code editor.
"
Class {
	#name : 'HxRazorFormatterTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'helpers' }
HxRazorFormatterTest >> assertLines: actual equals: expected [
	"Compare independent of line endings: literals in this class may come in with CR or LF."

	self assert: actual asString withInternalLineEndings equals: expected withInternalLineEndings
]

{ #category : 'helpers' }
HxRazorFormatterTest >> format: aString [

	^ HxRazorFormatter new formatRazorSource: aString
]

{ #category : 'tests' }
HxRazorFormatterTest >> testBestNodeIsFoundInTheRazorSource [

	| source ast position |
	source := (HxRazorExampleViews >> #renderBookList:) sourceCode.
	ast := HxRazorExampleViews compiler parse: source.
	position := source indexOfSubCollection: 'title'.
	self assert: (ast bestNodeFor: (position to: position)) selector equals: #title.
	position := source indexOfSubCollection: '<li>'.
	self assert: (ast bestNodeFor: (position to: position)) isNil
]

{ #category : 'tests' }
HxRazorFormatterTest >> testClosingAtLineStartDedents [

	self
		assertLines: (self format: 'item: book
@book isAvailable ifTrue: [
<b>{{ book title }}</b>
] ifFalse: [
<i>{{ book title }}</i>
]
<p>
text</p>')
		equals: 'item: book
@book isAvailable ifTrue: [
  <b>{{ book title }}</b>
] ifFalse: [
  <i>{{ book title }}</i>
]
<p>
  text</p>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testContinuationLines [

	self
		assertLines: (self format: 'search
<div>
<input type="search"
hx-get="/books"
hx-trigger="input">
@self total: (1
+ 2)
</div>')
		equals: 'search
<div>
  <input type="search"
    hx-get="/books"
    hx-trigger="input">
  @self total: (1
    + 2)
</div>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testEmptyStyleStaysOnOneLine [

	self
		assertLines: (self format: 'page
<div>
<style>  </style>
</div>')
		equals: 'page
<div>
  <style></style>
</div>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testFormatInTheEditor [
	"The Format command of a code editor uses the parser of the class (RubSmalltalkCodeMode>>parseSource:, patched)."

	| morph |
	morph := RubScrolledTextMorph new.
	morph beForSmalltalkCode.
	morph textArea editingMode classOrMetaClass: HxRazorExampleViews.
	morph setText: 'renderList: books
<ul>
@books do: [ :book |
<li>{{ book title }}</li>
]
</ul>' withInternalLineEndings.
	morph textArea formatMethodCode.
	self assertLines: morph text equals: 'renderList: books
<ul>
  @books do: [ :book |
    <li>{{ book title }}</li>
  ]
</ul>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testFormatsCssInStyle [

	self
		assertLines: (self format: 'page
<head>
<style>
body{color:red;margin : 0 auto}
th ,td,a:hover{ font-family:"A, B" , serif; background:url(data:x;y) }

/* uitleg */
@media (max-width: 600px) { .x { color: {{ color }} } }
</style>
</head>')
		equals: 'page
<head>
  <style>
    body {
      color: red;
      margin: 0 auto;
    }
    th, td, a:hover {
      font-family: "A, B", serif;
      background: url(data:x;y);
    }

    /* uitleg */
    @media (max-width: 600px) {
      .x {
        color: {{ color }};
      }
    }
  </style>
</head>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testIndentsElementsAndBlocks [

	self
		assertLines: (self format: 'renderList: books
		<ul>
@books do: [ :book |
<li>{{ book title }}</li>
     ]
</ul>   ')
		equals: 'renderList: books
<ul>
  @books do: [ :book |
    <li>{{ book title }}</li>
  ]
</ul>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testKeepsLiteralsAndPre [

	self
		assertLines: (self format: 'code
<div>
@self note: ''one
      two''
<pre>
  as
    is
</pre>
</div>')
		equals: 'code
<div>
  @self note: ''one
      two''
  <pre>
  as
    is
</pre>
</div>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testKeywordLinesAreAligned [

	self
		assertLines: (self format: 'item: book
<div>
@book isAvailable
ifTrue: [
<b>{{ book title }}</b>
]
ifFalse: [
<i>{{ book title }}</i>
]
</div>')
		equals: 'item: book
<div>
  @book isAvailable
    ifTrue: [
      <b>{{ book title }}</b>
    ]
    ifFalse: [
      <i>{{ book title }}</i>
    ]
</div>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testPlainSmalltalkIsFormattedAsUsual [

	| method |
	method := HxComponent >> #contents.
	self assert: (HxComponent formatter format: method ast) equals: (EFFormatter new format: method ast).
	method := HxSpikeAddButton >> #isAdded.
	self assert: (HxSpikeAddButton formatter format: method ast) equals: (EFFormatter new format: method ast).
	self assert: (HxRazorExampleViews class formatter isKindOf: HxRazorFormatter) not
]

{ #category : 'tests' }
HxRazorFormatterTest >> testScriptMovesWithItsTag [

	self
		assertLines: (self format: 'page
<body>
<script>
if (a) {
    b();
}
</script>
</body>')
		equals: 'page
<body>
  <script>
  if (a) {
      b();
  }
  </script>
</body>'
]

{ #category : 'tests' }
HxRazorFormatterTest >> testViewsAreFormattedAndKeepTheirMeaning [
	"Formatting only changes whitespace in the generated code, and formatting twice changes nothing."

	| withoutSeparators |
	withoutSeparators := [ :source | (HxRazorTranslator new translate: source) reject: [ :char | char isSeparator ] ].
	HxRazorExampleViews methods do: [ :method |
			| source formatted |
			source := method sourceCode.
			formatted := HxRazorFormatter new formatRazorSource: source.
			self assert: (withoutSeparators value: formatted) equals: (withoutSeparators value: source).
			self assert: (HxRazorFormatter new formatRazorSource: formatted) equals: formatted ]
]
