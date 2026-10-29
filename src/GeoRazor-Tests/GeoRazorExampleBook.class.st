"
A small book for the example views of the Razor tests, so that those tests do not need the demo.
"
Class {
	#name : 'GeoRazorExampleBook',
	#superclass : 'Object',
	#instVars : [
		'id',
		'title',
		'priceInCents',
		'available'
	],
	#category : 'GeoRazor-Tests-Examples',
	#package : 'GeoRazor-Tests',
	#tag : 'Examples'
}

{ #category : 'instance creation' }
GeoRazorExampleBook class >> id: anInteger title: aString price: cents available: aBoolean [

	^ self new
		  setId: anInteger
		  title: aString
		  price: cents
		  available: aBoolean
]

{ #category : 'accessing' }
GeoRazorExampleBook >> id [

	^ id
]

{ #category : 'accessing' }
GeoRazorExampleBook >> isAvailable [

	^ available
]

{ #category : 'accessing' }
GeoRazorExampleBook >> priceString [
	"The price as money, as in '€12.99'."

	^ '€' , (priceInCents // 100) printString , '.' , (priceInCents \\ 100 printPaddedWith: $0 to: 2)
]

{ #category : 'accessing' }
GeoRazorExampleBook >> setId: anInteger title: aString price: cents available: aBoolean [

	id := anInteger.
	title := aString.
	priceInCents := cents.
	available := aBoolean
]

{ #category : 'accessing' }
GeoRazorExampleBook >> title [

	^ title
]
