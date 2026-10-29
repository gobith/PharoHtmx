"
The button that puts a book in the cart, or a note that it is sold out. After a click it shows how many are in the cart.
"
Class {
	#name : 'GeoDemoAddButton',
	#superclass : 'GeoComponent',
	#instVars : [
		'book',
		'quantity'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'endpoints' }
GeoDemoAddButton class >> add: request [
	"Put a book in the cart; answer the new button and, out of band, the cart link."
	<post: '/cart/<id>'>

	| cart |
	cart := request app cart.
	^ request app withBookFrom: request do: [ :book |
		  cart add: book.
		  (GeoHtmxResponse with: (self book: book quantity: (cart quantityOf: book)))
			  addOutOfBand: (GeoDemoCartLink cart: cart);
			  yourself ]
]

{ #category : 'instance creation' }
GeoDemoAddButton class >> book: aBook [

	^ self book: aBook quantity: nil
]

{ #category : 'instance creation' }
GeoDemoAddButton class >> book: aBook quantity: anIntegerOrNil [

	^ self new setBook: aBook quantity: anIntegerOrNil
]

{ #category : 'htmx' }
GeoDemoAddButton >> addAction [
	"Both buttons put the book in the cart; the answer replaces the button."

	^ self hx
		  action: #add: with: book id;
		  swapOuter
]

{ #category : 'accessing' }
GeoDemoAddButton >> book [

	^ book
]

{ #category : 'testing' }
GeoDemoAddButton >> isAdded [
	"Has the visitor just put the book in the cart?"

	^ quantity notNil
]

{ #category : 'accessing' }
GeoDemoAddButton >> quantity [

	^ quantity
]

{ #category : 'rendering' }
GeoDemoAddButton >> render [
@self isAdded
  ifTrue: [
    <button class="added" {{ self addAction }}>✓ In cart ({{ quantity }})</button>
  ]
  ifFalse: [
    @book isAvailable
      ifTrue: [
        <button {{ self addAction }}>Add to cart</button>
      ]
      ifFalse: [
        <span class="sold-out">Sold out</span>
      ]
  ]
]

{ #category : 'initialization' }
GeoDemoAddButton >> setBook: aBook quantity: anIntegerOrNil [

	book := aBook.
	quantity := anIntegerOrNil
]
