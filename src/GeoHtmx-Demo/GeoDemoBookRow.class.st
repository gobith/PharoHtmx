"
One book in the list: its title, which opens the detail panel, its price and its button.
"
Class {
	#name : 'GeoDemoBookRow',
	#superclass : 'GeoComponent',
	#instVars : [
		'book'
	],
	#category : 'GeoHtmx-Demo-Components',
	#package : 'GeoHtmx-Demo',
	#tag : 'Components'
}

{ #category : 'instance creation' }
GeoDemoBookRow class >> book: aBook [

	^ self new setBook: aBook
]

{ #category : 'accessing' }
GeoDemoBookRow >> book [

	^ book
]

{ #category : 'rendering' }
GeoDemoBookRow >> render [
<li id="book-{{ book id }}">
  <a href="{{ GeoDemoBookDetail pathOf: #show: with: book id }}"
    {{ self hx
         action: #show: of: GeoDemoBookDetail with: book id;
         target: '#detail' }}>
    {{ book title }}
  </a>
  <span class="price">{{ book priceString }}</span>
  {{ GeoDemoAddButton book: book }}
</li>
]

{ #category : 'initialization' }
GeoDemoBookRow >> setBook: aBook [

	book := aBook
]
