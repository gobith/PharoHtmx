"
I am the htmx attributes of one element, built with messages instead of typed by hand. A component hands me out with #hx; a {{ }} in a view writes me as attributes. Each message sets one attribute, so a cascade reads as a list of what the element does:

	<button {{ self hx
	             action: #delete: with: todo id;
	             confirm: 'Delete this item?';
	             targetClosest: 'li';
	             swapOuter }}>Delete</button>

writes

	<button hx-delete=""/showcase/todos/7"" hx-confirm=""Delete this item?"" hx-target=""closest li"" hx-swap=""outerHTML"">Delete</button>

Why messages instead of attributes:
- #action: takes the HTTP method from the endpoint's pragma, so hx-get, hx-post, hx-put and hx-delete always match the endpoint.
- A misspelt message shows up in the editor and fails when the view renders, where a misspelt attribute is ignored by the browser without a word.
- Code completion on ""self hx"" shows what htmx can do.

The groups: request (#action:, #get:, ...), target (#target:, #targetThis, ...), swap (#swapOuter, ...), trigger (#triggerEvery:, ...), feedback (#confirm:, #indicator:, ...), address bar (#pushUrl, ...), values (#vals:, #include:, ...) and events (#on:do:). #attribute:value: writes any attribute I have no message for, such as one of an htmx extension. Plain hx- attributes in the HTML still work too.
"
Class {
	#name : 'HxHtmxAttributes',
	#superclass : 'Object',
	#instVars : [
		'owner',
		'attributes'
	],
	#category : 'PharoHtmx-Htmx',
	#package : 'PharoHtmx',
	#tag : 'Htmx'
}

