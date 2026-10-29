"
The link to the cart with the number of books in it. After a change to the cart, a route sends it out of band, so htmx puts it in place of the link in the header.
"
Class {
	#name : 'HxSpikeCartLink',
	#superclass : 'HxComponent',
	#instVars : [
		'cart'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeCartLink class >> cart: aCart [

	^ self new setCart: aCart
]

{ #category : 'accessing' }
HxSpikeCartLink >> cart [

	^ cart
]

{ #category : 'rendering' }
HxSpikeCartLink >> render [
<a id="cart-link" href="{{ HxSpikeCartPage path }}">Cart ({{ cart count }})</a>
]

{ #category : 'initialization' }
HxSpikeCartLink >> setCart: aCart [

	cart := aCart
]
