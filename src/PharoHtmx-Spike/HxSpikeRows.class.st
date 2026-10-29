"
One page of a long list, ending in a row that loads the next page when it scrolls into view (infinite scroll with hx-trigger=""intersect once"").
"
Class {
	#name : 'HxSpikeRows',
	#superclass : 'HxComponent',
	#instVars : [
		'catalog',
		'page'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
HxSpikeRows class >> catalog: aCollection page: anInteger [

	^ self new setCatalog: aCollection page: anInteger
]

{ #category : 'endpoints' }
HxSpikeRows class >> more: request [
	"One page of the long list, for infinite scroll."
	<get>

	| page |
	page := ((request at: #page ifAbsent: [ '1' ]) asInteger ifNil: [ 1 ]) max: 1.
	^ self catalog: request app catalog page: page
]

{ #category : 'accessing' }
HxSpikeRows >> bookAt: anInteger [

	^ catalog at: anInteger - 1 \\ catalog size + 1
]

{ #category : 'accessing' }
HxSpikeRows >> catalog [

	^ catalog
]

{ #category : 'accessing' }
HxSpikeRows >> first [

	^ page - 1 * self pageSize + 1
]

{ #category : 'accessing' }
HxSpikeRows >> hasMore [

	^ self last < self total
]

{ #category : 'accessing' }
HxSpikeRows >> last [

	^ self first + self pageSize - 1 min: self total
]

{ #category : 'accessing' }
HxSpikeRows >> page [

	^ page
]

{ #category : 'accessing' }
HxSpikeRows >> pageSize [

	^ 10
]

{ #category : 'rendering' }
HxSpikeRows >> render [
@(self first to: self last) do: [ :n |
  <tr><td class="num">{{ n }}</td><td>{{ (self bookAt: n) title }}</td></tr>
]
@self hasMore
  ifTrue: [
    <tr hx-get="{{ self path: #more }}?page={{ page + 1 }}" hx-trigger="intersect once" hx-swap="outerHTML">
      <td colspan="2" class="muted">Loading more…</td>
    </tr>
  ]
]

{ #category : 'initialization' }
HxSpikeRows >> setCatalog: aCollection page: anInteger [

	catalog := aCollection.
	page := anInteger
]

{ #category : 'accessing' }
HxSpikeRows >> total [
	"The list repeats the catalog to make it long."

	^ 60
]
