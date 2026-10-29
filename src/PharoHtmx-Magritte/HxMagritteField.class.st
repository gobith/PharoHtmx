"
I am the abstract superclass of the fields of an HxMagritteForm: one field for one Magritte description. A subclass renders the input in its render method, with renderLabel and renderErrors from me, and may override readFrom: to read its value from the request.
"
Class {
	#name : 'HxMagritteField',
	#superclass : 'HxComponent',
	#instVars : [
		'form',
		'description'
	],
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'instance creation' }
HxMagritteField class >> form: aForm description: aDescription [

	^ self new setForm: aForm description: aDescription
]

{ #category : 'accessing' }
HxMagritteField >> description [

	^ description
]

{ #category : 'accessing' }
HxMagritteField >> errors [
	"The messages to show under me."

	^ form errorsOf: description
]

{ #category : 'accessing' }
HxMagritteField >> label [
	"My label, with a star when a value is required."

	^ description isRequired
		  ifTrue: [ description label , ' *' ]
		  ifFalse: [ description label ]
]

{ #category : 'accessing' }
HxMagritteField >> name [
	"The name of my input in the HTML and in the request."

	^ form nameOf: description
]

{ #category : 'reading' }
HxMagritteField >> readFrom: anHxRequest [
	"Read my value from anHxRequest into the form's memento. An empty input is nil; text that my description cannot read gives the description's kind error, as in 'Invalid input given'."

	| string |
	string := (anHxRequest at: self name ifAbsent: [ nil ]) ifNotNil: [ :each | each trimBoth ].
	form raw: string for: description.
	string isEmptyOrNil ifTrue: [ ^ form write: nil for: description ].
	[ form write: (description fromString: string) for: description ]
		on: MAReadError
		do: [ form addError: description kindErrorMessage for: description ]
]

{ #category : 'rendering' }
HxMagritteField >> renderErrors [
@self errors do: [ :message |
  <p class="field-error">{{ message }}</p>
]
]

{ #category : 'rendering' }
HxMagritteField >> renderLabel [
<label for="{{ self name }}">{{ self label }}</label>
]

{ #category : 'accessing' }
HxMagritteField >> setForm: aForm description: aDescription [

	form := aForm.
	description := aDescription
]

{ #category : 'accessing' }
HxMagritteField >> stringValue [
	"The text to show in my input."

	^ form stringValueOf: description
]
