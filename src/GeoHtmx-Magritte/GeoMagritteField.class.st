"
I am the abstract superclass of the fields of an GeoMagritteForm: one field for one Magritte description. A subclass renders the input in its render method, with renderLabel and renderErrors from me, and may override readFrom: to read its value from the request.
"
Class {
	#name : 'GeoMagritteField',
	#superclass : 'GeoComponent',
	#instVars : [
		'form',
		'description'
	],
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'instance creation' }
GeoMagritteField class >> form: aForm description: aDescription [

	^ self new setForm: aForm description: aDescription
]

{ #category : 'accessing' }
GeoMagritteField >> description [

	^ description
]

{ #category : 'accessing' }
GeoMagritteField >> errors [
	"The messages to show under me."

	^ form errorsOf: description
]

{ #category : 'accessing' }
GeoMagritteField >> label [
	"My label, with a star when a value is required."

	^ description isRequired
		  ifTrue: [ description label , ' *' ]
		  ifFalse: [ description label ]
]

{ #category : 'accessing' }
GeoMagritteField >> name [
	"The name of my input in the HTML and in the request."

	^ form nameOf: description
]

{ #category : 'reading' }
GeoMagritteField >> readFrom: aGeoRequest [
	"Read my value from aGeoRequest into the form's memento. An empty input is nil; text that my description cannot read gives the description's kind error, as in 'Invalid input given'."

	| string |
	string := (aGeoRequest at: self name ifAbsent: [ nil ]) ifNotNil: [ :each | each trimBoth ].
	form raw: string for: description.
	string isEmptyOrNil ifTrue: [ ^ form write: nil for: description ].
	[ form write: (description fromString: string) for: description ]
		on: MAReadError
		do: [ form addError: description kindErrorMessage for: description ]
]

{ #category : 'rendering' }
GeoMagritteField >> renderErrors [
@self errors do: [ :message |
  <p class="field-error">{{ message }}</p>
]
]

{ #category : 'rendering' }
GeoMagritteField >> renderLabel [
<label for="{{ self name }}">{{ self label }}</label>
]

{ #category : 'accessing' }
GeoMagritteField >> setForm: aForm description: aDescription [

	form := aForm.
	description := aDescription
]

{ #category : 'accessing' }
GeoMagritteField >> stringValue [
	"The text to show in my input."

	^ form stringValueOf: description
]
