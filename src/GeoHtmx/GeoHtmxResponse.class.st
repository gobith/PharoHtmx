"
I am an answer to an htmx request: the HTML for the target, the components htmx should swap elsewhere out of band, and the response headers with which the server steers htmx. A route or page answers me from #handle.

	^ (GeoHtmxResponse with: (AddButton book: book))
		  addOutOfBand: (CartLink cart: cart);
		  trigger: 'cart-changed';
		  yourself

The parts:
- #add: a component or a String of HTML, for the element htmx targets.
- #addOutOfBand: a component whose root element has an id; I mark it with hx-swap-oob, so htmx puts it in place of the element with the same id. #addOutOfBand:swap: takes another swap, as in 'beforeend:#log'. htmx then uses only the content of the marked element, so I wrap the component in a div that carries hx-swap-oob.

The headers:
- #pushUrl: and #replaceUrl: change the address bar, with or without a history entry.
- #redirect: sends the browser to another page; #location: does so with an htmx request, without a full reload; #refresh reloads the page.
- #retarget:, #reswap: and #reselect: override hx-target, hx-swap and hx-select of the element that sent the request.
- #trigger:, #triggerAfterSwap: and #triggerAfterSettle: fire an event in the browser, with #trigger:with: and the like adding details as JSON.
"
Class {
	#name : 'GeoHtmxResponse',
	#superclass : 'Object',
	#instVars : [
		'parts',
		'outOfBand',
		'headers',
		'triggers'
	],
	#category : 'GeoHtmx-Htmx',
	#package : 'GeoHtmx',
	#tag : 'Htmx'
}

