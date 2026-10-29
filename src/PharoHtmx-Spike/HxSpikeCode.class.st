"
The source of some methods, under a Code toggle, to show how an example on the showcase page is made.
"
Class {
	#name : 'HxSpikeCode',
	#superclass : 'HxComponent',
	#instVars : [
		'methods'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
HxSpikeCode class >> methods: aCollection [

	^ self new setMethods: aCollection
]

{ #category : 'accessing' }
HxSpikeCode >> methods [

	^ methods
]

{ #category : 'rendering' }
HxSpikeCode >> render [
<details class="code">
  <summary>Code</summary>
  @methods do: [ :method |
    <pre><code>{{ method methodClass name }} &gt;&gt; {{ method sourceCode }}</code></pre>
  ]
</details>
]

{ #category : 'initialization' }
HxSpikeCode >> setMethods: aCollection [

	methods := aCollection
]
