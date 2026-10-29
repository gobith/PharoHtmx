"
The number of pings. It reloads itself when the server fires the event pinged (hx-trigger=""pinged from:body"").
"
Class {
	#name : 'HxSpikePings',
	#superclass : 'HxComponent',
	#instVars : [
		'count'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
HxSpikePings class >> count: anInteger [

	^ self new setCount: anInteger
]

{ #category : 'endpoints' }
HxSpikePings class >> ping: request [
	"Count a ping and fire the event pinged in the browser; nothing to swap."
	<post>

	request app showcase ping.
	^ HxHtmxResponse new
		  trigger: 'pinged';
		  yourself
]

{ #category : 'endpoints' }
HxSpikePings class >> reload: request [
	"The number of pings, for its reload on the event pinged."
	<get>

	^ self count: request app showcase pings
]

{ #category : 'accessing' }
HxSpikePings >> count [

	^ count
]

{ #category : 'rendering' }
HxSpikePings >> render [
<span id="pings" hx-get="{{ self path: #reload }}" hx-trigger="pinged from:body" hx-swap="outerHTML">Pings: {{ count }}</span>
]

{ #category : 'initialization' }
HxSpikePings >> setCount: anInteger [

	count := anInteger
]
