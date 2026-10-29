Extension { #name : 'OCMethodNode' }

{ #category : '*GeoRazor' }
OCMethodNode >> debugRangeFor: anInterval [
	"The part of my source that the debugger highlights for anInterval of my AST. A method compiled from another syntax maps it (see GeoRazorMethodNode)."

	^ anInterval
]

{ #category : '*GeoRazor' }
OCMethodNode >> sourceCodeOf: aNode [
	"The source code of aNode, one of my nodes, as a tool shows it to the user. A method compiled from another syntax maps it (see GeoRazorMethodNode)."

	^ aNode sourceCode
]
