"
A clock that asks the server for the time every second (polling with hx-trigger=""every 1s"").
"
Class {
	#name : 'HxSpikeClock',
	#superclass : 'HxComponent',
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
HxSpikeClock class >> tick: request [
	"The clock again, for its polling."
	<get>

	^ self new
]

{ #category : 'rendering' }
HxSpikeClock >> render [
<span class="clock"
  {{ self hx
       action: #tick:;
       triggerEvery: 1 second;
       swapOuter }}>
  {{ self time }}
</span>
]

{ #category : 'accessing' }
HxSpikeClock >> time [

	^ Time now print24
]
