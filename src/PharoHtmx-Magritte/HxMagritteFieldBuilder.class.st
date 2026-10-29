"
I pick the field component for a Magritte description, by visiting it: a number description gets a number field, a boolean description a checkbox, a memo description a text area, and any other description a text field. Add a visit method to support another kind of description.

	HxMagritteFieldBuilder fieldFor: aDescription in: aForm
"
Class {
	#name : 'HxMagritteFieldBuilder',
	#superclass : 'MAVisitor',
	#instVars : [
		'form',
		'field'
	],
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'instance creation' }
HxMagritteFieldBuilder class >> fieldFor: aDescription in: aForm [
	"The field component for aDescription in aForm."

	^ self new
		  setForm: aForm;
		  visit: aDescription;
		  field
]

{ #category : 'accessing' }
HxMagritteFieldBuilder >> field [

	^ field
]

{ #category : 'initialization' }
HxMagritteFieldBuilder >> setForm: aForm [

	form := aForm
]

{ #category : 'private' }
HxMagritteFieldBuilder >> use: aFieldClass for: aDescription [

	field := aFieldClass form: form description: aDescription
]

{ #category : 'visiting' }
HxMagritteFieldBuilder >> visitBooleanDescription: aDescription [
	"A checkbox for a boolean description."

	self use: HxMagritteCheckboxField for: aDescription
]

{ #category : 'visiting' }
HxMagritteFieldBuilder >> visitDescription: aDescription [
	"A text field for any description that has no field of its own."

	self use: HxMagritteTextField for: aDescription
]

{ #category : 'visiting' }
HxMagritteFieldBuilder >> visitMemoDescription: aDescription [
	"A text area for a memo description."

	self use: HxMagritteMemoField for: aDescription
]

{ #category : 'visiting' }
HxMagritteFieldBuilder >> visitNumberDescription: aDescription [
	"A number field for a number description."

	self use: HxMagritteNumberField for: aDescription
]

{ #category : 'visiting' }
HxMagritteFieldBuilder >> visitStringDescription: aDescription [
	"A text field for a string description."

	self use: HxMagritteTextField for: aDescription
]
