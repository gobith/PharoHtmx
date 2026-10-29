"
One line of a cart: a book and how many of it.
"
Class {
	#name : 'GeoDemoCartLine',
	#superclass : 'Object',
	#instVars : [
		'book',
		'quantity'
	],
	#category : 'GeoHtmx-Demo-Model',
	#package : 'GeoHtmx-Demo',
	#tag : 'Model'
}

{ #category : 'instance creation' }
GeoDemoCartLine class >> book: aBook quantity: anInteger [

	^ self new setBook: aBook quantity: anInteger
]

{ #category : 'accessing' }
GeoDemoCartLine >> book [

	^ book
]

{ #category : 'accessing' }
GeoDemoCartLine >> quantity [

	^ quantity
]

{ #category : 'initialization' }
GeoDemoCartLine >> setBook: aBook quantity: anInteger [

	book := aBook.
	quantity := anInteger
]

{ #category : 'accessing' }
GeoDemoCartLine >> totalInCents [

	^ book priceInCents * quantity
]

{ #category : 'accessing' }
GeoDemoCartLine >> totalString [

	^ GeoDemoBook formatCents: self totalInCents
]
