"
I am a form for an object that is described with Magritte. I render one field per visible description, read the values of a request, validate them and only then write them to the object. When a value is wrong, I render myself again with what the visitor typed and a message under the field.

I work on a Magritte memento of the object, so nothing changes in the object itself until all values are valid.

	form := (GeoMagritteForm on: book)
		        submit: (self hx action: #save: with: book id);
		        cancel: (self hx action: #show: of: GeoDemoBookDetail with: book id);
		        yourself.

In a view: {{ form }}. In the endpoint that the form submits to:

	(form saveFrom: request)
		ifTrue: [ the object is changed; answer what to show next ]
		ifFalse: [ answer the form, which shows its errors ]

GeoMagritteFieldBuilder picks the field component for each description: a text field, a number field, a text area or a checkbox.
"
Class {
	#name : 'GeoMagritteForm',
	#superclass : 'GeoComponent',
	#instVars : [
		'memento',
		'fields',
		'raw',
		'errors',
		'submit',
		'cancel'
	],
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'instance creation' }
GeoMagritteForm class >> on: anObject [
	"A form for anObject, which describes its fields with <magritteDescription> methods."

	^ self new setMemento: (anObject mementoClass model: anObject)
]

{ #category : 'saving' }
GeoMagritteForm >> addError: aString for: aDescription [

	(errors at: aDescription ifAbsentPut: [ OrderedCollection new ]) add: aString
]

{ #category : 'accessing' }
GeoMagritteForm >> cancel [

	^ cancel
]

{ #category : 'initialization' }
GeoMagritteForm >> cancel: aGeoHtmxAttributes [
	"What the Cancel button requests; without it there is no Cancel button."

	cancel := aGeoHtmxAttributes
]

{ #category : 'saving' }
GeoMagritteForm >> collectErrors: anError [
	"Keep the message of anError under the field of its description; Magritte bundles several errors in one MAMultipleErrors."

	(anError isKindOf: MAMultipleErrors)
		ifTrue: [ anError collection do: [ :each | self collectErrors: each ] ]
		ifFalse: [ self addError: anError messageText for: anError tag ]
]

{ #category : 'accessing' }
GeoMagritteForm >> descriptions [
	"The descriptions of the fields I show, in the order of their priority."

	^ memento magritteDescription children select: [ :each | each isVisible and: [ each isReadOnly not ] ]
]

{ #category : 'fields' }
GeoMagritteForm >> errorsOf: aDescription [
	"The messages to show under the field of aDescription."

	^ errors at: aDescription ifAbsent: [ #(  ) ]
]

{ #category : 'accessing' }
GeoMagritteForm >> fields [
	"One field component per description; see GeoMagritteFieldBuilder."

	^ fields ifNil: [ fields := self descriptions collect: [ :each | GeoMagritteFieldBuilder fieldFor: each in: self ] ]
]

{ #category : 'fields' }
GeoMagritteForm >> hasErrors [

	^ errors notEmpty
]

{ #category : 'accessing' }
GeoMagritteForm >> memento [
	"The Magritte memento that holds the values until they are valid."

	^ memento
]

{ #category : 'accessing' }
GeoMagritteForm >> model [
	"The object I edit."

	^ memento model
]

{ #category : 'fields' }
GeoMagritteForm >> nameOf: aDescription [
	"The name of the input of aDescription in the HTML and in the request: the selector that reads the value, as in title."

	^ (aDescription accessor respondsTo: #readSelector)
		  ifTrue: [ aDescription accessor readSelector asString ]
		  ifFalse: [ (aDescription label reject: [ :each | each isSeparator ]) uncapitalized ]
]

{ #category : 'saving' }
GeoMagritteForm >> raw: aString for: aDescription [
	"Remember what the visitor typed for aDescription, to show it again after a failed save."

	raw at: aDescription put: (aString ifNil: [ '' ])
]

{ #category : 'saving' }
GeoMagritteForm >> readFrom: aGeoRequest [
	"Let each field read its value from aGeoRequest into the memento."

	errors removeAll.
	self fields do: [ :each | each readFrom: aGeoRequest ]
]

{ #category : 'rendering' }
GeoMagritteForm >> render [
<form class="geo-form" {{ submit }}>
  @self fields do: [ :field |
    {{ field }}
  ]
  <div class="geo-form-buttons">
    <button type="submit">Save</button>
    @cancel ifNotNil: [
      <button type="button" {{ cancel }}>Cancel</button>
    ]
  </div>
</form>
]

{ #category : 'saving' }
GeoMagritteForm >> saveFrom: aGeoRequest [
	"Read the values from aGeoRequest and validate them. When they are valid, write them to the object and answer true; otherwise keep the errors, so that I show them, and answer false."

	self readFrom: aGeoRequest.
	self validate ifFalse: [ ^ false ].
	memento commit.
	^ true
]

{ #category : 'initialization' }
GeoMagritteForm >> setMemento: aMemento [

	memento := aMemento.
	raw := Dictionary new.
	errors := Dictionary new
]

{ #category : 'fields' }
GeoMagritteForm >> stringValueOf: aDescription [
	"The text to show in the input of aDescription: what the visitor typed, after a failed save, or else the value as text."

	^ raw
		  at: aDescription
		  ifAbsent: [ (self valueOf: aDescription) ifNil: [ '' ] ifNotNil: [ :value | aDescription toString: value ] ]
]

{ #category : 'accessing' }
GeoMagritteForm >> submit [

	^ submit
]

{ #category : 'initialization' }
GeoMagritteForm >> submit: aGeoHtmxAttributes [
	"Where the form sends its values, as in self hx action: #save: with: book id. Answer myself, for a cascade."

	submit := aGeoHtmxAttributes
]

{ #category : 'saving' }
GeoMagritteForm >> validate [
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
GeoMagritteForm >> valueOf: aDescription [
	"The value of aDescription in the memento."

	^ memento readUsing: aDescription
]

{ #category : 'saving' }
GeoMagritteForm >> write: anObject for: aDescription [
	"Put anObject in the memento as the value of aDescription."

	memento write: anObject using: aDescription
]
