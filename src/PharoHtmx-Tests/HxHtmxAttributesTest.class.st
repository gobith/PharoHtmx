Class {
	#name : 'HxHtmxAttributesTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Htmx',
	#package : 'PharoHtmx-Tests',
	#tag : 'Htmx'
}

{ #category : 'tests' }
HxHtmxAttributesTest >> testActionTakesTheMethodAndPathFromTheEndpoint [

	| hx |
	hx := (HxHtmxAttributes for: HxTestGreeter) action: #wave.
	self assert: hx attributes associations asArray equals: { ('hx-get' -> '/HxTestGreeter/wave') }.
	hx := (HxHtmxAttributes for: HxTestGreeter) action: #hello with: 'Ann'.
	self assert: (hx at: 'hx-get') equals: '/greet/Ann'.
	hx := HxHtmxAttributes new action: #whoAmI of: HxTestGreeter.
	self assert: (hx at: 'hx-post') equals: '/greet'
]

{ #category : 'tests' }
HxHtmxAttributesTest >> testCascadeInOrder [

	| hx |
	hx := HxHtmxAttributes new
		      delete: '/todos/7';
		      confirm: 'Sure?';
		      targetClosest: 'li';
		      swapOuter;
		      yourself.
	self assert: hx printString equals: 'hx-delete=''/todos/7'' hx-confirm=''Sure?'' hx-target=''closest li'' hx-swap=''outerHTML'''
]

{ #category : 'tests' }
HxHtmxAttributesTest >> testOneRequestPerElement [

	| hx |
	hx := HxHtmxAttributes new
		      get: '/a';
		      post: '/b';
		      yourself.
	self assert: hx attributes keys asArray equals: #( 'hx-post' )
]

{ #category : 'tests' }
HxHtmxAttributesTest >> testOtherAttributes [

	| hx |
	hx := HxHtmxAttributes new
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
HxHtmxAttributesTest >> testSwaps [

	#( #swapInner 'innerHTML' #swapOuter 'outerHTML' #swapBeforeBegin 'beforebegin' #swapAfterBegin 'afterbegin' #swapBeforeEnd
	   'beforeend' #swapAfterEnd 'afterend' #swapDelete 'delete' #swapNone 'none' ) pairsDo: [ :selector :value |
		self assert: ((HxHtmxAttributes new perform: selector) at: 'hx-swap') equals: value ]
]

{ #category : 'tests' }
HxHtmxAttributesTest >> testTargets [

	self assert: (HxHtmxAttributes new targetThis at: 'hx-target') equals: 'this'.
	self assert: ((HxHtmxAttributes new targetFind: '.x') at: 'hx-target') equals: 'find .x'.
	self assert: ((HxHtmxAttributes new targetNext: 'p') at: 'hx-target') equals: 'next p'.
	self assert: ((HxHtmxAttributes new targetPrevious: 'p') at: 'hx-target') equals: 'previous p'
]

{ #category : 'tests' }
HxHtmxAttributesTest >> testTriggers [

	self assert: (HxHtmxAttributes new triggerOnLoad at: 'hx-trigger') equals: 'load'.
	self assert: ((HxHtmxAttributes new triggerEvery: 2 seconds) at: 'hx-trigger') equals: 'every 2s'.
	self assert: ((HxHtmxAttributes new triggerEvery: 0.5) at: 'hx-trigger') equals: 'every 500ms'.
	self assert: (HxHtmxAttributes new triggerRevealed at: 'hx-trigger') equals: 'revealed'.
	self assert: (HxHtmxAttributes new triggerIntersectOnce at: 'hx-trigger') equals: 'intersect once'.
	self assert: ((HxHtmxAttributes new triggerOnInputDelay: 300 milliSeconds) at: 'hx-trigger') equals: 'input changed delay:300ms'.
	self assert: ((HxHtmxAttributes new triggerOn: 'pinged' from: 'body') at: 'hx-trigger') equals: 'pinged from:body'
]
