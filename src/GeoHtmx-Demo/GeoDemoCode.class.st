"
The code of an example on the showcase page, under a toggle: the source of its methods on the left and the HTML its components write on the right.
"
Class {
	#name : 'GeoDemoCode',
	#superclass : 'GeoComponent',
	#instVars : [
		'methods',
		'examples'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
GeoDemoCode class >> methods: aCollection examples: aCollectionOfComponents [
	"Show the source of aCollection of methods next to the HTML that aCollectionOfComponents write."

	^ self new setMethods: aCollection examples: aCollectionOfComponents
]

{ #category : 'accessing' }
GeoDemoCode >> examples [

	^ examples
]

{ #category : 'accessing' }
GeoDemoCode >> methods [

	^ methods
]

{ #category : 'rendering' }
GeoDemoCode >> render [
<details class="code">
  <summary>Code and HTML</summary>
  <div class="code-grid">
    <div>
      <h3>Smalltalk</h3>
      @methods do: [ :method |
        <pre><code>{{ method methodClass name }} &gt;&gt; {{ method sourceCode }}</code></pre>
      ]
    </div>
    <div>
      <h3>HTML</h3>
      @examples do: [ :example |
        <pre><code>{{ example toHtml }}</code></pre>
      ]
    </div>
  </div>
</details>
]

{ #category : 'initialization' }
GeoDemoCode >> setMethods: aCollection examples: aCollectionOfComponents [

	methods := aCollection.
	examples := aCollectionOfComponents
]
