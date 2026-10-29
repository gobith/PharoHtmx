"
The contents of the cart, with buttons to change it; each button replaces the whole table.
"
Class {
	#name : 'GeoDemoCartTable',
	#superclass : 'GeoComponent',
	#instVars : [
		'cart'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoCartTable class >> cart: aCart [

	^ self new setCart: aCart
]

{ #category : 'helpers' }
GeoDemoCartTable class >> changed: aCart [
	"The table again, plus the cart link in the header, out of band."

	^ (GeoHtmxResponse with: (self cart: aCart))
		  addOutOfBand: (GeoDemoCartLink cart: aCart);
		  yourself
]

{ #category : 'endpoints' }
GeoDemoCartTable class >> clear: request [
	"Empty the cart."
	<post: '/cart/clear'>

	request app cart removeAll.
	^ self changed: request app cart
]

{ #category : 'endpoints' }
GeoDemoCartTable class >> decrement: request [
	"One less of a book; the line goes at zero."
	<post: '/cart/<id>/decrement'>

	^ request app withBookFrom: request do: [ :book |
		  request app cart decrement: book.
		  self changed: request app cart ]
]

{ #category : 'endpoints' }
GeoDemoCartTable class >> increment: request [
	"One more of a book."
	<post: '/cart/<id>/increment'>

	^ request app withBookFrom: request do: [ :book |
		  request app cart add: book.
		  self changed: request app cart ]
]

{ #category : 'endpoints' }
GeoDemoCartTable class >> remove: request [
	"Take a book out of the cart."
	<post: '/cart/<id>/remove'>

	^ request app withBookFrom: request do: [ :book |
		  request app cart remove: book.
		  self changed: request app cart ]
]

{ #category : 'accessing' }
GeoDemoCartTable >> cart [

	^ cart
]

{ #category : 'rendering' }
GeoDemoCartTable >> render [
<section id="cart" {{ self hx targetThis; swapOuter }}>
  @cart isEmpty
    ifTrue: [
      <p>Your cart is empty. <a href="{{ GeoDemoBooksPage path }}">Continue shopping</a></p>
    ]
    ifFalse: [
      <table>
        <thead>
          <tr><th>Book</th><th class="num">Quantity</th><th class="num">Amount</th><th></th></tr>
        </thead>
        <tbody>
          @cart lines do: [ :line |
            <tr>
              <td>{{ line book title }}</td>
              <td class="num">
                <button {{ self hx action: #decrement: with: line book id }}>−</button>
                {{ line quantity }}
                <button {{ self hx action: #increment: with: line book id }}>+</button>
              </td>
              <td class="num">{{ line totalString }}</td>
              <td class="num"><button {{ self hx action: #remove: with: line book id }}>Remove</button></td>
            </tr>
          ]
        </tbody>
        <tfoot>
          <tr><th>Total</th><th class="num">{{ cart count }}</th><th class="num">{{ cart totalString }}</th><th></th></tr>
        </tfoot>
      </table>
      <button
        {{ self hx
             action: #clear:;
             confirm: 'Empty the cart?' }}>
        Empty cart
      </button>
    ]
</section>
]

{ #category : 'initialization' }
GeoDemoCartTable >> setCart: aCart [

	cart := aCart
]
