"
The number of pings. It reloads itself when the server fires the event pinged (hx-trigger=""pinged from:body"").
"
Class {
	#name : 'GeoDemoPings',
	#superclass : 'GeoComponent',
	#instVars : [
		'count'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'instance creation' }
GeoDemoPings class >> count: anInteger [

	^ self new setCount: anInteger
]

{ #category : 'endpoints' }
GeoDemoPings class >> ping: request [
	"Count a ping and fire the event pinged in the browser; nothing to swap."
	<post>

	request app showcase ping.
	^ GeoHtmxResponse new
		  trigger: 'pinged';
		  yourself
]

{ #category : 'endpoints' }
GeoDemoPings class >> reload: request [
	"The number of pings, for its reload on the event pinged."
	<get>

	^ self count: request app showcase pings
]

{ #category : 'accessing' }
GeoDemoPings >> count [

	^ count
]

{ #category : 'rendering' }
GeoDemoPings >> render [
<span id="pings"
  {{ self hx
       action: #reload:;
       triggerOn: 'pinged' from: 'body';
       swapOuter }}>
  Pings: {{ count }}
</span>
]

{ #category : 'initialization' }
GeoDemoPings >> setCount: anInteger [

	count := anInteger
]
