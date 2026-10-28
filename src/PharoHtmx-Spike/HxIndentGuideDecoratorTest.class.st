"
Tests for HxIndentGuideDecorator, drawn off screen.
"
Class {
	#name : 'HxIndentGuideDecoratorTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'helpers' }
HxIndentGuideDecoratorTest >> editorFor: aMethod [

	^ RubScrolledTextMorph new
		  beForSmalltalkCode;
		  classOrMetaClass: aMethod methodClass;
		  extent: 700 @ 300;
		  setText: aMethod sourceCode;
		  yourself
]

{ #category : 'helpers' }
HxIndentGuideDecoratorTest >> guidesChangeTheImageOf: aMethod [
	"Answer whether adding the decorator changes what the editor draws."

	| editor without |
	editor := self editorFor: aMethod.
	without := editor imageForm.
	HxIndentGuideDecorator installIn: editor textArea.
	^ editor imageForm bits ~= without bits
]

{ #category : 'tests' }
HxIndentGuideDecoratorTest >> testDrawsOnlyForViews [

	self assert: (self guidesChangeTheImageOf: HxSpikeBookViews >> #bookList:).
	self deny: (self guidesChangeTheImageOf: HxSpikeCart >> #add:)
]

{ #category : 'tests' }
HxIndentGuideDecoratorTest >> testHalfTypedViewKeepsThePairsBeforeTheError [

	| pairs |
	pairs := HxIndentGuideDecorator new pairsFor: 'list: books
<ul>
  <li>a</li>
</ul>
<p>{{ books size' withInternalLineEndings.
	self assert: (pairs collect: [ :pair | pair at: 5 ]) asArray equals: #( 'li' 'ul' )
]

{ #category : 'tests' }
HxIndentGuideDecoratorTest >> testPairs [

	| editor decorator pairs |
	editor := self editorFor: HxSpikeBookViews >> #bookList:.
	HxIndentGuideDecorator installIn: editor textArea.
	decorator := editor textArea decoratorNamed: HxIndentGuideDecorator key.
	pairs := decorator pairs.
	self assert: (pairs collect: [ :pair | pair at: 5 ]) asArray equals: #( 'a' 'span' 'li' nil 'ul' ).
	self
		assert: (pairs select: [ :pair | decorator spansLines: pair ] thenCollect: [ :pair | pair at: 5 ]) asArray
		equals: #( 'li' nil 'ul' )
]
