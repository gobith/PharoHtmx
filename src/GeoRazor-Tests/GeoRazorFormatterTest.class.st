"
Tests for GeoRazorFormatter and the Format command in a code editor.
"
Class {
	#name : 'GeoRazorFormatterTest',
	#superclass : 'TestCase',
	#category : 'GeoRazor-Tests-Tests',
	#package : 'GeoRazor-Tests',
	#tag : 'Tests'
}

{ #category : 'helpers' }
GeoRazorFormatterTest >> assertLines: actual equals: expected [
	"Compare independent of line endings: literals in this class may come in with CR or LF."

	self assert: actual asString withInternalLineEndings equals: expected withInternalLineEndings
]

{ #category : 'helpers' }
GeoRazorFormatterTest >> format: aString [

	^ GeoRazorFormatter new formatRazorSource: aString
]

{ #category : 'tests' }
GeoRazorFormatterTest >> testBestNodeIsFoundInTheRazorSource [

	| source ast position |
	source := (GeoRazorExampleViews >> #renderBookList:) sourceCode.
	ast := GeoRazorExampleViews compiler parse: source.
	position := source indexOfSubCollection: 'title'.
	self assert: (ast bestNodeFor: (position to: position)) selector equals: #title.
	position := source indexOfSubCollection: '<li>'.
	self assert: (ast bestNodeFor: (position to: position)) isNil
]

{ #category : 'tests' }
GeoRazorFormatterTest >> testCascadeInDoubleBraces [
	"The messages of a cascade in a {{ }} line up one level to the right of the expression."

	self
		assertLines: (self format: 'render
<span class="clock"
{{ self hx
action: #tick:;
swapOuter }}>
{{ self time }}
</span>')
		equals: 'render
<span class="clock"
  {{ self hx
       action: #tick:;
       swapOuter }}>
  {{ self time }}
</span>'
]

{ #category : 'tests' }
GeoRazorFormatterTest >> testClosingAtLineStartDedents [

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
GeoRazorFormatterTest >> testContinuationLines [

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
GeoRazorFormatterTest >> testEmptyStyleStaysOnOneLine [

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
GeoRazorFormatterTest >> testFormatInTheEditor [
	"The Format command of a code editor uses the parser of the class (RubSmalltalkCodeMode>>parseSource:, patched)."

	| morph |
	morph := RubScrolledTextMorph new.
	morph beForSmalltalkCode.
	morph textArea editingMode classOrMetaClass: GeoRazorExampleViews.
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
GeoRazorFormatterTest >> testFormatsCssInStyle [

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
GeoRazorFormatterTest >> testIndentsElementsAndBlocks [

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
GeoRazorFormatterTest >> testKeepsLiteralsAndPre [

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
GeoRazorFormatterTest >> testKeywordLineInBlock [
	"Inside a block, ifTrue: and ifFalse: go one level deeper than the statement they belong to."

	self
		assertLines: (self format: 'render
@a
ifTrue: [
@b
ifTrue: [
<b>x</b>
]
ifFalse: [
<i>y</i>
]
]')
		equals: 'render
@a
  ifTrue: [
    @b
      ifTrue: [
        <b>x</b>
      ]
      ifFalse: [
        <i>y</i>
      ]
  ]'
]

{ #category : 'tests' }
GeoRazorFormatterTest >> testKeywordLinesAreAligned [

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
GeoRazorFormatterTest >> testPlainSmalltalkIsFormattedAsUsual [

	| method |
	method := GeoComponent >> #contents.
	self assert: (GeoComponent formatter format: method ast) equals: (EFFormatter new format: method ast).
	method := GeoRazorExampleViews >> #titleOf:.
	self assert: (GeoRazorExampleViews formatter format: method ast) equals: (EFFormatter new format: method ast).
	self assert: (GeoRazorExampleViews class formatter isKindOf: GeoRazorFormatter) not
]

{ #category : 'tests' }
GeoRazorFormatterTest >> testScriptMovesWithItsTag [

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
GeoRazorFormatterTest >> testTemplatesKeepTheirFormat [
	"Format leaves every render method in the Geo packages as it is, so formatting never moves code around."

	(((PackageOrganizer default packages select: [ :package | package name beginsWith: 'Geo' ]) flatCollect: [ :package | package methods ]) select: [ :method |
		 (method methodClass inheritsFrom: GeoComponent) and: [ GeoRazorParser isRazorSource: method sourceCode ] ]) do: [ :method |
			| source |
			source := method sourceCode withInternalLineEndings.
			self assert: (self format: source) equals: source ]
]

{ #category : 'tests' }
GeoRazorFormatterTest >> testViewsAreFormattedAndKeepTheirMeaning [
	"Formatting only changes whitespace in the generated code, and formatting twice changes nothing."

	| withoutSeparators |
	withoutSeparators := [ :source | (GeoRazorTranslator new translate: source) reject: [ :char | char isSeparator ] ].
	GeoRazorExampleViews methods do: [ :method |
			| source formatted |
			source := method sourceCode.
			formatted := GeoRazorFormatter new formatRazorSource: source.
			self assert: (withoutSeparators value: formatted) equals: (withoutSeparators value: source).
			self assert: (GeoRazorFormatter new formatRazorSource: formatted) equals: formatted ]
]
