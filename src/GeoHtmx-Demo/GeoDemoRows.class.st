"
One page of a long list, ending in a row that loads the next page when it scrolls into view (infinite scroll with hx-trigger=""intersect once"").
"
Class {
	#name : 'GeoDemoRows',
	#superclass : 'GeoComponent',
	#instVars : [
		'catalog',
		'page'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
GeoDemoRows class >> catalog: aCollection page: anInteger [

	^ self new setCatalog: aCollection page: anInteger
]

{ #category : 'endpoints' }
GeoDemoRows class >> more: request [
	"One page of the long list, for infinite scroll."
	<get>

	| page |
	page := ((request at: #page ifAbsent: [ '1' ]) asInteger ifNil: [ 1 ]) max: 1.
	^ self catalog: request app catalog page: page
]

{ #category : 'accessing' }
GeoDemoRows >> bookAt: anInteger [

	^ catalog at: anInteger - 1 \\ catalog size + 1
]

{ #category : 'accessing' }
GeoDemoRows >> catalog [

	^ catalog
]

{ #category : 'accessing' }
GeoDemoRows >> first [

	^ page - 1 * self pageSize + 1
]

{ #category : 'accessing' }
GeoDemoRows >> hasMore [

	^ self last < self total
]

{ #category : 'accessing' }
GeoDemoRows >> last [

	^ self first + self pageSize - 1 min: self total
]

{ #category : 'accessing' }
GeoDemoRows >> page [

	^ page
]

{ #category : 'accessing' }
GeoDemoRows >> pageSize [

	^ 10
]

{ #category : 'rendering' }
GeoDemoRows >> render [
@(self first to: self last) do: [ :n |
  <tr><td class="num">{{ n }}</td><td>{{ (self bookAt: n) title }}</td></tr>
]
@self hasMore
  ifTrue: [
    <tr
      {{ self hx
           action: #more: with: (Dictionary with: #page -> (page + 1));
           triggerIntersectOnce;
           swapOuter }}>
      <td colspan="2" class="muted">Loading more…</td>
    </tr>
  ]
]

{ #category : 'initialization' }
GeoDemoRows >> setCatalog: aCollection page: anInteger [

	catalog := aCollection.
	page := anInteger
]

{ #category : 'accessing' }
GeoDemoRows >> total [
	"The list repeats the catalog to make it long."

	^ 60
]
