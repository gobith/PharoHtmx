"
I format view methods (see HxView). A view method is not reformatted as Smalltalk but re-indented as Razor source: one level per open element and per open bracket of the Smalltalk code, one extra level for the continuation lines of a tag or statement. Smalltalk literals and pre and textarea content are kept as they are; comments, script and style move along with their first line. Anything that is not a view method is formatted by my superclass.

The structure comes from HxRazorTranslator (events and regions), so I indent exactly what the compiler sees.
"
Class {
	#name : 'HxRazorFormatter',
	#superclass : 'EFFormatter',
	#instVars : [
		'razor',
		'lines',
		'depths',
		'closers',
		'razorRegions',
		'shifts',
		'events',
		'stack',
		'lineLevels'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'private' }
HxRazorFormatter >> analyze: aTranslator [
	"Collect the lines, the events in source order, the nesting depth before each position, the closing tags and brackets by position, and the regions."

	| start |
	lines := OrderedCollection new.
	start := 1.
	razor withIndexDo: [ :char :index |
			char = Character cr ifTrue: [
					lines add: (start to: index - 1).
					start := index + 1 ] ].
	lines add: (start to: razor size).
	events := aTranslator events asArray sort: [ :a :b | a first <= b first ].
	depths := Array new: razor size + 1 withAll: 0.
	closers := Dictionary new.
	events do: [ :event |
			(event at: 2) < 0 ifTrue: [ closers at: event first put: event ].
			depths at: event first + 1 put: (depths at: event first + 1) + (event at: 2) ].
	2 to: depths size do: [ :index | depths at: index put: (depths at: index) + (depths at: index - 1) ].
	razorRegions := aTranslator regions copy.
	events do: [ :open |
			((open at: 2) > 0 and: [ #( 'pre' 'textarea' ) includes: (open at: 4) ]) ifTrue: [
					events
						detect: [ :close | (close at: 2) < 0 and: [ (close at: 4) = (open at: 4) and: [ close first > open first ] ] ]
						ifFound: [ :close |
								razorRegions add: {
										open first.
										close first.
										#keep } ] ] ]
]

{ #category : 'private' }
HxRazorFormatter >> applyEventsFrom: aStart to: aStop [
	"An element or bracket opened here gets its content one level deeper than the line it starts on."

	events do: [ :event |
			(event first between: aStart and: aStop) ifTrue: [
					(event at: 2) > 0
						ifTrue: [ stack add: (lineLevels at: (self lineIndexOf: (event at: 5))) + 1 ]
						ifFalse: [ self pop ] ] ]
]

{ #category : 'private' }
HxRazorFormatter >> continuationAt: aPosition [
	"The innermost tag or statement that started before aPosition and still goes on there."

	^ (razorRegions select: [ :region |
		   (region at: 3) = #continue and: [ region first < aPosition and: [ aPosition <= (region at: 2) ] ] ]) detectMax: [ :region |
		  region first ]
]

{ #category : 'private' }
HxRazorFormatter >> depthAt: aPosition [

	^ depths at: (aPosition min: depths size)
]

{ #category : 'private' }
HxRazorFormatter >> firstNonSeparatorFrom: aStart to: aStop [

	^ (aStart to: aStop) detect: [ :index | (razor at: index) isSeparator not ] ifNone: [ nil ]
]

{ #category : 'public interface' }
HxRazorFormatter >> format: aParseTree [
	"View methods are re-indented as Razor source; anything else is formatted as Smalltalk."

	(aParseTree isKindOf: HxRazorMethodNode) ifFalse: [ ^ super format: aParseTree ].
	^ self formatRazorSource: aParseTree razorSource
]

{ #category : 'private' }
HxRazorFormatter >> formatLine: anInterval at: anIndex [
	"The first line is the message pattern. A line that starts inside a literal, pre or textarea is kept; one inside a comment or script moves as far as the line where that started. Any other line is indented one level deeper than the line that opened its element or bracket; a closing tag or bracket at the start goes back to the level of that line, and a continuation line of a tag or statement goes one level deeper than where that started."

	| line position level region |
	line := razor copyFrom: anInterval first to: anInterval last.
	anIndex = 1 ifTrue: [ ^ line trimRight ].
	(self regionAt: anInterval first mode: #keep) ifNotNil: [
			self keepLevelOf: anInterval at: anIndex.
			^ line ].
	(self regionAt: anInterval first mode: #shift) ifNotNil: [ :shiftRegion |
			self keepLevelOf: anInterval at: anIndex.
			^ self shift: line by: (shifts at: (self lineIndexOf: shiftRegion first)) ].
	position := self firstNonSeparatorFrom: anInterval first to: anInterval last.
	position ifNil: [
			lineLevels at: anIndex put: stack last.
			^ '' ].
	level := stack last.
	(closers includesKey: position)
		ifTrue: [
				[ position isNotNil and: [ closers includesKey: position ] ] whileTrue: [
						level := self pop - 1.
						position := self firstNonSeparatorFrom: ((closers at: position) at: 3) + 1 to: anInterval last ] ]
		ifFalse: [
				region := self continuationAt: position.
				(region isNotNil and: [ (self depthAt: position) = (self depthAt: region first) ]) ifTrue: [
					level := (lineLevels at: (self lineIndexOf: region first)) + 1 ] ].
	level := level max: 0.
	lineLevels at: anIndex put: level.
	position ifNotNil: [ self applyEventsFrom: position to: anInterval last ].
	shifts at: anIndex put: level * self indentWidth - (self widthOf: line).
	^ (self indentation: level) , line trimBoth
]

{ #category : 'public interface' }
HxRazorFormatter >> formatRazorSource: aString [

	| translator output index |
	razor := aString asString withInternalLineEndings.
	translator := HxRazorTranslator new.
	translator translate: razor.
	self analyze: translator.
	shifts := Array new: lines size withAll: 0.
	lineLevels := Array new: lines size withAll: 0.
	stack := OrderedCollection with: 0.
	output := WriteStream on: String new.
	index := 1.
	[ index <= lines size ] whileTrue: [
			index > 1 ifTrue: [ output nextPut: Character cr ].
			(self styleStartingIn: (lines at: index))
				ifNil: [
						output nextPutAll: (self formatLine: (lines at: index) at: index).
						index := index + 1 ]
				ifNotNil: [ :region | index := self formatStyle: region from: index on: output ] ].
	^ output contents
]

{ #category : 'private' }
HxRazorFormatter >> formatStyle: aRegion from: anIndex on: aStream [
	"Write the line with the <style> tag, the formatted CSS one level deeper, and the line with </style>. Answer the index of the next line."

	| level css closingIndex closing |
	aStream nextPutAll: (self formatLine: ((lines at: anIndex) first to: aRegion first - 1) at: anIndex).
	level := stack last.
	css := HxCssFormatter new linesFor: (razor copyFrom: aRegion first to: (aRegion at: 2)).
	closingIndex := self lineIndexOf: (aRegion at: 2) + 1.
	closing := (razor copyFrom: (aRegion at: 2) + 1 to: (lines at: closingIndex) last) trimBoth.
	lineLevels at: closingIndex put: level.
	self applyEventsFrom: (aRegion at: 2) + 1 to: (lines at: closingIndex) last.
	css isEmpty ifTrue: [
			aStream nextPutAll: closing.
			^ closingIndex + 1 ].
	css do: [ :line |
			aStream nextPut: Character cr.
			line value ifNotEmpty: [ aStream nextPutAll: (self indentation: level + 1 + line key) , line value ] ].
	aStream
		nextPut: Character cr;
		nextPutAll: (self indentation: level) , closing.
	^ closingIndex + 1
]

{ #category : 'accessing' }
HxRazorFormatter >> indentWidth [
	"Views indent like HTML: two spaces per level."

	^ 2
]

{ #category : 'private' }
HxRazorFormatter >> indentation: aLevel [

	^ String new: aLevel * self indentWidth withAll: Character space
]

{ #category : 'private' }
HxRazorFormatter >> keepLevelOf: anInterval at: anIndex [
	"A line that is kept as it is still opens and closes elements and brackets."

	lineLevels at: anIndex put: stack last.
	self applyEventsFrom: anInterval first to: anInterval last
]

{ #category : 'private' }
HxRazorFormatter >> lineIndexOf: aPosition [

	^ lines findFirst: [ :line | aPosition between: line first and: line last + 1 ]
]

{ #category : 'private' }
HxRazorFormatter >> pop [
	"Close the innermost element or bracket and answer the level of its content; the outermost level stays."

	^ stack size > 1
		  ifTrue: [ stack removeLast ]
		  ifFalse: [ 1 ]
]

{ #category : 'private' }
HxRazorFormatter >> regionAt: aPosition mode: aSymbol [

	^ razorRegions
		  detect: [ :region | (region at: 3) = aSymbol and: [ region first < aPosition and: [ aPosition <= (region at: 2) ] ] ]
		  ifNone: [ nil ]
]

{ #category : 'private' }
HxRazorFormatter >> shift: aLine by: aWidth [

	aLine isAllSeparators ifTrue: [ ^ '' ].
	^ (String new: ((self widthOf: aLine) + aWidth max: 0) withAll: Character space) , aLine trimBoth
]

{ #category : 'private' }
HxRazorFormatter >> styleStartingIn: anInterval [
	"The content of a style element that starts on this line, right after its <style> tag."

	^ razorRegions
		  detect: [ :region | (region at: 3) = #css and: [ region first between: anInterval first and: anInterval last + 1 ] ]
		  ifNone: [ nil ]
]

{ #category : 'private' }
HxRazorFormatter >> widthOf: aLine [
	"The width of the indentation of aLine in spaces; a tab counts as one level."

	| width |
	width := 0.
	aLine do: [ :char |
			char = Character space
				ifTrue: [ width := width + 1 ]
				ifFalse: [
						char = Character tab
							ifTrue: [ width := width + self indentWidth ]
							ifFalse: [ ^ width ] ] ].
	^ width
]
