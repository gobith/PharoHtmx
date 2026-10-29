"
The button that puts a book in the cart, or a note that it is sold out. After a click it shows how many are in the cart.
"
Class {
	#name : 'HxSpikeAddButton',
	#superclass : 'HxComponent',
	#instVars : [
		'book',
		'quantity'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'endpoints' }
HxSpikeAddButton class >> add: request [
	"Put a book in the cart; answer the new button and, out of band, the cart link."
	<post: '/cart/<id>'>

	| cart |
	cart := request app cart.
	^ request app withBookFrom: request do: [ :book |
		  cart add: book.
		  (HxHtmxResponse with: (self book: book quantity: (cart quantityOf: book)))
			  addOutOfBand: (HxSpikeCartLink cart: cart);
			  yourself ]
]

{ #category : 'instance creation' }
HxSpikeAddButton class >> book: aBook [

	^ self book: aBook quantity: nil
]

{ #category : 'instance creation' }
HxSpikeAddButton class >> book: aBook quantity: anIntegerOrNil [

	^ self new setBook: aBook quantity: anIntegerOrNil
]

{ #category : 'accessing' }
HxSpikeAddButton >> book [

	^ book
]

{ #category : 'testing' }
HxSpikeAddButton >> isAdded [
	"Has the visitor just put the book in the cart?"

	^ quantity notNil
]

{ #category : 'accessing' }
HxSpikeAddButton >> quantity [

	^ quantity
]

{ #category : 'rendering' }
HxSpikeAddButton >> render [
@self isAdded
  ifTrue: [
    <button class="added" hx-post="{{ self path: #add with: book id }}" hx-swap="outerHTML">✓ In cart ({{ quantity }})</button>
  ]
  ifFalse: [
    @book isAvailable
      ifTrue: [
        <button hx-post="{{ self path: #add with: book id }}" hx-swap="outerHTML">Add to cart</button>
      ]
      ifFalse: [
        <span class="sold-out">Sold out</span>
      ]
  ]
]

{ #category : 'initialization' }
HxSpikeAddButton >> setBook: aBook quantity: anIntegerOrNil [

	book := aBook.
	quantity := anIntegerOrNil
]
