Extension { #name : 'OnlineSourceDebugInfo' }

{ #category : '*GeoRazor' }
OnlineSourceDebugInfo >> rangeForPC: aPC [
	"Patched by PharoHtmx; the original is ^ (self privateSourceNodeForPC: aPC) debugHighlightRange.
	Let the method node map the range, so that a method compiled from another syntax (see GeoComponent class>>compilerClass) highlights its own source. Candidate for upstream."

	| node |
	node := self privateSourceNodeForPC: aPC.
	^ node methodNode
		  ifNil: [ node debugHighlightRange ]
		  ifNotNil: [ :methodNode | methodNode debugRangeFor: node debugHighlightRange ]
]
