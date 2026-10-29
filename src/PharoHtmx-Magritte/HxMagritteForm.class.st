"
I am a form for an object that is described with Magritte. I render one field per visible description, read the values of a request, validate them and only then write them to the object. When a value is wrong, I render myself again with what the visitor typed and a message under the field.

I work on a Magritte memento of the object, so nothing changes in the object itself until all values are valid.

	form := (HxMagritteForm on: book)
		        submit: (self hx action: #save: with: book id);
		        cancel: (self hx action: #show: of: HxSpikeBookDetail with: book id);
		        yourself.

In a view: {{ form }}. In the endpoint that the form submits to:

	(form saveFrom: request)
		ifTrue: [ the object is changed; answer what to show next ]
		ifFalse: [ answer the form, which shows its errors ]

HxMagritteFieldBuilder picks the field component for each description: a text field, a number field, a text area or a checkbox.
"
Class {
	#name : 'HxMagritteForm',
	#superclass : 'HxComponent',
	#instVars : [
		'memento',
		'fields',
		'raw',
		'errors',
		'submit',
		'cancel'
	],
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'instance creation' }
HxMagritteForm class >> on: anObject [
	"A form for anObject, which describes its fields with <magritteDescription> methods."

	^ self new setMemento: (anObject mementoClass model: anObject)
]

{ #category : 'saving' }
HxMagritteForm >> addError: aString for: aDescription [

	(errors at: aDescription ifAbsentPut: [ OrderedCollection new ]) add: aString
]

{ #category : 'accessing' }
HxMagritteForm >> cancel [

	^ cancel
]

{ #category : 'initialization' }
HxMagritteForm >> cancel: anHxHtmxAttributes [
	"What the Cancel button requests; without it there is no Cancel button."

	cancel := anHxHtmxAttributes
]

{ #category : 'saving' }
HxMagritteForm >> collectErrors: anError [
	"Keep the message of anError under the field of its description; Magritte bundles several errors in one MAMultipleErrors."

	(anError isKindOf: MAMultipleErrors)
		ifTrue: [ anError collection do: [ :each | self collectErrors: each ] ]
		ifFalse: [ self addError: anError messageText for: anError tag ]
]

{ #category : 'accessing' }
HxMagritteForm >> descriptions [
	"The descriptions of the fields I show, in the order of their priority."

	^ memento magritteDescription children select: [ :each | each isVisible and: [ each isReadOnly not ] ]
]

{ #category : 'fields' }
HxMagritteForm >> errorsOf: aDescription [
	"The messages to show under the field of aDescription."

	^ errors at: aDescription ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
HxMagritteForm >> fields [
	"One field component per description; see HxMagritteFieldBuilder."

	^ fields ifNil: [ fields := self descriptions collect: [ :each | HxMagritteFieldBuilder fieldFor: each in: self ] ]
]

{ #category : 'fields' }
HxMagritteForm >> hasErrors [

	^ errors notEmpty
]

{ #category : 'accessing' }
HxMagritteForm >> memento [
	"The Magritte memento that holds the values until they are valid."

	^ memento
]

{ #category : 'accessing' }
HxMagritteForm >> model [
	"The object I edit."

	^ memento model
]

{ #category : 'fields' }
HxMagritteForm >> nameOf: aDescription [
	"The name of the input of aDescription in the HTML and in the request: the selector that reads the value, as in title."

	^ (aDescription accessor respondsTo: #readSelector)
		  ifTrue: [ aDescription accessor readSelector asString ]
		  ifFalse: [ (aDescription label reject: [ :each | each isSeparator ]) uncapitalized ]
]

{ #category : 'saving' }
HxMagritteForm >> raw: aString for: aDescription [
	"Remember what the visitor typed for aDescription, to show it again after a failed save."

	raw at: aDescription put: (aString ifNil: [ '' ])
]

{ #category : 'saving' }
HxMagritteForm >> readFrom: anHxRequest [
	"Let each field read its value from anHxRequest into the memento."

	errors removeAll.
	self fields do: [ :each | each readFrom: anHxRequest ]
]

{ #category : 'rendering' }
HxMagritteForm >> render [
<form class="hx-form" {{ submit }}>
  @self fields do: [ :field |
    {{ field }}
  ]
  <div class="hx-form-buttons">
    <button type="submit">Save</button>
    @cancel ifNotNil: [
      <button type="button" {{ cancel }}>Cancel</button>
    ]
  </div>
</form>
]

{ #category : 'saving' }
HxMagritteForm >> saveFrom: anHxRequest [
	"Read the values from anHxRequest and validate them. When they are valid, write them to the object and answer true; otherwise keep the errors, so that I show them, and answer false."

	self readFrom: anHxRequest.
	self validate ifFalse: [ ^ false ].
	memento commit.
	^ true
]

{ #category : 'initialization' }
HxMagritteForm >> setMemento: aMemento [

	memento := aMemento.
	raw := Dictionary new.
	errors := Dictionary new
]

{ #category : 'fields' }
HxMagritteForm >> stringValueOf: aDescription [
	"The text to show in the input of aDescription: what the visitor typed, after a failed save, or else the value as text."

	^ raw
		  at: aDescription
		  ifAbsent: [ (self valueOf: aDescription) ifNil: [ '' ] ifNotNil: [ :value | aDescription toString: value ] ]
]

{ #category : 'accessing' }
HxMagritteForm >> submit [

	^ submit
]

{ #category : 'initialization' }
HxMagritteForm >> submit: anHxHtmxAttributes [
	"Where the form sends its values, as in self hx action: #save: with: book id. Answer myself, for a cascade."

	submit := anHxHtmxAttributes
]

{ #category : 'saving' }
HxMagritteForm >> validate [
	"Answer whether the values in the memento are valid; collect the errors per field when they are not."

	self hasErrors ifTrue: [ ^ false ].
	^ [
		  memento validate.
		  true ]
		  on: MAValidationError
		  do: [ :error |
				  self collectErrors: error.
				  false ]
]

{ #category : 'fields' }
HxMagritteForm >> valueOf: aDescription [
	"The value of aDescription in the memento."

	^ memento readUsing: aDescription
]

{ #category : 'saving' }
HxMagritteForm >> write: anObject for: aDescription [
	"Put anObject in the memento as the value of aDescription."

	memento write: anObject using: aDescription
]
