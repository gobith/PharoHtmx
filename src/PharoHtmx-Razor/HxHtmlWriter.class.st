"
I collect the HTML a component writes. #raw: writes markup as is. #text: writes what a {{ }} stands for: an object that answers #writeHtmlOn: writes itself (a component, HxHtmxAttributes), anything else is written as escaped text, safe both in element content and in attribute values. #attribute:value: writes one attribute with an escaped value.
"
Class {
	#name : 'HxHtmlWriter',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'PharoHtmx-Razor',
	#package : 'PharoHtmx-Razor'
}

{ #category : 'writing' }
HxHtmlWriter >> attribute: aName value: aString [
	"Write aName=""aString"" with aString escaped."

	stream nextPutAll: aName; nextPutAll: '="'.
	self escaped: aString asString.
	stream nextPut: $"
]

{ #category : 'accessing' }
HxHtmlWriter >> contents [

	^ stream contents
]

{ #category : 'writing' }
HxHtmlWriter >> escaped: aString [
	"Write aString with the characters that have a meaning in HTML escaped, so it is safe both in element content and in attribute values."

	aString do: [ :char |
			char = $&
				ifTrue: [ stream nextPutAll: '&amp;' ]
				ifFalse: [
						char = $<
							ifTrue: [ stream nextPutAll: '&lt;' ]
							ifFalse: [
									char = $>
										ifTrue: [ stream nextPutAll: '&gt;' ]
										ifFalse: [
												char = $"
													ifTrue: [ stream nextPutAll: '&quot;' ]
													ifFalse: [
															char = $'
																ifTrue: [ stream nextPutAll: '&#39;' ]
																ifFalse: [ stream nextPut: char ] ] ] ] ] ]
]

{ #category : 'initialization' }
HxHtmlWriter >> initialize [

	super initialize.
	stream := WriteStream on: (String new: 1024)
]

{ #category : 'writing' }
HxHtmlWriter >> raw: aString [

	stream nextPutAll: aString
]

{ #category : 'writing' }
HxHtmlWriter >> text: anObject [
	"Write what a {{ }} in a view stands for. An object that knows how to write itself as HTML does so (a component renders itself, HxHtmxAttributes writes its attributes); anything else is written as escaped text. nil writes nothing."

	anObject ifNil: [ ^ self ].
	(anObject respondsTo: #writeHtmlOn:) ifTrue: [ ^ anObject writeHtmlOn: self ].
	self escaped: anObject displayString
]
