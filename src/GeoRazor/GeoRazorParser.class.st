"
I parse a method of a component (see GeoComponent). A render method is a Razor view: I translate it to Smalltalk with GeoRazorTranslator and parse the result. Any other method is plain Smalltalk, which I parse as my superclass does.
"
Class {
	#name : 'GeoRazorParser',
	#superclass : 'OCParser',
	#category : 'GeoRazor-Compiler',
	#package : 'GeoRazor',
	#tag : 'Compiler'
}

{ #category : 'testing' }
GeoRazorParser class >> isRazorSource: aString [
	"Is aString the source of a Razor view? It is when its selector starts with render, as in render or renderRow: aBook, but not renderer."

	| header rest |
	header := (aString readStream upTo: Character cr) trimLeft.
	header := header copyUpTo: Character lf.
	(header beginsWith: 'render') ifFalse: [ ^ false ].
	rest := header allButFirst: 6.
	^ rest isEmpty or: [ rest first isLowercase not ]
]

{ #category : 'testing' }
GeoRazorParser >> isRazorSource [
	"Only render methods are Razor views; the other methods of a component are plain Smalltalk."

	^ self class isRazorSource: source
]

{ #category : 'parsing' }
GeoRazorParser >> methodNodeFor: aTranslator failedWith: aRazorError [
	"The source could not be translated: answer a method of just the message pattern, carrying the error."

	| header methodNode |
	header := source copyFrom: 1 to: ((source findFirst: [ :char | char = Character cr or: [ char = Character lf ] ]) - 1 max: 0).
	header ifEmpty: [ header := source ].
	methodNode := OCParser parseFaultyMethod: header.
	GeoRazorMethodNode adoptInstance: methodNode.
	methodNode setRazorSource: source map: (1 to: header size) asArray kinds: aTranslator kinds.
	methodNode addRazorError: aRazorError messageText at: (aRazorError position ifNil: [ 1 ]).
	^ methodNode
]

{ #category : 'parsing' }
GeoRazorParser >> parseMethod [
	"Translate the Razor source to Smalltalk and parse that. Problems become error notices at their place in the Razor source, so that both compiling and syntax highlighting can deal with half-typed views."

	| translator generated methodNode |
	self isRazorSource ifFalse: [ ^ super parseMethod ].
	translator := GeoRazorTranslator new.
	generated := [ translator translate: source ]
		             on: GeoRazorError
		             do: [ :error | ^ self methodNodeFor: translator failedWith: error ].
	methodNode := OCParser parseFaultyMethod: generated.
	GeoRazorMethodNode adoptInstance: methodNode.
	methodNode setRazorSource: source map: translator map kinds: translator kinds.
	methodNode propertyAt: #razorRanges put: translator ranges asArray.
	self tonelProblemPosition ifNotNil: [ :position |
			methodNode
				addRazorError:
				'Git would misread this view: an unpaired '' or " or an unbalanced [ or ] in the HTML. Write them as ’ or &#39;, &quot;, &#91; and &#93;.'
				at: position ].
	^ methodNode
]

{ #category : 'parsing' }
GeoRazorParser >> tonelProblemPosition [
	"Tonel finds the end of a method body by scanning it as Smalltalk, so an odd ' or double quote or an unbalanced [ or ] in the HTML would make the method unreadable or cut short once saved to git. Answer where Tonel goes wrong, nil when it reads the source back unchanged."

	| lineEnd body scanned |
	lineEnd := source findFirst: [ :char | char = Character cr or: [ char = Character lf ] ].
	lineEnd = 0 ifTrue: [ ^ nil ].
	body := String cr , (source allButFirst: lineEnd) withInternalLineEndings.
	scanned := [ (TonelSourceScanner on: ('[' , body , String cr , ']') readStream) scan ]
		           on: TonelParseError
		           do: [ ^ lineEnd + 1 ].
	scanned trimRight = body trimRight ifTrue: [ ^ nil ].
	^ lineEnd + (scanned size max: 1) min: source size
]
