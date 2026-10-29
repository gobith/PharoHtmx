"
The cart page.
"
Class {
	#name : 'HxSpikeCartPage',
	#superclass : 'HxPage',
	#category : 'PharoHtmx-Spike-Pages',
	#package : 'PharoHtmx-Spike',
	#tag : 'Pages'
}

{ #category : 'routing' }
HxSpikeCartPage class >> pattern [

	^ '/cart'
]

{ #category : 'accessing' }
HxSpikeCartPage >> cart [

	^ app cart
]

{ #category : 'rendering' }
HxSpikeCartPage >> render [
<h1>Cart</h1>
{{ HxSpikeCartTable cart: self cart }}
]

{ #category : 'accessing' }
HxSpikeCartPage >> title [

	^ 'Cart'
]
