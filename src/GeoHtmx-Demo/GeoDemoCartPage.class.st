"
The cart page.
"
Class {
	#name : 'GeoDemoCartPage',
	#superclass : 'GeoPage',
	#category : 'GeoHtmx-Demo-Pages',
	#package : 'GeoHtmx-Demo',
	#tag : 'Pages'
}

{ #category : 'routing' }
GeoDemoCartPage class >> pattern [

	^ '/cart'
]

{ #category : 'accessing' }
GeoDemoCartPage >> cart [

	^ app cart
]

{ #category : 'rendering' }
GeoDemoCartPage >> render [
<h1>Cart</h1>
{{ GeoDemoCartTable cart: self cart }}
]

{ #category : 'accessing' }
GeoDemoCartPage >> title [

	^ 'Cart'
]
