"
A minimal book for the Razor spike. Prices are in euro cents.
"
Class {
	#name : 'HxSpikeBook',
	#superclass : 'Object',
	#instVars : [
		'id',
		'title',
		'available',
		'priceInCents'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'formatting' }
HxSpikeBook class >> formatCents: anInteger [
	"Answer anInteger euro cents as money, as in '€12.99'."

	^ '€' , (anInteger // 100) printString , '.' , (anInteger \\ 100 printPaddedWith: $0 to: 2)
]

{ #category : 'instance creation' }
HxSpikeBook class >> id: anInteger title: aString price: cents available: aBoolean [

	^ self new
		  setId: anInteger
		  title: aString
		  price: cents
		  available: aBoolean
]

{ #category : 'accessing' }
HxSpikeBook >> id [

	^ id
]

{ #category : 'testing' }
HxSpikeBook >> isAvailable [

	^ available
]

{ #category : 'accessing' }
HxSpikeBook >> priceInCents [

	^ priceInCents
]

{ #category : 'accessing' }
HxSpikeBook >> priceString [

	^ self class formatCents: priceInCents
]

{ #category : 'initialization' }
HxSpikeBook >> setId: anInteger title: aString price: cents available: aBoolean [

	id := anInteger.
	title := aString.
	priceInCents := cents.
	available := aBoolean
]

{ #category : 'accessing' }
HxSpikeBook >> title [

	^ title
]
