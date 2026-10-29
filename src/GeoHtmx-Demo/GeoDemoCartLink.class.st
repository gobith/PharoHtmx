"
The link to the cart with the number of books in it. After a change to the cart, a route sends it out of band, so htmx puts it in place of the link in the header.
"
Class {
	#name : 'GeoDemoCartLink',
	#superclass : 'GeoComponent',
	#instVars : [
		'cart'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoCartLink class >> cart: aCart [

	^ self new setCart: aCart
]

{ #category : 'accessing' }
GeoDemoCartLink >> cart [

	^ cart
]

{ #category : 'rendering' }
GeoDemoCartLink >> render [
<a id="cart-link" href="{{ GeoDemoCartPage path }}">Cart ({{ cart count }})</a>
]

{ #category : 'initialization' }
GeoDemoCartLink >> setCart: aCart [

	cart := aCart
]
