Extension { #name : 'RubSmalltalkCodeMode' }

{ #category : '*PharoHtmx-Razor' }
RubSmalltalkCodeMode >> parseSource: aString [
	"Patched by PharoHtmx; the original is ^ OCParser parseFaultyMethod: aString.
	Parse with the parser of the class's compiler, as Shout styling already does, so that a class with its own method syntax (see HxComponent class>>compilerClass) can be formatted and searched. Candidate for upstream."

	| parserClass |
	parserClass := classOrMetaclass
		               ifNil: [ OCParser ]
		               ifNotNil: [ :class | class compiler parserClass ].
	^ parserClass parseFaultyMethod: aString
]
