"
I translate the Razor-style source of a view method into Smalltalk source.

The first line is the Smalltalk message pattern; the rest is HTML:
- plain HTML is written as is (html raw: '...');
- {{ expr }} writes the value of a Smalltalk expression as escaped text (html text: (expr));
- @ starts a Smalltalk statement that runs to the end of the line on which all brackets are closed. @@ is a literal @, and so is an @ right after a letter or digit, as in an e-mail address;
- inside a block of such a statement, a <tag at the start of a statement is HTML again, up to its closing tag.

	bookList: books
	<ul>
	  @books do: [ :book |
	    <li>{{ book title }}</li>
	  ]
	</ul>

While translating I record, for every character of the Smalltalk I generate, the position in the Razor source it was copied from (0 when generated), and for every character of the Razor source what kind of thing it is (#smalltalk, #razor for {{ }} and @, #tag, #attributeName, #attributeValue, #comment or #text). HxRazorMethodNode uses both for syntax highlighting and for placing error messages.
"
Class {
	#name : 'HxRazorTranslator',
	#superclass : 'Object',
	#instVars : [
		'source',
		'pos',
		'output',
		'text',
		'map',
		'kinds',
		'events',
		'regions',
		'ranges',
		'textStart'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'translating' }
HxRazorTranslator class >> translate: aString [

	^ self new translate: aString
]

{ #category : 'accessing' }
HxRazorTranslator class >> voidElements [
	"HTML elements that have no content and no closing tag."

	^ #( 'area' 'base' 'br' 'col' 'embed' 'hr' 'img' 'input' 'link' 'meta' 'source' 'track' 'wbr' )
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> atContinuationLine [
	"At a line end: answer whether the next line that is not blank starts with a keyword (ifTrue:, do:), so that the statement goes on there. A keyword starts with a lowercase letter and is not followed by = or / (a URL is no keyword)."

	| index |
	index := pos.
	[ index <= source size and: [ (source at: index) isSeparator ] ] whileTrue: [ index := index + 1 ].
	(index <= source size and: [ (source at: index) isLowercase ]) ifFalse: [ ^ false ].
	[ index <= source size and: [ (source at: index) isAlphaNumeric or: [ (source at: index) = $_ ] ] ] whileTrue: [
		index := index + 1 ].
	(index <= source size and: [ (source at: index) = $: ]) ifFalse: [ ^ false ].
	^ (':=/' includes: (source at: index + 1 ifAbsent: [ $  ])) not
]

{ #category : 'reading' }
HxRazorTranslator >> atEnd [

	^ pos > source size
]

{ #category : 'reading' }
HxRazorTranslator >> atLineEnd [

	^ self atEnd or: [ self peek = Character cr or: [ self peek = Character lf ] ]
]

{ #category : 'reading' }
HxRazorTranslator >> atString: aString [

	aString withIndexDo: [ :char :index | (self peekAt: index - 1) = char ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'testing' }
HxRazorTranslator >> atTag [

	^ self peek = $< and: [ (self peekAt: 1) ifNil: [ false ] ifNotNil: [ :char | char isLetter or: [ '/!' includes: char ] ] ]
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> copyBlockParameters [
	"Right after [: copy the block parameters (:a :b |) and temporaries (| t |), if any."

	self copySeparators.
	self peek = $: ifTrue: [
			[ self atEnd or: [ '|]' includes: self peek ] ] whileFalse: [ self copyNext ].
			self peek = $| ifTrue: [ self copyNext ].
			self copySeparators ].
	self peek = $| ifTrue: [
			self copyNext.
			[ self atEnd or: [ self peek = $| ] ] whileFalse: [ self copyNext ].
			self atEnd ifFalse: [ self copyNext ] ]
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> copyLiteral [
	"At ', double quote or $: copy a string, comment or character literal unchanged."

	| start delimiter char |
	start := pos.
	delimiter := self peek.
	self copyNext.
	delimiter = $$ ifTrue: [
			self atEnd ifFalse: [ self copyNext ].
			^ self ].
	[
		self atEnd ifTrue: [ HxRazorError signal: 'Missing closing ' , delimiter asString at: start ].
		char := self peek.
		self copyNext.
		(char = $' and: [ delimiter = $' and: [ self peek = $' ] ])
			ifTrue: [
					self copyNext.
					false ]
			ifFalse: [ char = delimiter ] ] whileFalse.
	self region: start to: pos - 1 mode: #keep
]

{ #category : 'writing' }
HxRazorTranslator >> copyNext [
	"Copy the current source character to the output as Smalltalk."

	map add: pos.
	kinds at: pos put: #smalltalk.
	output nextPut: self next
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> copySeparators [

	[ self atEnd not and: [ self peek isSeparator ] ] whileTrue: [ self copyNext ]
]

{ #category : 'translating - css' }
HxRazorTranslator >> cssCommentAt: anIndex [

	^ (source at: anIndex) = $/ and: [ (source at: anIndex + 1 ifAbsent: [ nil ]) = $* ]
]

{ #category : 'translating - css' }
HxRazorTranslator >> cssStatementKindAt: aStart upTo: aStop [
	"A statement that opens a block is a selector, one that ends with ; or } is a declaration."

	| index char |
	index := aStart.
	[ index <= aStop ] whileTrue: [
			char := source at: index.
			(kinds at: index) = #text ifTrue: [
					char = ${ ifTrue: [ ^ #cssSelector ].
					(';}' includes: char) ifTrue: [ ^ #cssProperty ].
					('"''' includes: char) ifTrue: [ index := (source indexOf: char startingAt: index + 1) max: index ].
					(self cssCommentAt: index) ifTrue: [ index := (source indexOfSubCollection: '*/' startingAt: index + 2) max: index ] ].
			index := index + 1 ].
	^ #cssSelector
]

{ #category : 'writing' }
HxRazorTranslator >> emit: aString [
	"Write generated Smalltalk that has no counterpart in the source."

	output nextPutAll: aString.
	aString size timesRepeat: [ map add: 0 ]
]

{ #category : 'translating - css' }
HxRazorTranslator >> endsCssToken: anIndex kind: aKind [

	| char |
	(kinds at: anIndex) = #text ifFalse: [ ^ true ].
	char := source at: anIndex.
	char isSeparator ifTrue: [ ^ true ].
	('{};,()"''' includes: char) ifTrue: [ ^ true ].
	(char = $: and: [ aKind = #cssProperty or: [ aKind = #cssAtRule ] ]) ifTrue: [ ^ true ].
	^ self cssCommentAt: anIndex
]

{ #category : 'writing' }
HxRazorTranslator >> event: aPosition delta: anInteger stop: aStop name: aName [

	self
		event: aPosition
		delta: anInteger
		stop: aStop
		name: aName
		start: aPosition
]

{ #category : 'writing' }
HxRazorTranslator >> event: aPosition delta: anInteger stop: aStop name: aName start: aStart [

	events add: {
			aPosition.
			anInteger.
			aStop.
			aName.
			aStart }
]

{ #category : 'accessing' }
HxRazorTranslator >> events [
	"The nesting structure of the source, for the formatter: an Array { position. delta. stop. tag name or nil. start } for each opening tag or bracket (+1, at its last character) and each closing tag or bracket (-1, at its first character). Start and stop are the first and last character of the tag or bracket."

	^ events
]

{ #category : 'writing' }
HxRazorTranslator >> flushText [
	"Write the pending literal HTML as one raw: statement. The HTML started at textStart and ends right before the current position."

	| start |
	text position = 0 ifTrue: [ ^ self ].
	start := output position + 1.
	self emit: 'html raw: ' , text contents printString , '.'.
	ranges add: {
			start.
			output position.
			textStart.
			(pos - 1) }.
	self emit: String cr.
	text := WriteStream on: String new
]

{ #category : 'translating - html' }
HxRazorTranslator >> htmlStep [
	"Translate one piece of HTML. Answer the tag (kind -> name) when the piece was a tag, nil otherwise."

	(self atString: '{{') ifTrue: [ ^ self translateExpression ].
	self peek = $@ ifTrue: [ ^ self translateAt ].
	self atTag ifTrue: [ ^ self translateTag ].
	text nextPut: self next.
	^ nil
]

{ #category : 'translating - css' }
HxRazorTranslator >> isCssNumberAt: anIndex [

	| char next |
	char := source at: anIndex.
	next := source at: anIndex + 1 ifAbsent: [ $  ].
	char isDigit ifTrue: [ ^ true ].
	char = $# ifTrue: [ ^ true ].
	^ ('.-+' includes: char) and: [ next isDigit or: [ next = $. ] ]
]

{ #category : 'translating - html' }
HxRazorTranslator >> kindInTagOf: aCharacter quote: openQuote [
	"Inside a tag: quoted values are attribute values, words are attribute names."

	openQuote ifNotNil: [ ^ #attributeValue ].
	('"''' includes: aCharacter) ifTrue: [ ^ #attributeValue ].
	(aCharacter isSeparator or: [ '=/' includes: aCharacter ]) ifTrue: [ ^ #text ].
	^ #attributeName
]

{ #category : 'accessing' }
HxRazorTranslator >> kinds [
	"For each character of the Razor source, what kind of thing it is."

	^ kinds
]

{ #category : 'accessing' }
HxRazorTranslator >> map [
	"For each character of the generated Smalltalk, its position in the Razor source, or 0 when it was generated."

	^ map asArray
]

{ #category : 'writing' }
HxRazorTranslator >> mark: aKind [
	"Record the kind of the current source character and answer it, consuming it."

	kinds at: pos put: aKind.
	^ self next
]

{ #category : 'translating - css' }
HxRazorTranslator >> markCss: aKind from: aStart through: aDelimiter upTo: aStop [
	"Mark a comment or string, from aStart up to and including aDelimiter. Answer the position after it."

	| end stop |
	end := source indexOfSubCollection: aDelimiter startingAt: aStart + 1.
	stop := end = 0 | (end > aStop)
		        ifTrue: [ aStop ]
		        ifFalse: [ end + aDelimiter size - 1 ].
	aStart to: stop do: [ :index | (kinds at: index) = #text ifTrue: [ kinds at: index put: aKind ] ].
	^ stop + 1
]

{ #category : 'translating - css' }
HxRazorTranslator >> markCssFrom: aStart to: aStop [
	"Record the kinds of the CSS in a style element: selectors, properties, values, numbers, at-rules and comments. A {{ }} expression keeps its own kinds."

	| index kind char |
	index := aStart.
	kind := nil.
	[ index <= aStop ] whileTrue: [
			char := source at: index.
			((kinds at: index) ~= #text or: [ char isSeparator or: [ ',()' includes: char ] ])
				ifTrue: [ index := index + 1 ]
				ifFalse: [
						(self cssCommentAt: index)
							ifTrue: [
									index := self
										         markCss: #comment
										         from: index
										         through: '*/'
										         upTo: aStop ]
							ifFalse: [
									('{};' includes: char)
										ifTrue: [
												kind := nil.
												index := index + 1 ]
										ifFalse: [
												kind ifNil: [ kind := self cssStatementKindAt: index upTo: aStop ].
												(char = $: and: [ kind = #cssProperty ])
													ifTrue: [
															kind := #cssValue.
															index := index + 1 ]
													ifFalse: [
															char = $@
																ifTrue: [
																		kind = #cssProperty ifTrue: [ kind := #cssValue ].
																		index := self markCssToken: #cssAtRule from: index upTo: aStop ]
																ifFalse: [
																		('"''' includes: char)
																			ifTrue: [
																					index := self
																						         markCss: kind
																						         from: index
																						         through: char asString
																						         upTo: aStop ]
																			ifFalse: [ index := self markCssToken: kind from: index upTo: aStop ] ] ] ] ] ] ]
]

{ #category : 'translating - css' }
HxRazorTranslator >> markCssToken: aKind from: aStart upTo: aStop [
	"Mark one word of CSS; in a value, a word that is a number or a #colour is a number. Answer the position after it."

	| stop kind |
	stop := aStart.
	[ stop <= aStop and: [ (self endsCssToken: stop kind: aKind) not ] ] whileTrue: [ stop := stop + 1 ].
	stop = aStart ifTrue: [ ^ aStart + 1 ].
	kind := (aKind = #cssValue and: [ self isCssNumberAt: aStart ])
		        ifTrue: [ #cssNumber ]
		        ifFalse: [ aKind ].
	aStart to: stop - 1 do: [ :index | kinds at: index put: kind ].
	^ stop
]

{ #category : 'reading' }
HxRazorTranslator >> next [

	| char |
	char := source at: pos.
	pos := pos + 1.
	^ char
]

{ #category : 'reading' }
HxRazorTranslator >> peek [

	^ self peekAt: 0
]

{ #category : 'reading' }
HxRazorTranslator >> peekAt: anOffset [
	"Answer the character anOffset places after the current one, nil past the end."

	^ source at: pos + anOffset ifAbsent: [ nil ]
]

{ #category : 'accessing' }
HxRazorTranslator >> ranges [
	"The generated statements that stand for a piece of the source, for the debugger: an Array { generated start. generated stop. source start. source stop } for each html raw: (a piece of HTML) and html text: (a {{ }})."

	^ ranges
]

{ #category : 'writing' }
HxRazorTranslator >> region: aStart to: aStop mode: aSymbol [

	regions add: {
			aStart.
			aStop.
			aSymbol }
]

{ #category : 'accessing' }
HxRazorTranslator >> regions [
	"Source ranges the formatter treats specially: an Array { start. stop. mode }. Mode #keep is copied as is (literals), #shift moves along with its first line (comments, script), #css is the content of a style element, and #continue marks a tag or statement whose later lines are continuation lines."

	^ regions
]

{ #category : 'translating' }
HxRazorTranslator >> translate: aString [

	source := aString.
	pos := 1.
	output := WriteStream on: String new.
	map := OrderedCollection new.
	kinds := Array new: source size withAll: #text.
	events := OrderedCollection new.
	regions := OrderedCollection new.
	ranges := OrderedCollection new.
	text := WriteStream on: String new.
	self translateHeader.
	textStart := pos.
	[ self atEnd ] whileFalse: [ self htmlStep ].
	self flushText.
	^ output contents
]

{ #category : 'translating - html' }
HxRazorTranslator >> translateAt [
	"At @: @@ and an @ inside a word are literal; any other @ starts a Smalltalk statement."

	(self peekAt: 1) = $@ ifTrue: [
			text nextPut: $@.
			pos := pos + 2.
			^ nil ].
	(pos > 1 and: [ (source at: pos - 1) isAlphaNumeric ]) ifTrue: [
			text nextPut: self next.
			^ nil ].
	self flushText.
	self mark: #razor.
	self translateStatement.
	^ nil
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> translateElement [
	"At a <tag inside a block: translate HTML up to and including the matching closing tag."

	| start tag name depth |
	start := pos.
	textStart := pos.
	tag := self translateTag.
	(tag isNotNil and: [ tag key = #open ]) ifTrue: [
			name := tag value.
			depth := 1.
			[ depth > 0 ] whileTrue: [
					self atEnd ifTrue: [ HxRazorError signal: 'Missing </' , name , '> for this tag' at: start ].
					tag := self htmlStep.
					(tag isNotNil and: [ tag value = name ]) ifTrue: [
							tag key = #open ifTrue: [ depth := depth + 1 ].
							tag key = #close ifTrue: [ depth := depth - 1 ] ] ] ].
	self flushText
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> translateExpression [
	"At {{: write the Smalltalk expression up to }} as escaped text."

	| end start generatedStart |
	end := source indexOfSubCollection: '}}' startingAt: pos + 2.
	end = 0 ifTrue: [ HxRazorError signal: 'Missing }} for this {{' at: pos ].
	self region: pos to: end + 1 mode: #continue.
	self flushText.
	start := pos.
	self
		mark: #razor;
		mark: #razor.
	generatedStart := output position + 1.
	self emit: 'html text: ('.
	[ pos < end ] whileTrue: [ self copyNext ].
	self emit: ').'.
	ranges add: {
			generatedStart.
			output position.
			start.
			(end + 1) }.
	self emit: String cr.
	self
		mark: #razor;
		mark: #razor.
	textStart := pos.
	^ nil
]

{ #category : 'translating' }
HxRazorTranslator >> translateHeader [
	"The first line is the Smalltalk message pattern; the line break after it is not part of the HTML."

	[ self atLineEnd ] whileFalse: [ self copyNext ].
	self emit: String cr.
	self peek = Character cr ifTrue: [ pos := pos + 1 ].
	self peek = Character lf ifTrue: [ pos := pos + 1 ]
]

{ #category : 'translating - html' }
HxRazorTranslator >> translateRawTextOf: aName [
	"Inside script and style only {{ }} is special, up to and including the closing tag."

	| start closing |
	start := pos.
	closing := '</' , aName.
	[
		self atEnd ifTrue: [ HxRazorError signal: 'Missing </' , aName , '>' at: start ].
		(self atString: closing) and: [ ((self peekAt: closing size) ifNil: [ $> ]) isAlphaNumeric not ] ] whileFalse: [
			(self atString: '{{')
				ifTrue: [ self translateExpression ]
				ifFalse: [ text nextPut: self next ] ].
	aName = 'style'
		ifTrue: [
				self region: start to: pos - 1 mode: #css.
				self markCssFrom: start to: pos - 1 ]
		ifFalse: [ self region: start to: pos - 1 mode: #shift ].
	[ self atEnd or: [ self peek = $> ] ] whileFalse: [ text nextPut: (self mark: #tag) ].
	self atEnd ifFalse: [ text nextPut: (self mark: #tag) ]
]

{ #category : 'translating - smalltalk' }
HxRazorTranslator >> translateStatement [
	"After @: copy Smalltalk until all brackets are closed and the line ends or a tag starts. When the next line starts with a keyword (ifTrue:, ifFalse:) the statement goes on there.
	Inside a block, a <tag at the start of a statement is HTML up to its closing tag, a {{ }} there is written as in HTML, and an @ there is ignored.
	A line inside a block that starts with a <tag, {{ or @ starts a new statement, even without a period."

	| start depth atStatementStart afterLineBreak last |
	start := pos.
	depth := 0.
	atStatementStart := false.
	afterLineBreak := false.
	[ self atEnd or: [ depth = 0 and: [ self atTag or: [ self atLineEnd and: [ self atContinuationLine not ] ] ] ] ] whileFalse: [
			| char |
			char := self peek.
			(atStatementStart not and: [ depth > 0 and: [ afterLineBreak and: [ char = $@ or: [ self atTag or: [ self atString: '{{' ] ] ] ] ]) ifTrue: [
					self emit: '.'.
					atStatementStart := true ].
			(atStatementStart and: [ depth > 0 and: [ self atTag or: [ self atString: '{{' ] ] ])
				ifTrue: [
						(self atString: '{{')
							ifTrue: [
									textStart := pos.
									self translateExpression ]
							ifFalse: [ self translateElement ].
						afterLineBreak := false.
						last := $. ]
				ifFalse: [
						(char isSeparator or: [ atStatementStart and: [ char = $@ ] ])
							ifTrue: [
									(char = Character cr or: [ char = Character lf ]) ifTrue: [ afterLineBreak := true ].
									char = $@
										ifTrue: [ self mark: #razor ]
										ifFalse: [ self copyNext ] ]
							ifFalse: [
									atStatementStart := false.
									afterLineBreak := false.
									last := char.
									('''"$' includes: char)
										ifTrue: [ self copyLiteral ]
										ifFalse: [
												('([{' includes: char) ifTrue: [
														depth := depth + 1.
														self
															event: pos
															delta: 1
															stop: pos
															name: nil ].
												(')]}' includes: char) ifTrue: [
														depth := depth - 1.
														self
															event: pos
															delta: -1
															stop: pos
															name: nil ].
												depth < 0 ifTrue: [ HxRazorError signal: 'Unexpected ' , char asString at: pos ].
												self copyNext.
												char = $[ ifTrue: [
														self copyBlockParameters.
														atStatementStart := true ].
												char = $. ifTrue: [ atStatementStart := true ] ] ] ] ].
	depth > 0 ifTrue: [ HxRazorError signal: 'Missing closing bracket in this statement' at: start ].
	last = $. ifFalse: [ self emit: '.' ].
	self emit: String cr.
	self region: start - 1 to: pos - 1 mode: #continue.
	textStart := pos
]

{ #category : 'translating - html' }
HxRazorTranslator >> translateTag [
	"At <: copy one tag, with {{ }} allowed in attribute values. Answer #open, #close or #complete -> tag name.
	A void or self-closing element, and a script or style element with its content, are #complete."

	| start closing name quote last |
	start := pos.
	(self peekAt: 1) = $! ifTrue: [
			[ self atEnd or: [ self peek = $> ] ] whileFalse: [ text nextPut: (self mark: #comment) ].
			self atEnd ifFalse: [ text nextPut: (self mark: #comment) ].
			self region: start to: pos - 1 mode: #shift.
			^ nil ].
	closing := (self peekAt: 1) = $/.
	text nextPut: (self mark: #tag).
	closing ifTrue: [ text nextPut: (self mark: #tag) ].
	name := WriteStream on: String new.
	[ self atEnd not and: [ self peek isAlphaNumeric or: [ '-:' includes: self peek ] ] ] whileTrue: [
			name nextPut: self peek.
			text nextPut: (self mark: #tag) ].
	name := name contents asLowercase.
	[
		self atEnd ifTrue: [ HxRazorError signal: 'Missing > for the tag <' , name at: start ].
		quote isNil and: [ self peek = $> ] ] whileFalse: [
			(self atString: '{{')
				ifTrue: [ self translateExpression ]
				ifFalse: [
						last := self peek.
						text nextPut: (self mark: (self kindInTagOf: last quote: quote)).
						quote ifNil: [ ('"''' includes: last) ifTrue: [ quote := last ] ] ifNotNil: [ last = quote ifTrue: [ quote := nil ] ] ] ].
	last = $/ ifTrue: [ kinds at: pos - 1 put: #tag ].
	text nextPut: (self mark: #tag).
	self region: start to: pos - 1 mode: #continue.
	closing ifTrue: [
			self
				event: start
				delta: -1
				stop: pos - 1
				name: name.
			^ #close -> name ].
	(last = $/ or: [ self class voidElements includes: name ]) ifTrue: [ ^ #complete -> name ].
	(#( 'script' 'style' ) includes: name) ifTrue: [
			self translateRawTextOf: name.
			^ #complete -> name ].
	self
		event: pos - 1
		delta: 1
		stop: pos - 1
		name: name
		start: start.
	^ #open -> name
]
