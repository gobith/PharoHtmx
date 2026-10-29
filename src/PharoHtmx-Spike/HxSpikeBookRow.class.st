"
One book in the list: its title, which opens the detail panel, its price and its button.
"
Class {
	#name : 'HxSpikeBookRow',
	#superclass : 'HxComponent',
	#instVars : [
		'book'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeBookRow class >> book: aBook [

	^ self new setBook: aBook
]

{ #category : 'accessing' }
HxSpikeBookRow >> book [

	^ book
]

{ #category : 'rendering' }
HxSpikeBookRow >> render [
<li id="book-{{ book id }}">
  <a href="{{ HxSpikeBookDetail pathOf: #show: with: book id }}"
    {{ self hx
         action: #show: of: HxSpikeBookDetail with: book id;
         target: '#detail' }}>
    {{ book title }}
  </a>
  <span class="price">{{ book priceString }}</span>
  {{ HxSpikeAddButton book: book }}
</li>
]

{ #category : 'initialization' }
HxSpikeBookRow >> setBook: aBook [

	book := aBook
]
