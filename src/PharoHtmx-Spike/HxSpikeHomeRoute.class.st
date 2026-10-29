"
Send the visitor on to the book list.
"
Class {
	#name : 'HxSpikeHomeRoute',
	#superclass : 'HxRoute',
	#category : 'PharoHtmx-Spike-Routes',
	#package : 'PharoHtmx-Spike',
	#tag : 'Routes'
}

{ #category : 'routing' }
HxSpikeHomeRoute class >> pattern [

	^ '/'
]

{ #category : 'handling' }
HxSpikeHomeRoute >> handle [

	^ ZnResponse redirect: HxSpikeBooksPage path
]
