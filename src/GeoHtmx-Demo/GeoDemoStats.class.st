"
Figures about the books, which the showcase page loads after it has loaded itself (lazy loading with hx-trigger=""load"").
"
Class {
	#name : 'GeoDemoStats',
	#superclass : 'GeoComponent',
	#instVars : [
		'books'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
GeoDemoStats class >> books: aCollection [

	^ self new setBooks: aCollection
]

{ #category : 'endpoints' }
GeoDemoStats class >> load: request [
	"The book figures, a second late, so the loading indicator shows."
	<get>

	(Delay forSeconds: 1) wait.
	^ self books: request app catalog
]

{ #category : 'accessing' }
GeoDemoStats >> availableCount [

	^ books count: [ :each | each isAvailable ]
]

{ #category : 'accessing' }
GeoDemoStats >> averagePrice [

	^ GeoDemoBook formatCents: (books inject: 0 into: [ :sum :each | sum + each priceInCents ]) // books size
]

{ #category : 'accessing' }
GeoDemoStats >> books [

	^ books
]

{ #category : 'rendering' }
GeoDemoStats >> render [
<dl class="box stats">
  <dt>Books</dt><dd>{{ books size }}</dd>
  <dt>Available</dt><dd>{{ self availableCount }}</dd>
  <dt>Average price</dt><dd>{{ self averagePrice }}</dd>
</dl>
]

{ #category : 'initialization' }
GeoDemoStats >> setBooks: aCollection [

	books := aCollection
]
