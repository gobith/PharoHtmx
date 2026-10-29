Extension { #name : 'StContextPrinter' }

{ #category : '*PharoHtmx-Razor' }
StContextPrinter class >> printMethod: aCompiledMethod on: aStream [
	"Patched by PharoHtmx; the original prints aCompiledMethod sourceNode sourceCode for a block.
	Ask the method node, so that a block in a method compiled from another syntax (see HxComponent class>>compilerClass) shows its own source. Candidate for upstream."

	aStream << '>>'.
	aStream << (aCompiledMethod isCompiledBlock
		 ifTrue: [
				 aCompiledMethod sourceNode in: [ :node |
					 node methodNode ifNil: [ node sourceCode ] ifNotNil: [ :methodNode | methodNode sourceCodeOf: node ] ] ]
		 ifFalse: [ aCompiledMethod selector ])
]
