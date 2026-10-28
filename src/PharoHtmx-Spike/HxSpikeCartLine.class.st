"
One line of a cart: a book and how many of it.
"
Class {
	#name : 'HxSpikeCartLine',
	#superclass : 'Object',
	#instVars : [
		'book',
		'quantity'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'instance creation' }
HxSpikeCartLine class >> book: aBook quantity: anInteger [

	^ self new setBook: aBook quantity: anInteger
]

{ #category : 'accessing' }
HxSpikeCartLine >> book [

	^ book
]

{ #category : 'accessing' }
HxSpikeCartLine >> quantity [

	^ quantity
]

{ #category : 'initialization' }
HxSpikeCartLine >> setBook: aBook quantity: anInteger [

	book := aBook.
	quantity := anInteger
]

{ #category : 'accessing' }
HxSpikeCartLine >> totalInCents [

	^ book priceInCents * quantity
]

{ #category : 'accessing' }
HxSpikeCartLine >> totalString [

	^ HxSpikeBook formatCents: self totalInCents
]
