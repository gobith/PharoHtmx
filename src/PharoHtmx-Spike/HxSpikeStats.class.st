"
Figures about the books, which the showcase page loads after it has loaded itself (lazy loading with hx-trigger=""load"").
"
Class {
	#name : 'HxSpikeStats',
	#superclass : 'HxComponent',
	#instVars : [
		'books'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
HxSpikeStats class >> books: aCollection [

	^ self new setBooks: aCollection
]

{ #category : 'endpoints' }
HxSpikeStats class >> load: request [
	"The book figures, a second late, so the loading indicator shows."
	<get>

	(Delay forSeconds: 1) wait.
	^ self books: request app catalog
]

{ #category : 'accessing' }
HxSpikeStats >> availableCount [

	^ books count: [ :each | each isAvailable ]
]

{ #category : 'accessing' }
HxSpikeStats >> averagePrice [

	^ HxSpikeBook formatCents: (books inject: 0 into: [ :sum :each | sum + each priceInCents ]) // books size
]

{ #category : 'accessing' }
HxSpikeStats >> books [

	^ books
]

{ #category : 'rendering' }
HxSpikeStats >> render [
<dl class="box stats">
  <dt>Books</dt><dd>{{ books size }}</dd>
  <dt>Available</dt><dd>{{ self availableCount }}</dd>
  <dt>Average price</dt><dd>{{ self averagePrice }}</dd>
</dl>
]

{ #category : 'initialization' }
HxSpikeStats >> setBooks: aCollection [

	books := aCollection
]
