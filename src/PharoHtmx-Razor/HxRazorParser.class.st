"
I parse a Razor view method by translating it to Smalltalk with HxRazorTranslator and parsing the result.
"
Class {
	#name : 'HxRazorParser',
	#superclass : 'OCParser',
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'parsing' }
HxRazorParser >> methodNodeFor: aTranslator failedWith: aRazorError [
	"The source could not be translated: answer a method of just the message pattern, carrying the error."

	| header methodNode |
	header := source copyFrom: 1 to: ((source findFirst: [ :char | char = Character cr or: [ char = Character lf ] ]) - 1 max: 0).
	header ifEmpty: [ header := source ].
	methodNode := OCParser parseFaultyMethod: header.
	HxRazorMethodNode adoptInstance: methodNode.
	methodNode setRazorSource: source map: (1 to: header size) asArray kinds: aTranslator kinds.
	methodNode addRazorError: aRazorError messageText at: (aRazorError position ifNil: [ 1 ]).
	^ methodNode
]

{ #category : 'parsing' }
HxRazorParser >> parseMethod [
	"Translate the Razor source to Smalltalk and parse that. Problems become error notices at their place in the Razor source, so that both compiling and syntax highlighting can deal with half-typed views."

	| translator generated methodNode |
	translator := HxRazorTranslator new.
	generated := [ translator translate: source ]
		             on: HxRazorError
		             do: [ :error | ^ self methodNodeFor: translator failedWith: error ].
	methodNode := OCParser parseFaultyMethod: generated.
	HxRazorMethodNode adoptInstance: methodNode.
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
HxRazorParser >> tonelProblemPosition [
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
