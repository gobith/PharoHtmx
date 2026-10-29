"
The code of an example on the showcase page, under a toggle: the source of its methods on the left and the HTML its components write on the right.
"
Class {
	#name : 'HxSpikeCode',
	#superclass : 'HxComponent',
	#instVars : [
		'methods',
		'examples'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
HxSpikeCode class >> methods: aCollection examples: aCollectionOfComponents [
	"Show the source of aCollection of methods next to the HTML that aCollectionOfComponents write."

	^ self new setMethods: aCollection examples: aCollectionOfComponents
]

{ #category : 'accessing' }
HxSpikeCode >> examples [

	^ examples
]

{ #category : 'accessing' }
HxSpikeCode >> methods [

	^ methods
]

{ #category : 'rendering' }
HxSpikeCode >> render [
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
HxSpikeCode >> setMethods: aCollection examples: aCollectionOfComponents [

	methods := aCollection.
	examples := aCollectionOfComponents
]
