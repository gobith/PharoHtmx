"
Tests for GeoIndentGuideDecorator, drawn off screen.
"
Class {
	#name : 'GeoIndentGuideDecoratorTest',
	#superclass : 'TestCase',
	#category : 'GeoRazor-Tests-Tests',
	#package : 'GeoRazor-Tests',
	#tag : 'Tests'
}

{ #category : 'helpers' }
GeoIndentGuideDecoratorTest >> editorFor: aMethod [

	^ RubScrolledTextMorph new
		  beForSmalltalkCode;
		  classOrMetaClass: aMethod methodClass;
		  extent: 700 @ 300;
		  setText: aMethod sourceCode;
		  yourself
]

{ #category : 'helpers' }
GeoIndentGuideDecoratorTest >> guidesChangeTheImageOf: aMethod [
	"Answer whether adding the decorator changes what the editor draws."

	| editor without |
	editor := self editorFor: aMethod.
	without := editor imageForm.
	GeoIndentGuideDecorator installIn: editor textArea.
	^ editor imageForm bits ~= without bits
]

{ #category : 'tests' }
GeoIndentGuideDecoratorTest >> testDrawsOnlyForViews [

	self assert: (self guidesChangeTheImageOf: GeoRazorExampleViews >> #renderBookList:).
	self deny: (self guidesChangeTheImageOf: GeoRazorExampleBook >> #title)
]

{ #category : 'tests' }
GeoIndentGuideDecoratorTest >> testHalfTypedViewKeepsThePairsBeforeTheError [

	| pairs |
	pairs := GeoIndentGuideDecorator new pairsFor: 'list: books
<ul>
  <li>a</li>
</ul>
<p>{{ books size' withInternalLineEndings.
	self assert: (pairs collect: [ :pair | pair at: 5 ]) asArray equals: #( 'li' 'ul' )
]

{ #category : 'tests' }
GeoIndentGuideDecoratorTest >> testPairs [

	| editor decorator pairs |
	editor := self editorFor: GeoRazorExampleViews >> #renderBookList:.
	GeoIndentGuideDecorator installIn: editor textArea.
	decorator := editor textArea decoratorNamed: GeoIndentGuideDecorator key.
	pairs := decorator pairs.
	self assert: (pairs collect: [ :pair | pair at: 5 ]) asArray equals: #( 'a' 'span' 'li' nil 'ul' ).
	self
		assert: (pairs select: [ :pair | decorator spansLines: pair ] thenCollect: [ :pair | pair at: 5 ]) asArray
		equals: #( 'li' nil 'ul' )
]
