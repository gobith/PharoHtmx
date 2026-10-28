"
I am the AST of a Razor view method: the AST of the Smalltalk it was translated into, plus (in my properties) the Razor source, the map from generated to source positions and the kind of each source character.

With these I:
- style the Razor source when a code editor's styler visits me: the Smalltalk parts get the normal Smalltalk colours, the HTML gets its own;
- report errors at their place in the Razor source instead of in the generated code.
"
Class {
	#name : 'HxRazorMethodNode',
	#superclass : 'OCMethodNode',
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'styling' }
HxRazorMethodNode class >> styleForKind: aKind [
	"The Shout style for a kind of Razor source character, nil to leave it alone. Shout styles follow the theme.
	CSS follows HTML: selectors look like tags, properties like attribute names, values like attribute values."

	^ {
		  (#tag -> #pragma).
		  (#attributeName -> #tempVar).
		  (#attributeValue -> #string).
		  (#comment -> #comment).
		  (#razor -> #return).
		  (#cssSelector -> #pragma).
		  (#cssProperty -> #tempVar).
		  (#cssValue -> #string).
		  (#cssNumber -> #number).
		  (#cssAtRule -> #classVar) } asDictionary at: aKind ifAbsent: [ nil ]
]

{ #category : 'visiting' }
HxRazorMethodNode >> acceptVisitor: aVisitor [
	"A code editor styles the Razor source, not the generated code."

	(aVisitor isKindOf: SHRBTextStyler) ifTrue: [ ^ self styleWith: aVisitor ].
	^ super acceptVisitor: aVisitor
]

{ #category : 'errors' }
HxRazorMethodNode >> addRazorError: aString at: aPosition [

	self razorErrors add: (HxRazorNotice new
			 messageText: aString;
			 node: self;
			 position: aPosition;
			 yourself)
]

{ #category : 'errors' }
HxRazorMethodNode >> allErrorNotices [

	^ self allNotices select: [ :notice | notice isError ]
]

{ #category : 'errors' }
HxRazorMethodNode >> allNotices [
	"Errors in the generated code are moved to their place in the Razor source; Razor errors come on top."

	| notices |
	notices := super allNotices collect: [ :notice |
			           notice isError
				           ifTrue: [
						           HxRazorNotice new
							           messageText: notice messageText;
							           node: notice node;
							           position: (self sourcePositionOf: notice position);
							           yourself ]
				           ifFalse: [ notice ] ].
	^ notices , self razorErrors
]

{ #category : 'querying' }
HxRazorMethodNode >> bestNodeFor: anInterval [
	"anInterval is in the Razor source, as selected in an editor; answer the node at that place in the generated code, or nil outside Smalltalk."

	| map first last |
	anInterval ifNil: [ ^ nil ].
	map := self propertyAt: #razorMap.
	first := (1 to: map size) detect: [ :index | (map at: index) >= anInterval first ] ifNone: [ ^ nil ].
	(map at: first) > (anInterval last max: anInterval first) ifTrue: [ ^ nil ].
	last := (1 to: map size) reverse detect: [ :index | (map at: index) between: 1 and: (anInterval last max: anInterval first) ].
	^ super bestNodeFor: (first to: last)
]

{ #category : 'accessing' }
HxRazorMethodNode >> comments [
	"Comments of the generated code have no place in the Razor source."

	^ #(  )
]

{ #category : 'debugging' }
HxRazorMethodNode >> debugRangeFor: anInterval [
	"anInterval is in the generated code; answer the part of the Razor source it stands for. An html raw: or html text: statement stands for its piece of HTML or its {{ }}, copied Smalltalk for itself."

	| map first last |
	map := self propertyAt: #razorMap.
	(self propertyAt: #razorRanges ifAbsent: [ #(  ) ]) do: [ :range |
			(range first <= anInterval last and: [ (range at: 2) >= anInterval first ]) ifTrue: [
					first := (first ifNil: [ range at: 3 ]) min: (range at: 3).
					last := (last ifNil: [ range at: 4 ]) max: (range at: 4) ] ].
	(anInterval first max: 1) to: (anInterval last min: map size) do: [ :index |
			(map at: index) > 0 ifTrue: [
					first := (first ifNil: [ map at: index ]) min: (map at: index).
					last := (last ifNil: [ map at: index ]) max: (map at: index) ] ].
	first ifNil: [ ^ (self sourcePositionOf: anInterval first) to: (self sourcePositionOf: anInterval first) - 1 ].
	^ first to: last
]

{ #category : 'styling' }
HxRazorMethodNode >> installIndentGuidesFor: aStyler [
	"Give the editor being styled indent guides (see HxIndentGuideDecorator). The styler knows its editor only through its view slot, which has no accessor. Styling may run in the background, so the editor is changed in the UI process."

	| view area |
	view := aStyler instVarNamed: #view.
	(view isNotNil and: [ view respondsTo: #textArea ]) ifFalse: [ ^ self ].
	area := view textArea.
	(area isNotNil and: [ (area respondsTo: #withDecorator:) and: [ (area hasDecoratorNamed: HxIndentGuideDecorator key) not ] ])
		ifFalse: [ ^ self ].
	area defer: [ HxIndentGuideDecorator installIn: area ]
]

{ #category : 'errors' }
HxRazorMethodNode >> isFaulty [

	^ super isFaulty or: [ self razorErrors notEmpty ]
]

{ #category : 'accessing' }
HxRazorMethodNode >> razorErrors [

	^ self propertyAt: #razorErrors ifAbsentPut: [ OrderedCollection new ]
]

{ #category : 'accessing' }
HxRazorMethodNode >> razorSource [

	^ self propertyAt: #razorSource
]

{ #category : 'initialization' }
HxRazorMethodNode >> setRazorSource: aString map: anArray kinds: kindsArray [

	self propertyAt: #razorSource put: aString.
	self propertyAt: #razorMap put: anArray.
	self propertyAt: #razorKinds put: kindsArray
]

{ #category : 'debugging' }
HxRazorMethodNode >> sourceCodeOf: aNode [
	"The Razor source that aNode stands for, instead of its generated Smalltalk."

	| range |
	range := self debugRangeFor: aNode sourceInterval.
	range ifEmpty: [ ^ aNode sourceCode ].
	^ self razorSource copyFrom: range first to: (range last min: self razorSource size)
]

{ #category : 'errors' }
HxRazorMethodNode >> sourcePositionOf: aGeneratedPosition [
	"Answer the position in the Razor source for aGeneratedPosition. A generated character has none of its own; take the place right after the last copied character before it."

	| map |
	map := self propertyAt: #razorMap.
	map ifEmpty: [ ^ 1 ].
	(aGeneratedPosition min: map size) to: 1 by: -1 do: [ :index |
			(map at: index) > 0 ifTrue: [
					^ index = aGeneratedPosition
						  ifTrue: [ map at: index ]
						  ifFalse: [ (map at: index) + 1 min: self razorSource size ] ] ].
	^ 1
]

{ #category : 'styling' }
HxRazorMethodNode >> styleSmalltalkWith: aStyler [
	"Style the generated code as ordinary Smalltalk, with a copy of aStyler so that theme and settings match, and carry each character's attributes back to where it came from in the Razor source."

	| map generated ast styled |
	map := self propertyAt: #razorMap.
	generated := self source.
	ast := [
		       OpalCompiler new
			       class: (self methodClass ifNil: [ UndefinedObject ]);
			       source: generated;
			       permitFaulty: true;
			       parse ]
		       on: Error
		       do: [ ^ self ].
	styled := aStyler copy style: generated asText ast: ast.
	map withIndexDo: [ :sourcePosition :index |
		sourcePosition > 0 ifTrue: [ aStyler addAttributes: (styled attributesAt: index) from: sourcePosition to: sourcePosition ] ]
]

{ #category : 'styling' }
HxRazorMethodNode >> styleWith: aStyler [

	| kinds |
	kinds := self propertyAt: #razorKinds.
	kinds withIndexDo: [ :kind :index |
		(self class styleForKind: kind) ifNotNil: [ :style | aStyler addStyle: style from: index to: index ] ].
	self styleSmalltalkWith: aStyler.
	self razorErrors do: [ :notice | aStyler addStyle: #invalid from: notice position to: notice position ].
	self installIndentGuidesFor: aStyler
]
