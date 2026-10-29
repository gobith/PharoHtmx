"
The bar at the top of every page: the shop name, a link to the routes and the cart link.
"
Class {
	#name : 'HxSpikeHeader',
	#superclass : 'HxComponent',
	#instVars : [
		'cart'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeHeader class >> cart: aCart [

	^ self new setCart: aCart
]

{ #category : 'accessing' }
HxSpikeHeader >> cart [

	^ cart
]

{ #category : 'rendering' }
HxSpikeHeader >> render [
<header>
  <a href="{{ HxSpikeBooksPage path }}">PharoHtmx Books</a>
  <nav>
    <a class="dev" href="{{ HxSpikeShowcasePage path }}">Showcase</a>
    <a class="dev" href="{{ HxSpikeRoutesPage path }}">Routes</a>
    @self render: (HxSpikeCartLink cart: cart)
  </nav>
</header>
]

{ #category : 'initialization' }
HxSpikeHeader >> setCart: aCart [

	cart := aCart
]
