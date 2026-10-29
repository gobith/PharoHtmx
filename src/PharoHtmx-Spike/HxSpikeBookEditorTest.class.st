"
I test HxMagritteForm through the book editor of the demo: the fields that the book's Magritte descriptions give, validation with messages per field, and saving.
"
Class {
	#name : 'HxSpikeBookEditorTest',
	#superclass : 'TestCase',
	#instVars : [
		'book'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'helpers' }
HxSpikeBookEditorTest >> put: anArrayOfAssociations [
	"A PUT request with anArrayOfAssociations as its form fields, as a browser sends a form."

	| znRequest entity |
	znRequest := ZnRequest put: '/books/7'.
	entity := ZnApplicationFormUrlEncodedEntity new.
	anArrayOfAssociations do: [ :each | entity at: each key put: each value ].
	znRequest entity: entity.
	^ HxRequest on: znRequest pathParameters: Dictionary new
]

{ #category : 'running' }
HxSpikeBookEditorTest >> setUp [

	super setUp.
	book := HxSpikeBook
		        id: 7
		        title: 'Original'
		        price: 1000
		        available: true
]

{ #category : 'tests' }
HxSpikeBookEditorTest >> testEditorEndpoints [

	| app response html |
	app := HxSpikeApp new.
	self assert: (HxSpikeBookEditor pathOf: #edit: with: 3) equals: '/books/3/edit'.
	self assert: (HxSpikeBookEditor pathOf: #save: with: 3) equals: '/books/3'.
	html := (HxSpikeBookEditor book: app catalog first) toHtml.
	self assert: (html includesSubstring: '<form class="hx-form" hx-put="/books/1" hx-target="#detail">').
	self assert: (html includesSubstring: 'hx-get="/books/1" hx-target="#detail">Cancel</button>')
]

{ #category : 'tests' }
HxSpikeBookEditorTest >> testFieldsFollowTheDescriptions [

	| form html |
	form := HxMagritteForm on: book.
	self assert: (form fields collect: [ :each | each class ]) asArray equals: {
			HxMagritteTextField.
			HxMagritteNumberField.
			HxMagritteCheckboxField }.
	html := form toHtml.
	self assert: (html includesSubstring: '<label for="title">Title *</label>').
	self assert: (html includesSubstring: 'name="title" type="text" value="Original"').
	self assert: (html includesSubstring: 'name="priceInCents" type="number" value="1000"').
	self assert: (html includesSubstring: 'name="isAvailable" value="true" checked="checked"')
]

{ #category : 'tests' }
HxSpikeBookEditorTest >> testInvalidValuesShowErrorsAndChangeNothing [

	| form html |
	form := HxMagritteForm on: book.
	self deny: (form saveFrom: (self put: {
					  ('title' -> '   ').
					  ('priceInCents' -> '-5').
					  ('isAvailable' -> 'true') })).
	html := form toHtml.
	self assert: (html includesSubstring: '<p class="field-error">Input is required but no input given</p>').
	self assert: (html includesSubstring: '<p class="field-error">Input must be between 0 and 100000</p>').
	self assert: (html includesSubstring: 'value="-5"').
	self assert: book title equals: 'Original'.
	self assert: book priceInCents equals: 1000
]

{ #category : 'tests' }
HxSpikeBookEditorTest >> testTooLongTitle [

	| form |
	form := HxMagritteForm on: book.
	self deny: (form saveFrom: (self put: {
					  ('title' -> (String new: 101 withAll: $x)).
					  ('priceInCents' -> '100') })).
	self assert: (form errorsOf: form descriptions first) asArray equals: #( 'At most 100 characters' )
]

{ #category : 'tests' }
HxSpikeBookEditorTest >> testUnreadableNumber [

	| form |
	form := HxMagritteForm on: book.
	self deny: (form saveFrom: (self put: {
					  ('title' -> 'New').
					  ('priceInCents' -> 'abc') })).
	self assert: (form errorsOf: form descriptions second) asArray equals: #( 'Invalid input given' ).
	self assert: (form stringValueOf: form descriptions second) equals: 'abc'.
	self assert: book title equals: 'Original'
]

{ #category : 'tests' }
HxSpikeBookEditorTest >> testValidValuesAreSaved [
	"An unchecked box sends nothing, which means false."

	| form |
	form := HxMagritteForm on: book.
	self assert: (form saveFrom: (self put: {
					  ('title' -> '  New title ').
					  ('priceInCents' -> '1550') })).
	self assert: book title equals: 'New title'.
	self assert: book priceInCents equals: 1550.
	self deny: book isAvailable
]
