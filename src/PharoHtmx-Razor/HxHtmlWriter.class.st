"
I collect the HTML a view writes. #raw: writes markup as is, #text: writes any object as escaped text, safe both in element content and in attribute values.
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

{ #category : 'accessing' }
HxHtmlWriter >> contents [

	^ stream contents
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
	"Write anObject as escaped text. nil writes nothing."

	anObject ifNil: [ ^ self ].
	anObject displayString do: [ :char |
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
