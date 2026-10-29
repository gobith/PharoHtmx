"
The bar at the top of every page: the shop name, a link to the routes and the cart link.
"
Class {
	#name : 'GeoDemoHeader',
	#superclass : 'GeoComponent',
	#instVars : [
		'cart'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoHeader class >> cart: aCart [

	^ self new setCart: aCart
]

{ #category : 'accessing' }
GeoDemoHeader >> cart [

	^ cart
]

{ #category : 'rendering' }
GeoDemoHeader >> render [
<header>
  <a href="{{ GeoDemoBooksPage path }}">PharoHtmx Books</a>
  <nav>
    <a class="dev" href="{{ GeoDemoShowcasePage path }}">Showcase</a>
    <a class="dev" href="{{ GeoDemoRoutesPage path }}">Routes</a>
    {{ GeoDemoCartLink cart: cart }}
  </nav>
</header>
]

{ #category : 'initialization' }
GeoDemoHeader >> setCart: aCart [

	cart := aCart
]
