Class {
	#name : 'GeoHtmxAttributesTest',
	#superclass : 'TestCase',
	#category : 'GeoHtmx-Tests-Tests',
	#package : 'GeoHtmx-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoHtmxAttributesTest >> testActionTakesTheMethodAndPathFromTheEndpoint [

	| hx |
	hx := (GeoHtmxAttributes for: GeoTestGreeter) action: #wave:.
	self assert: hx attributes associations asArray equals: { ('hx-get' -> '/GeoTestGreeter/wave') }.
	hx := (GeoHtmxAttributes for: GeoTestGreeter) action: #hello: with: 'Ann'.
	self assert: (hx at: 'hx-get') equals: '/greet/Ann'.
	hx := GeoHtmxAttributes new action: #whoAmI: of: GeoTestGreeter.
	self assert: (hx at: 'hx-post') equals: '/greet'
]

{ #category : 'tests' }
GeoHtmxAttributesTest >> testCascadeInOrder [

	| hx |
	hx := GeoHtmxAttributes new
		      delete: '/todos/7';
		      confirm: 'Sure?';
		      targetClosest: 'li';
		      swapOuter;
		      yourself.
	self assert: hx printString equals: 'hx-delete=''/todos/7'' hx-confirm=''Sure?'' hx-target=''closest li'' hx-swap=''outerHTML'''
]

{ #category : 'tests' }
GeoHtmxAttributesTest >> testOneRequestPerElement [

	| hx |
	hx := GeoHtmxAttributes new
		      get: '/a';
		      post: '/b';
		      yourself.
	self assert: hx attributes keys asArray equals: #( 'hx-post' )
]

{ #category : 'tests' }
GeoHtmxAttributesTest >> testOtherAttributes [

	| hx |
	hx := GeoHtmxAttributes new
		      prompt: 'Name?';
		      indicator: '#spinner';
		      disabledElt: 'this';
		      sync: 'this:replace';
		      pushUrl;
		      boost;
		      include: '#filters';
		      select: '#main';
		      vals: (OrderedDictionary new
				       at: 'page' put: 2;
				       yourself);
		      on: 'htmx:after-request'
		      do: 'this.reset()';
		      attribute: 'hx-ext' value: 'sse';
		      yourself.
	self assert: (hx at: 'hx-prompt') equals: 'Name?'.
	self assert: (hx at: 'hx-indicator') equals: '#spinner'.
	self assert: (hx at: 'hx-disabled-elt') equals: 'this'.
	self assert: (hx at: 'hx-sync') equals: 'this:replace'.
	self assert: (hx at: 'hx-push-url') equals: 'true'.
	self assert: (hx at: 'hx-boost') equals: 'true'.
	self assert: (hx at: 'hx-include') equals: '#filters'.
	self assert: (hx at: 'hx-select') equals: '#main'.
	self assert: (hx at: 'hx-vals') equals: '{"page":2}'.
	self assert: (hx at: 'hx-on:htmx:after-request') equals: 'this.reset()'.
	self assert: (hx at: 'hx-ext') equals: 'sse'
]

{ #category : 'tests' }
GeoHtmxAttributesTest >> testSwaps [

	#( #swapInner 'innerHTML' #swapOuter 'outerHTML' #swapBeforeBegin 'beforebegin' #swapAfterBegin 'afterbegin' #swapBeforeEnd
	   'beforeend' #swapAfterEnd 'afterend' #swapDelete 'delete' #swapNone 'none' ) pairsDo: [ :selector :value |
		self assert: ((GeoHtmxAttributes new perform: selector) at: 'hx-swap') equals: value ]
]

{ #category : 'tests' }
GeoHtmxAttributesTest >> testTargets [

	self assert: (GeoHtmxAttributes new targetThis at: 'hx-target') equals: 'this'.
	self assert: ((GeoHtmxAttributes new targetFind: '.x') at: 'hx-target') equals: 'find .x'.
	self assert: ((GeoHtmxAttributes new targetNext: 'p') at: 'hx-target') equals: 'next p'.
	self assert: ((GeoHtmxAttributes new targetPrevious: 'p') at: 'hx-target') equals: 'previous p'
]

{ #category : 'tests' }
GeoHtmxAttributesTest >> testTriggers [

	self assert: (GeoHtmxAttributes new triggerOnLoad at: 'hx-trigger') equals: 'load'.
	self assert: ((GeoHtmxAttributes new triggerEvery: 2 seconds) at: 'hx-trigger') equals: 'every 2s'.
	self assert: ((GeoHtmxAttributes new triggerEvery: 0.5) at: 'hx-trigger') equals: 'every 500ms'.
	self assert: (GeoHtmxAttributes new triggerRevealed at: 'hx-trigger') equals: 'revealed'.
	self assert: (GeoHtmxAttributes new triggerIntersectOnce at: 'hx-trigger') equals: 'intersect once'.
	self assert: ((GeoHtmxAttributes new triggerOnInputDelay: 300 milliSeconds) at: 'hx-trigger') equals: 'input changed delay:300ms'.
	self assert: ((GeoHtmxAttributes new triggerOn: 'pinged' from: 'body') at: 'hx-trigger') equals: 'pinged from:body'
]
