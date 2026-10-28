"
I format the CSS inside a style element of a view (see HxRazorFormatter): a rule opens a block, each declaration gets a line of its own and ends in a semicolon, a declaration is written as ""property: value"", and a comma is followed by one space. Strings, comments and {{ }} expressions are kept as they are, and one blank line between statements is kept.

I answer the lines as depth -> text; the caller indents them.
"
Class {
	#name : 'HxCssFormatter',
	#superclass : 'Object',
	#instVars : [
		'source',
		'pos',
		'lines',
		'buffer',
		'depth',
		'parens',
		'colon',
		'pendingSpace',
		'newlines'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'private' }
HxCssFormatter >> addLine: aString [
	"Add a line at the current depth, after a blank line if the source had one there, and start a new statement."

	(newlines > 1 and: [ lines notEmpty and: [ aString ~= '}' ] ]) ifTrue: [ lines add: depth -> '' ].
	lines add: depth -> aString.
	newlines := 0.
	self resetStatement
]

{ #category : 'private' }
HxCssFormatter >> atString: aString [

	^ (source copyFrom: pos to: (pos + aString size - 1 min: source size)) = aString
]

{ #category : 'private' }
HxCssFormatter >> close [

	self endStatementWith: ';'.
	depth := depth - 1 max: 0.
	self addLine: '}'
]

{ #category : 'private' }
HxCssFormatter >> comment [
	"A comment at the start of a statement gets a line of its own; elsewhere it stays in the statement."

	| text |
	text := self copyThrough: '*/'.
	buffer position = 0
		ifTrue: [ self addLine: text ]
		ifFalse: [ self put: text ]
]

{ #category : 'private' }
HxCssFormatter >> copyString [
	"Answer a quoted string from here, with backslash escapes."

	| start quote |
	start := pos.
	quote := source at: pos.
	pos := pos + 1.
	[ pos > source size or: [ (source at: pos) = quote ] ] whileFalse: [
			(source at: pos) = $\ ifTrue: [ pos := pos + 1 ].
			pos := pos + 1 ].
	pos := pos + 1 min: source size + 1.
	^ source copyFrom: start to: pos - 1
]

{ #category : 'private' }
HxCssFormatter >> copyThrough: aString [
	"Answer the source from here up to and including aString, or up to the end."

	| start end |
	start := pos.
	end := source indexOfSubCollection: aString startingAt: pos + aString size.
	pos := end = 0
		       ifTrue: [ source size + 1 ]
		       ifFalse: [ end + aString size ].
	^ source copyFrom: start to: pos - 1
]

{ #category : 'private' }
HxCssFormatter >> endStatementWith: aTerminator [
	"End the current statement; inside a block it is a declaration, written as property: value."

	| text |
	text := buffer contents.
	text isEmpty ifTrue: [ ^ self resetStatement ].
	(depth > 0 and: [ colon isNotNil ]) ifTrue: [
		text := (text first: colon - 1) trimRight , ': ' , (text allButFirst: colon) trimLeft ].
	self addLine: text , aTerminator
]

{ #category : 'formatting' }
HxCssFormatter >> linesFor: aString [
	"Answer the formatted lines of the CSS in aString as depth -> text."

	source := aString.
	pos := 1.
	lines := OrderedCollection new.
	depth := 0.
	newlines := 0.
	self resetStatement.
	[ pos > source size ] whileFalse: [ self step ].
	self endStatementWith: ''.
	^ lines
]

{ #category : 'private' }
HxCssFormatter >> open [

	| selector |
	selector := buffer contents.
	self addLine: (selector isEmpty
			 ifTrue: [ '{' ]
			 ifFalse: [ selector , ' {' ]).
	depth := depth + 1
]

{ #category : 'private' }
HxCssFormatter >> put: aString [
	"Add aString to the current statement, after one space if there was white space before it."

	(pendingSpace and: [ buffer position > 0 ]) ifTrue: [ buffer space ].
	pendingSpace := false.
	buffer nextPutAll: aString
]

{ #category : 'private' }
HxCssFormatter >> resetStatement [

	buffer := WriteStream on: String new.
	parens := 0.
	colon := nil.
	pendingSpace := false
]

{ #category : 'private' }
HxCssFormatter >> separator: aCharacter [

	pendingSpace := true.
	(buffer position = 0 and: [ aCharacter = Character cr or: [ aCharacter = Character lf ] ]) ifTrue: [ newlines := newlines + 1 ]
]

{ #category : 'private' }
HxCssFormatter >> step [

	| char |
	(self atString: '{{') ifTrue: [ ^ self put: (self copyThrough: '}}') ].
	(self atString: '/*') ifTrue: [ ^ self comment ].
	char := source at: pos.
	('"''' includes: char) ifTrue: [ ^ self put: self copyString ].
	pos := pos + 1.
	char isSeparator ifTrue: [ ^ self separator: char ].
	char = ${ ifTrue: [ ^ self open ].
	char = $} ifTrue: [ ^ self close ].
	(char = $; and: [ parens = 0 ]) ifTrue: [ ^ self endStatementWith: ';' ].
	char = $( ifTrue: [ parens := parens + 1 ].
	char = $) ifTrue: [ parens := parens - 1 max: 0 ].
	char = $, ifTrue: [ pendingSpace := false ].
	self put: char asString.
	(char = $: and: [ parens = 0 and: [ colon isNil ] ]) ifTrue: [ colon := buffer position ].
	char = $, ifTrue: [ pendingSpace := true ]
]