{ #category : 'instance creation' }
GeoHtmxResponse class >> with: aComponentOrString [

	^ self new add: aComponentOrString; yourself
]

{ #category : 'content' }
GeoHtmxResponse >> add: aComponentOrString [
	"Add HTML for the element htmx targets."

	parts add: aComponentOrString
]

{ #category : 'content' }
GeoHtmxResponse >> addOutOfBand: aComponent [
	"htmx puts aComponent in place of the element with the id of its root element."

	self addOutOfBand: aComponent swap: 'true'
]

{ #category : 'content' }
GeoHtmxResponse >> addOutOfBand: aComponentOrString swap: aString [
	"htmx swaps aComponentOrString elsewhere in the page, as aString says: 'true' for the element with the same id, or a swap and a selector, as in 'beforeend:#log'."

	outOfBand add: aComponentOrString -> aString
]

{ #category : 'converting' }
GeoHtmxResponse >> asZnResponse [

	| response |
	response := ZnResponse ok: (ZnEntity html: self contents).
	self headers keysAndValuesDo: [ :name :value | response headers at: name put: value ].
	^ response
]

{ #category : 'accessing' }
GeoHtmxResponse >> contents [
	"The HTML: the parts for the target, then the out-of-band parts."

	^ String streamContents: [ :stream |
		  parts do: [ :each | stream nextPutAll: (self htmlOf: each) ].
		  outOfBand do: [ :each | stream nextPutAll: (self markOutOfBand: (self htmlOf: each key) swap: each value) ] ]
]

{ #category : 'headers' }
GeoHtmxResponse >> headerAt: aName put: aString [

	headers at: aName put: aString
]

{ #category : 'accessing' }
GeoHtmxResponse >> headers [
	"All my response headers, the events included."

	| all |
	all := headers copy.
	triggers keysAndValuesDo: [ :header :events |
		all at: header put: ((events allSatisfy: [ :each | each isNil ])
			ifTrue: [ ', ' join: events keys ]
			ifFalse: [ STONJSON toString: (events collect: [ :each | each ifNil: [ '' ] ]) ]) ].
	^ all
]

{ #category : 'private' }
GeoHtmxResponse >> htmlOf: aComponentOrString [

	^ aComponentOrString isString
		  ifTrue: [ aComponentOrString ]
		  ifFalse: [ aComponentOrString toHtml ]
]

{ #category : 'initialization' }
GeoHtmxResponse >> initialize [

	super initialize.
	parts := OrderedCollection new.
	outOfBand := OrderedCollection new.
	headers := OrderedDictionary new.
	triggers := OrderedDictionary new
]

{ #category : 'headers' }
GeoHtmxResponse >> location: aString [
	"Load aString with an htmx request, as a boosted link would: no full page load."

	self headerAt: 'HX-Location' put: aString
]

{ #category : 'private' }
GeoHtmxResponse >> markOutOfBand: aString swap: aSwap [
	"Mark aString for an out-of-band swap. For true and outerHTML, htmx swaps the element itself, so I put hx-swap-oob on its first element. For any other swap htmx uses only the content of the marked element, so I wrap aString in a div that carries hx-swap-oob. (Table rows cannot sit in a div; give those an id and swap them with true.)"

	| attribute start nameEnd |
	attribute := ' hx-swap-oob="' , (aSwap copyReplaceAll: '"' with: '&quot;') , '"'.
	(aSwap = 'true' or: [ aSwap beginsWith: 'outerHTML' ]) ifFalse: [ ^ '<div' , attribute , '>' , aString , '</div>' ].
	start := (1 to: aString size - 1)
		         detect: [ :i | (aString at: i) = $< and: [ (aString at: i + 1) isLetter ] ]
		         ifNone: [ ^ self error: 'An out-of-band part needs an element to put hx-swap-oob on' ].
	nameEnd := (start + 1 to: aString size)
		           detect: [ :i | (aString at: i) isSeparator or: [ '/>' includes: (aString at: i) ] ]
		           ifNone: [ aString size + 1 ].
	^ (aString copyFrom: 1 to: nameEnd - 1) , attribute , (aString copyFrom: nameEnd to: aString size)
]

{ #category : 'headers' }
GeoHtmxResponse >> pushUrl: aString [
	"Put aString in the address bar and add it to the history."

	self headerAt: 'HX-Push-Url' put: aString
]

{ #category : 'headers' }
GeoHtmxResponse >> redirect: aString [
	"Send the browser to aString with a full page load."

	self headerAt: 'HX-Redirect' put: aString
]

{ #category : 'headers' }
GeoHtmxResponse >> refresh [
	"Reload the whole page."

	self headerAt: 'HX-Refresh' put: 'true'
]

{ #category : 'headers' }
GeoHtmxResponse >> replaceUrl: aString [
	"Put aString in the address bar without a new history entry."

	self headerAt: 'HX-Replace-Url' put: aString
]

{ #category : 'headers' }
GeoHtmxResponse >> reselect: aSelector [
	"Swap only the part of the answer that aSelector selects."

	self headerAt: 'HX-Reselect' put: aSelector
]

{ #category : 'headers' }
GeoHtmxResponse >> reswap: aString [
	"Swap the answer as aString says, as in 'beforeend', instead of the hx-swap of the element."

	self headerAt: 'HX-Reswap' put: aString
]

{ #category : 'headers' }
GeoHtmxResponse >> retarget: aSelector [
	"Swap the answer into aSelector instead of the hx-target of the element."

	self headerAt: 'HX-Retarget' put: aSelector
]

{ #category : 'events' }
GeoHtmxResponse >> trigger: anEventName [
	"Fire anEventName in the browser as soon as the answer arrives."

	self trigger: anEventName with: nil
]

{ #category : 'events' }
GeoHtmxResponse >> trigger: anEventName with: aDictionaryOrNil [
	"Fire anEventName with aDictionaryOrNil as its detail, as soon as the answer arrives."

	self triggerHeader: 'HX-Trigger' event: anEventName with: aDictionaryOrNil
]

{ #category : 'events' }
GeoHtmxResponse >> triggerAfterSettle: anEventName [
	"Fire anEventName after htmx has settled the page."

	self triggerHeader: 'HX-Trigger-After-Settle' event: anEventName with: nil
]

{ #category : 'events' }
GeoHtmxResponse >> triggerAfterSwap: anEventName [
	"Fire anEventName after htmx has swapped the answer in."

	self triggerHeader: 'HX-Trigger-After-Swap' event: anEventName with: nil
]

{ #category : 'events' }
GeoHtmxResponse >> triggerHeader: aHeader event: anEventName with: aDictionaryOrNil [

	(triggers at: aHeader ifAbsentPut: [ OrderedDictionary new ]) at: anEventName put: aDictionaryOrNil
]
