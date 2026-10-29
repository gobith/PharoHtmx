"
I draw vertical guides in a code editor that shows a render method of a component (see GeoComponent), from each element or block that spans several lines down to its end, like the indent guides of VS Code. The pair around the cursor is drawn stronger, and when the cursor is in a tag, that tag and its partner are framed.

The pairs come from GeoRazorTranslator; I compute them again only when the text has changed. GeoRazorMethodNode>>styleWith: adds me to the editor when it styles a view.
"
Class {
	#name : 'GeoIndentGuideDecorator',
	#superclass : 'RubParagraphDecorator',
	#instVars : [
		'source',
		'pairs'
	],
	#category : 'GeoRazor-Editor',
	#package : 'GeoRazor',
	#tag : 'Editor'
}

{ #category : 'installing' }
GeoIndentGuideDecorator class >> installIn: aTextArea [

	(aTextArea hasDecoratorNamed: self key) ifFalse: [ aTextArea withDecorator: self new ]
]

{ #category : 'accessing' }
GeoIndentGuideDecorator class >> key [

	^ #hxIndentGuides
]

{ #category : 'drawing' }
GeoIndentGuideDecorator >> activeGuideColor [

	^ self theme textColor alpha: 0.5
]

{ #category : 'pairs' }
GeoIndentGuideDecorator >> activePairAt: anIndex [
	"The innermost pair spanning several lines with anIndex in it, or nil."

	anIndex ifNil: [ ^ nil ].
	^ (self pairs select: [ :pair | (self spansLines: pair) and: [ anIndex between: pair first and: (pair at: 4) + 1 ] ]) detectMax: [
		  :pair | pair first ]
]

{ #category : 'drawing' }
GeoIndentGuideDecorator >> drawGuideFor: aPair color: aColor on: aCanvas [
	"A line at the indentation of the line that opens the pair, from below that line to the top of the line that closes it. Character positions can be fractions; the canvas needs whole pixels."

	| line first x top bottom clip |
	line := self lines at: (self lineIndexOfCharacterIndex: aPair first).
	first := (line first to: line last) detect: [ :index | (self string at: index) isSeparator not ] ifNone: [ aPair first ].
	x := (self characterBlockForIndex: first) left rounded.
	top := (self characterBlockForIndex: first) bottom rounded.
	bottom := (self characterBlockForIndex: (aPair at: 3)) top rounded.
	clip := aCanvas clipRect.
	(bottom > top and: [ bottom >= clip top and: [ top <= clip bottom ] ]) ifFalse: [ ^ self ].
	aCanvas
		line: x @ top
		to: x @ (bottom - 1)
		width: 1
		color: aColor
]

{ #category : 'drawing' }
GeoIndentGuideDecorator >> drawGuidesOn: aCanvas [

	| cursor active |
	cursor := self paragraph pointIndex.
	active := self activePairAt: cursor.
	self pairs do: [ :pair |
			(self spansLines: pair) ifTrue: [
					self
						drawGuideFor: pair
						color: (pair == active
								 ifTrue: [ self activeGuideColor ]
								 ifFalse: [ self guideColor ])
						on: aCanvas ] ].
	(self tagPairAt: cursor) ifNotNil: [ :pair |
			self frameFrom: pair first + 1 size: (pair at: 5) size on: aCanvas.
			self frameFrom: (pair at: 3) + 2 size: (pair at: 5) size on: aCanvas ]
]

{ #category : 'drawing' }
GeoIndentGuideDecorator >> drawOn: aCanvas [
	"Draw before the text. A drawing error must never break the editor, so it only costs the guides."

	aCanvas isShadowDrawing ifTrue: [ ^ self ].
	[ self isShowingView ifTrue: [ self drawGuidesOn: aCanvas ] ]
		on: Error
		do: [ :error | "no guides this time" ]
]

{ #category : 'drawing' }
GeoIndentGuideDecorator >> frameFrom: aStart size: aSize on: aCanvas [
	"Frame a tag name the way the editor frames a matching bracket."

	| from to rect |
	aSize = 0 ifTrue: [ ^ self ].
	from := self characterBlockForIndex: aStart.
	to := self characterBlockForIndex: aStart + aSize - 1.
	from top = to top ifFalse: [ ^ self ].
	rect := from topLeft - (1 @ 0) corner: to bottomRight + (1 @ 1).
	aCanvas fillRectangle: rect color: RubTextSelectionColor oppositeDelimiterSelection backgroundColor.
	aCanvas frameRectangle: rect color: RubTextSelectionColor oppositeDelimiterSelection textColor
]

{ #category : 'drawing' }
GeoIndentGuideDecorator >> guideColor [

	^ self theme textColor alpha: 0.15
]

{ #category : 'testing' }
GeoIndentGuideDecorator >> isShowingView [
	"Whether the editor shows a render method of a component. The class is known to the Shout styler of the editor, which has no accessor for it."

	| class |
	class := self textArea shoutStyler ifNotNil: [ :decorator | decorator styler instVarNamed: #classOrMetaClass ].
	^ class isNotNil and: [ class compilerClass = GeoRazorCompiler and: [ GeoRazorParser isRazorSource: self textArea text asString ] ]
]

{ #category : 'pairs' }
GeoIndentGuideDecorator >> pairs [
	"The pairs of the current text, computed again only when the text has changed."

	| string |
	string := self string asString.
	string = source ifFalse: [
			source := string copy.
			pairs := self pairsFor: string ].
	^ pairs
]

{ #category : 'pairs' }
GeoIndentGuideDecorator >> pairsFor: aString [
	"Answer the elements and blocks in aString as { open start. open stop. close start. close stop. tag name or nil }. A view that is half typed still gives the pairs before the error."

	| translator stack result |
	translator := GeoRazorTranslator new.
	[ translator translate: aString ]
		on: Error
		do: [ :error | "keep the pairs found so far" ].
	stack := OrderedCollection new.
	result := OrderedCollection new.
	(translator events asArray sort: [ :a :b | a first <= b first ]) do: [ :event |
			(event at: 2) > 0
				ifTrue: [ stack add: event ]
				ifFalse: [
						| index open |
						index := stack findLast: [ :each | (each at: 4) = (event at: 4) ].
						index > 0 ifTrue: [
								open := stack at: index.
								stack removeLast: stack size - index + 1.
								result add: {
										(open at: 5).
										open first.
										event first.
										(event at: 3).
										(event at: 4) } ] ] ].
	^ result asArray
]

{ #category : 'pairs' }
GeoIndentGuideDecorator >> spansLines: aPair [

	^ (self lineIndexOfCharacterIndex: aPair first) < (self lineIndexOfCharacterIndex: (aPair at: 3))
]

{ #category : 'pairs' }
GeoIndentGuideDecorator >> tagPairAt: anIndex [
	"The element whose opening or closing tag has anIndex in it, or nil."

	anIndex ifNil: [ ^ nil ].
	^ self pairs
		  detect: [ :pair |
				  (pair at: 5) isNotNil and: [
					  (anIndex between: pair first and: (pair at: 2) + 1) or: [ anIndex between: (pair at: 3) and: (pair at: 4) + 1 ] ] ]
		  ifNone: [ nil ]
]
