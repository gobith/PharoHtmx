"
A clock that asks the server for the time every second (polling with hx-trigger=""every 1s"").
"
Class {
	#name : 'GeoDemoClock',
	#superclass : 'GeoComponent',
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
GeoDemoClock class >> tick: request [
	"The clock again, for its polling."
	<get>

	^ self new
]

{ #category : 'rendering' }
GeoDemoClock >> render [
<span class="clock"
  {{ self hx
       action: #tick:;
       triggerEvery: 1 second;
       swapOuter }}>
  {{ self time }}
</span>
]

{ #category : 'accessing' }
GeoDemoClock >> time [

	^ Time now print24
]