{ #category : 'instance creation' }
HxHtmxAttributes class >> for: aClass [
	"Attributes whose #action: messages name the endpoints of aClass, usually the component that writes them."

	^ self new setOwner: aClass
]

{ #category : 'instance creation' }
HxHtmxAttributes class >> new [
	"Attributes without an owner: use #get: and the like, or #action:of: with a class."

	^ self basicNew initialize
]

{ #category : 'request' }
HxHtmxAttributes >> action: anAction [
	"Send a request to my component's endpoint anAction when the element is triggered (a click for a button, a submit for a form). The HTTP method comes from the endpoint's pragma: <get> writes hx-get, <post> hx-post, and so on, with the endpoint's path as the value.
		self hx action: #edit:
	writes hx-get with /HxSpikeNote/edit."

	| endpoint |
	endpoint := HxEndpoint in: owner selector: anAction.
	^ self request: endpoint path: endpoint path
]

{ #category : 'request' }
HxHtmxAttributes >> action: anAction of: aComponentClass [
	"Like #action:, for an endpoint of another component.
		self hx action: #load: of: HxSpikeStats"

	| endpoint |
	endpoint := HxEndpoint in: aComponentClass selector: anAction.
	^ self request: endpoint path: endpoint path
]

{ #category : 'request' }
HxHtmxAttributes >> action: anAction of: aComponentClass with: anObject [
	"Like #action:with:, for an endpoint of another component."

	| endpoint |
	endpoint := HxEndpoint in: aComponentClass selector: anAction.
	^ self request: endpoint path: (endpoint pathWith: anObject)
]

{ #category : 'request' }
HxHtmxAttributes >> action: anAction with: anObject [
	"Like #action:, for an endpoint whose path has a parameter: anObject fills it in (a Dictionary for several). Values that are not path parameters go into the query string.
		self hx action: #delete: with: todo id
	writes hx-delete with /showcase/todos/7."

	| endpoint |
	endpoint := HxEndpoint in: owner selector: anAction.
	^ self request: endpoint path: (endpoint pathWith: anObject)
]

{ #category : 'accessing' }
HxHtmxAttributes >> at: aName [
	"The value of the attribute aName, nil when it is not set."

	^ attributes at: aName ifAbsent: [ nil ]
]

{ #category : 'accessing' }
HxHtmxAttributes >> attribute: aName value: aString [
	"Set the attribute aName to aString: the way out for what I have no message for, such as hx-ext for an htmx extension. Each message above comes down to this one."

	attributes at: aName put: aString
]

{ #category : 'accessing' }
HxHtmxAttributes >> attributes [
	"My attributes, name -> value, in the order they were set."

	^ attributes
]

{ #category : 'address bar' }
HxHtmxAttributes >> boost [
	"Let the links and forms inside this element load their page with htmx: no full reload, the address bar still changes. Writes hx-boost with true."

	^ self attribute: 'hx-boost' value: 'true'
]

{ #category : 'feedback' }
HxHtmxAttributes >> confirm: aQuestion [
	"Ask the visitor aQuestion before the request goes; Cancel stops it. Writes hx-confirm."

	^ self attribute: 'hx-confirm' value: aQuestion
]

{ #category : 'request' }
HxHtmxAttributes >> delete: aUrl [
	"Send a DELETE request to aUrl. Writes hx-delete."

	^ self method: #DELETE url: aUrl
]

{ #category : 'feedback' }
HxHtmxAttributes >> disabledElt: aSelector [
	"Disable the elements that aSelector finds while the request runs, as in 'this' against double clicks. Writes hx-disabled-elt."

	^ self attribute: 'hx-disabled-elt' value: aSelector
]

{ #category : 'request' }
HxHtmxAttributes >> get: aUrl [
	"Send a GET request to aUrl, a URL that is not an endpoint of a component. Writes hx-get."

	^ self method: #GET url: aUrl
]

{ #category : 'values' }
HxHtmxAttributes >> include: aSelector [
	"Send the values of the fields that aSelector finds along with the request, also when they are outside the form. Writes hx-include."

	^ self attribute: 'hx-include' value: aSelector
]

{ #category : 'feedback' }
HxHtmxAttributes >> indicator: aSelector [
	"Show the element that aSelector finds while the request runs, such as a spinner with the class htmx-indicator. Writes hx-indicator."

	^ self attribute: 'hx-indicator' value: aSelector
]

{ #category : 'initialization' }
HxHtmxAttributes >> initialize [

	super initialize.
	attributes := OrderedDictionary new
]

{ #category : 'private' }
HxHtmxAttributes >> method: anHttpMethod url: aUrl [
	"An element sends one request: drop any earlier one."

	#( 'hx-get' 'hx-post' 'hx-put' 'hx-patch' 'hx-delete' ) do: [ :each | attributes removeKey: each ifAbsent: [ nil ] ].
	^ self attribute: 'hx-' , anHttpMethod asLowercase value: aUrl
]

{ #category : 'events' }
HxHtmxAttributes >> on: anEventName do: aScript [
	"Run the JavaScript aScript when anEventName fires on the element, as in 'htmx:after-request' with 'this.reset()' to empty a form after it was sent. Writes hx-on: with the event name.
		self hx on: 'htmx:after-request' do: 'this.reset()'"

	^ self attribute: 'hx-on:' , anEventName value: aScript
]

{ #category : 'request' }
HxHtmxAttributes >> patch: aUrl [
	"Send a PATCH request to aUrl. Writes hx-patch."

	^ self method: #PATCH url: aUrl
]

{ #category : 'request' }
HxHtmxAttributes >> post: aUrl [
	"Send a POST request to aUrl. Writes hx-post."

	^ self method: #POST url: aUrl
]

{ #category : 'writing' }
HxHtmxAttributes >> printOn: aStream [

	attributes keys
		do: [ :name |
				aStream
					nextPutAll: name;
					nextPutAll: '=';
					print: (attributes at: name) ]
		separatedBy: [ aStream space ]
]

{ #category : 'feedback' }
HxHtmxAttributes >> prompt: aQuestion [
	"Ask the visitor aQuestion and send the answer along; an endpoint reads it with request htmx prompt. Writes hx-prompt."

	^ self attribute: 'hx-prompt' value: aQuestion
]

{ #category : 'address bar' }
HxHtmxAttributes >> pushUrl [
	"Put the URL of the request in the address bar and in the history, so Back returns to the page before. Writes hx-push-url with true."

	^ self attribute: 'hx-push-url' value: 'true'
]

{ #category : 'address bar' }
HxHtmxAttributes >> pushUrl: aUrl [
	"Put aUrl in the address bar and in the history. Writes hx-push-url."

	^ self attribute: 'hx-push-url' value: aUrl
]

{ #category : 'request' }
HxHtmxAttributes >> put: aUrl [
	"Send a PUT request to aUrl. Writes hx-put."

	^ self method: #PUT url: aUrl
]

{ #category : 'address bar' }
HxHtmxAttributes >> replaceUrl [
	"Put the URL of the request in the address bar without a new history entry. Writes hx-replace-url with true."

	^ self attribute: 'hx-replace-url' value: 'true'
]

{ #category : 'address bar' }
HxHtmxAttributes >> replaceUrl: aUrl [
	"Put aUrl in the address bar without a new history entry. Writes hx-replace-url."

	^ self attribute: 'hx-replace-url' value: aUrl
]

{ #category : 'private' }
HxHtmxAttributes >> request: anEndpoint path: aPath [

	^ self method: anEndpoint httpMethod url: aPath
]

{ #category : 'values' }
HxHtmxAttributes >> select: aSelector [
	"Use only the part of the answer that aSelector finds. Writes hx-select."

	^ self attribute: 'hx-select' value: aSelector
]

{ #category : 'initialization' }
HxHtmxAttributes >> setOwner: aClass [

	owner := aClass
]

{ #category : 'swap' }
HxHtmxAttributes >> swap: aString [
	"Say how the answer goes into the target, with any of htmx's modifiers, as in 'outerHTML transition:true'. The messages below cover the plain cases. Writes hx-swap."

	^ self attribute: 'hx-swap' value: aString
]

{ #category : 'swap' }
HxHtmxAttributes >> swapAfterBegin [
	"Put the answer inside the target, before its first child. Writes hx-swap with afterbegin."

	^ self swap: 'afterbegin'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapAfterEnd [
	"Put the answer right after the target, outside it. Writes hx-swap with afterend."

	^ self swap: 'afterend'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapBeforeBegin [
	"Put the answer in front of the target, outside it. Writes hx-swap with beforebegin."

	^ self swap: 'beforebegin'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapBeforeEnd [
	"Put the answer inside the target, after its last child: add to the end of a list. Writes hx-swap with beforeend."

	^ self swap: 'beforeend'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapDelete [
	"Remove the target, whatever the answer is. Writes hx-swap with delete."

	^ self swap: 'delete'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapInner [
	"Replace what is inside the target with the answer; the target itself stays. This is what htmx does without hx-swap. Writes hx-swap with innerHTML."

	^ self swap: 'innerHTML'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapNone [
	"Leave the page as it is; the answer only counts for its out-of-band parts and its headers, such as an event. Writes hx-swap with none."

	^ self swap: 'none'
]

{ #category : 'swap' }
HxHtmxAttributes >> swapOuter [
	"Replace the whole target, its own tag included, with the answer. Use it when the answer is the component itself. Writes hx-swap with outerHTML."

	^ self swap: 'outerHTML'
]

{ #category : 'feedback' }
HxHtmxAttributes >> sync: aString [
	"Say what happens when a request is sent while another one runs, as in 'this:replace' to drop the older one. Writes hx-sync."

	^ self attribute: 'hx-sync' value: aString
]

{ #category : 'target' }
HxHtmxAttributes >> target: aSelector [
	"Put the answer into the element that the CSS selector aSelector finds in the page, as in '#note'. Without a target, htmx puts the answer into the element that sent the request. Writes hx-target."

	^ self attribute: 'hx-target' value: aSelector
]

{ #category : 'target' }
HxHtmxAttributes >> targetClosest: aSelector [
	"Put the answer into the nearest element around this one that matches aSelector, as in 'li' for the list item a button sits in. Writes hx-target with closest and aSelector."

	^ self target: 'closest ' , aSelector
]

{ #category : 'target' }
HxHtmxAttributes >> targetFind: aSelector [
	"Put the answer into the first element inside this one that matches aSelector. Writes hx-target with find and aSelector."

	^ self target: 'find ' , aSelector
]

{ #category : 'target' }
HxHtmxAttributes >> targetNext: aSelector [
	"Put the answer into the first element after this one in the page that matches aSelector. Writes hx-target with next and aSelector."

	^ self target: 'next ' , aSelector
]

{ #category : 'target' }
HxHtmxAttributes >> targetPrevious: aSelector [
	"Put the answer into the first element before this one in the page that matches aSelector. Writes hx-target with previous and aSelector."

	^ self target: 'previous ' , aSelector
]

{ #category : 'target' }
HxHtmxAttributes >> targetThis [
	"Put the answer into the element that carries these attributes. On an outer element, every element inside inherits it, so all buttons of a component replace the component. Writes hx-target with this."

	^ self target: 'this'
]

{ #category : 'private' }
HxHtmxAttributes >> time: aDurationOrSeconds [
	"aDurationOrSeconds as htmx writes a time: 2s, 300ms. A Number is seconds."

	| milliseconds |
	milliseconds := aDurationOrSeconds isNumber
		                ifTrue: [ (aDurationOrSeconds * 1000) rounded ]
		                ifFalse: [ aDurationOrSeconds asMilliSeconds ].
	^ milliseconds \\ 1000 = 0
		  ifTrue: [ (milliseconds // 1000) printString , 's' ]
		  ifFalse: [ milliseconds printString , 'ms' ]
]

{ #category : 'trigger' }
HxHtmxAttributes >> trigger: aString [
	"Say which event sends the request, with any of htmx's modifiers, as in 'keyup changed delay:500ms'. Without a trigger, a button sends on click, a form on submit and an input on change. The messages below cover the common cases. Writes hx-trigger."

	^ self attribute: 'hx-trigger' value: aString
]

{ #category : 'trigger' }
HxHtmxAttributes >> triggerEvery: aDurationOrSeconds [
	"Send the request again and again, every aDurationOrSeconds: poll the server. A Number is seconds.
		self hx triggerEvery: 2 seconds
	writes hx-trigger with every 2s."

	^ self trigger: 'every ' , (self time: aDurationOrSeconds)
]

{ #category : 'trigger' }
HxHtmxAttributes >> triggerIntersectOnce [
	"Send the request once, when the element comes into view, also inside a box that scrolls: load the next page of a long list. Writes hx-trigger with intersect once."

	^ self trigger: 'intersect once'
]

{ #category : 'trigger' }
HxHtmxAttributes >> triggerOn: anEventName from: aSelector [
	"Send the request when anEventName fires on the element that aSelector finds, as in 'body' for an event that the server fires with HxHtmxResponse>>trigger:. Writes hx-trigger with the event and from.
		self hx triggerOn: 'pinged' from: 'body'"

	^ self trigger: anEventName , ' from:' , aSelector
]

{ #category : 'trigger' }
HxHtmxAttributes >> triggerOnInputDelay: aDurationOrSeconds [
	"Send the request while the visitor types, once they pause for aDurationOrSeconds and only when the value changed: live search. Writes hx-trigger with input changed delay.
		self hx triggerOnInputDelay: 300 milliSeconds"

	^ self trigger: 'input changed delay:' , (self time: aDurationOrSeconds)
]

{ #category : 'trigger' }
HxHtmxAttributes >> triggerOnLoad [
	"Send the request as soon as the element is in the page: load a slow part after the page itself. Writes hx-trigger with load."

	^ self trigger: 'load'
]

{ #category : 'trigger' }
HxHtmxAttributes >> triggerRevealed [
	"Send the request when the element scrolls into the window. Writes hx-trigger with revealed."

	^ self trigger: 'revealed'
]

{ #category : 'values' }
HxHtmxAttributes >> vals: aDictionary [
	"Send the values in aDictionary along with the request, as if they were form fields; an endpoint reads them with request at:. Writes hx-vals with JSON."

	^ self attribute: 'hx-vals' value: (STONJSON toString: aDictionary)
]

{ #category : 'writing' }
HxHtmxAttributes >> writeHtmlOn: anHtmlWriter [
	"Write my attributes, separated by spaces, where a {{ }} stands for me in a tag. The values are escaped."

	attributes keys do: [ :name | anHtmlWriter attribute: name value: (attributes at: name) ] separatedBy: [ anHtmlWriter raw: ' ' ]
]
