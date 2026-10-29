Class {
	#name : 'GeoHtmxResponseTest',
	#superclass : 'TestCase',
	#category : 'GeoHtmx-Tests-Tests',
	#package : 'GeoHtmx-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoHtmxResponseTest >> testAppAnswersIt [
	"A route can answer an GeoHtmxResponse; the app converts it."

	| response |
	response := GeoApp new
		            responseFor: ((GeoHtmxResponse with: '<p>hi</p>')
				             refresh;
				             yourself)
		            request: (ZnRequest get: '/').
	self assert: response contents equals: '<p>hi</p>'.
	self assert: (response headers at: 'HX-Refresh') equals: 'true'
]

{ #category : 'tests' }
GeoHtmxResponseTest >> testAsZnResponse [

	| response |
	response := (GeoHtmxResponse with: '<p>hi</p>')
		            trigger: 'x';
		            yourself.
	response := response asZnResponse.
	self assert: response isSuccess.
	self assert: response contentType equals: ZnMimeType textHtml.
	self assert: response contents equals: '<p>hi</p>'.
	self assert: (response headers at: 'HX-Trigger') equals: 'x'
]

{ #category : 'tests' }
GeoHtmxResponseTest >> testHeaders [

	| response |
	response := GeoHtmxResponse new
		            pushUrl: '/books?q=go';
		            replaceUrl: '/books';
		            redirect: '/login';
		            location: '/cart';
		            refresh;
		            retarget: '#detail';
		            reswap: 'innerHTML';
		            reselect: '#main';
		            yourself.
	self assert: response headers associations asArray equals: {
			('HX-Push-Url' -> '/books?q=go').
			('HX-Replace-Url' -> '/books').
			('HX-Redirect' -> '/login').
			('HX-Location' -> '/cart').
			('HX-Refresh' -> 'true').
			('HX-Retarget' -> '#detail').
			('HX-Reswap' -> 'innerHTML').
			('HX-Reselect' -> '#main') }
]

{ #category : 'tests' }
GeoHtmxResponseTest >> testOutOfBandMarksTheRootElement [

	| response |
	response := (GeoHtmxResponse with: '<p>main</p>')
		            addOutOfBand: '<a id="cart-link" href="/cart">Cart (2)</a>';
		            yourself.
	self assert: response contents equals: '<p>main</p><a hx-swap-oob="true" id="cart-link" href="/cart">Cart (2)</a>'
]

{ #category : 'tests' }
GeoHtmxResponseTest >> testOutOfBandWithOtherSwapIsWrapped [
	"htmx uses only the content of the marked element for any swap but outerHTML."

	| response |
	response := GeoHtmxResponse new
		            addOutOfBand: '<li>new</li>' swap: 'beforeend:#log';
		            addOutOfBand: '<p id="x">x</p>' swap: 'outerHTML';
		            yourself.
	self
		assert: response contents
		equals: '<div hx-swap-oob="beforeend:#log"><li>new</li></div><p hx-swap-oob="outerHTML" id="x">x</p>'
]

{ #category : 'tests' }
GeoHtmxResponseTest >> testTriggers [

	| response |
	response := GeoHtmxResponse new
		            trigger: 'cart-changed';
		            trigger: 'saved';
		            triggerAfterSettle: 'done';
		            yourself.
	self assert: (response headers at: 'HX-Trigger') equals: 'cart-changed, saved'.
	self assert: (response headers at: 'HX-Trigger-After-Settle') equals: 'done'.
	response := GeoHtmxResponse new
		            trigger: 'saved' with: (OrderedDictionary new
				             at: 'id' put: 3;
				             yourself);
		            trigger: 'plain';
		            yourself.
	self assert: (response headers at: 'HX-Trigger') equals: '{"saved":{"id":3},"plain":""}'
]
