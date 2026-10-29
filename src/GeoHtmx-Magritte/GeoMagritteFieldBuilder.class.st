"
I pick the field component for a Magritte description, by visiting it: a number description gets a number field, a boolean description a checkbox, a memo description a text area, and any other description a text field. Add a visit method to support another kind of description.

	GeoMagritteFieldBuilder fieldFor: aDescription in: aForm
"
Class {
	#name : 'GeoMagritteFieldBuilder',
	#superclass : 'MAVisitor',
	#instVars : [
		'form',
		'field'
	],
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'instance creation' }
GeoMagritteFieldBuilder class >> fieldFor: aDescription in: aForm [
	"The field component for aDescription in aForm."

	^ self new
		  setForm: aForm;
		  visit: aDescription;
		  field
]

{ #category : 'accessing' }
GeoMagritteFieldBuilder >> field [

	^ field
]

{ #category : 'initialization' }
GeoMagritteFieldBuilder >> setForm: aForm [

	form := aForm
]

{ #category : 'private' }
GeoMagritteFieldBuilder >> use: aFieldClass for: aDescription [

	field := aFieldClass form: form description: aDescription
]

{ #category : 'visiting' }
GeoMagritteFieldBuilder >> visitBooleanDescription: aDescription [
	"A checkbox for a boolean description."

	self use: GeoMagritteCheckboxField for: aDescription
]

{ #category : 'visiting' }
GeoMagritteFieldBuilder >> visitDescription: aDescription [
	"A text field for any description that has no field of its own."

	self use: GeoMagritteTextField for: aDescription
]

{ #category : 'visiting' }
GeoMagritteFieldBuilder >> visitMemoDescription: aDescription [
	"A text area for a memo description."

	self use: GeoMagritteMemoField for: aDescription
]

{ #category : 'visiting' }
GeoMagritteFieldBuilder >> visitNumberDescription: aDescription [
	"A number field for a number description."

	self use: GeoMagritteNumberField for: aDescription
]

{ #category : 'visiting' }
GeoMagritteFieldBuilder >> visitStringDescription: aDescription [
	"A text field for a string description."

	self use: GeoMagritteTextField for: aDescription
]
