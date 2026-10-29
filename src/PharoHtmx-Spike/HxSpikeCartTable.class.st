"
The contents of the cart, with buttons to change it; each button replaces the whole table.
"
Class {
	#name : 'HxSpikeCartTable',
	#superclass : 'HxComponent',
	#instVars : [
		'cart'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeCartTable class >> cart: aCart [

	^ self new setCart: aCart
]

{ #category : 'helpers' }
HxSpikeCartTable class >> changed: aCart [
	"The table again, plus the cart link in the header, out of band."

	^ (HxHtmxResponse with: (self cart: aCart))
		  addOutOfBand: (HxSpikeCartLink cart: aCart);
		  yourself
]

{ #category : 'endpoints' }
HxSpikeCartTable class >> clear: request [
	"Empty the cart."
	<post: '/cart/clear'>

	request app cart removeAll.
	^ self changed: request app cart
]

{ #category : 'endpoints' }
HxSpikeCartTable class >> decrement: request [
	"One less of a book; the line goes at zero."
	<post: '/cart/<id>/decrement'>

	^ request app withBookFrom: request do: [ :book |
		  request app cart decrement: book.
		  self changed: request app cart ]
]

{ #category : 'endpoints' }
HxSpikeCartTable class >> increment: request [
	"One more of a book."
	<post: '/cart/<id>/increment'>

	^ request app withBookFrom: request do: [ :book |
		  request app cart add: book.
		  self changed: request app cart ]
]

{ #category : 'endpoints' }
HxSpikeCartTable class >> remove: request [
	"Take a book out of the cart."
	<post: '/cart/<id>/remove'>

	^ request app withBookFrom: request do: [ :book |
		  request app cart remove: book.
		  self changed: request app cart ]
]

{ #category : 'accessing' }
HxSpikeCartTable >> cart [

	^ cart
]

{ #category : 'rendering' }
HxSpikeCartTable >> render [
<section id="cart" hx-target="this" hx-swap="outerHTML">
  @cart isEmpty
    ifTrue: [
      <p>Your cart is empty. <a href="{{ HxSpikeBooksPage path }}">Continue shopping</a></p>
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
                <button hx-post="{{ self path: #decrement with: line book id }}">−</button>
                {{ line quantity }}
                <button hx-post="{{ self path: #increment with: line book id }}">+</button>
              </td>
              <td class="num">{{ line totalString }}</td>
              <td class="num"><button hx-post="{{ self path: #remove with: line book id }}">Remove</button></td>
            </tr>
          ]
        </tbody>
        <tfoot>
          <tr><th>Total</th><th class="num">{{ cart count }}</th><th class="num">{{ cart totalString }}</th><th></th></tr>
        </tfoot>
      </table>
      <button hx-post="{{ self path: #clear }}" hx-confirm="Empty the cart?">Empty cart</button>
    ]
</section>
]

{ #category : 'initialization' }
HxSpikeCartTable >> setCart: aCart [

	cart := aCart
]
