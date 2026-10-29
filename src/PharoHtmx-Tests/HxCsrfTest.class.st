"
I test the CSRF check of HxApp: a request that changes something needs the token of its session, from the X-CSRF-Token header or the csrf-token form field. I also test the session cookie.
"
Class {
	#name : 'HxCsrfTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'PharoHtmx-Tests-Security',
	#package : 'PharoHtmx-Tests',
	#tag : 'Security'
}

{ #category : 'helpers' }
HxCsrfTest >> request: aZnRequest cookie: aString [

	aZnRequest headers at: 'Cookie' put: aString.
	^ aZnRequest
]

{ #category : 'helpers' }
HxCsrfTest >> sessionCookieOf: aResponse [

	^ aResponse cookies detect: [ :each | each name = app sessions cookieName ]
]

{ #category : 'running' }
HxCsrfTest >> setUp [

	super setUp.
	app := HxTestCsrfApp new
]

{ #category : 'tests' }
HxCsrfTest >> testChangeWithTokenIsAllowed [

	| visit request |
	visit := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visit key.
	request headers at: 'X-CSRF-Token' put: visit value.
	self assert: (app handleRequest: request) contents equals: 'HxTestCsrfApp'
]

{ #category : 'tests' }
HxCsrfTest >> testChangeWithoutTokenIsForbidden [

	| visit response |
	visit := self visit.
	response := app handleRequest: (self request: (ZnRequest post: '/greet') cookie: visit key).
	self assert: response status equals: 403
]

{ #category : 'tests' }
HxCsrfTest >> testCheckCanBeSwitchedOff [
	"An app that no browser uses, such as an API for other programs, may switch the check off."

	self assert: (HxTestApiApp new handleRequest: (ZnRequest post: '/greet')) isSuccess
]

{ #category : 'tests' }
HxCsrfTest >> testCookieOnlyForANewSession [

	| cookie response |
	cookie := (self sessionCookieOf: (app handleRequest: (ZnRequest get: '/greet/Ann'))) nameValueString.
	response := app handleRequest: (self request: (ZnRequest get: '/greet/Ann') cookie: cookie).
	self deny: (response headers includesKey: 'Set-Cookie')
]

{ #category : 'tests' }
HxCsrfTest >> testSafeRequestNeedsNoToken [

	self assert: (app handleRequest: (ZnRequest get: '/greet/Ann')) isSuccess
]

{ #category : 'tests' }
HxCsrfTest >> testSessionCookie [

	| response cookie |
	response := app handleRequest: (ZnRequest get: '/greet/Ann').
	cookie := response headers at: 'Set-Cookie'.
	self assert: (cookie beginsWith: 'hx-session=').
	self assert: (cookie includesSubstring: 'httponly').
	self assert: (cookie includesSubstring: 'samesite=Lax').
	self deny: (cookie includesSubstring: 'secure').
	self assert: (self sessionCookieOf: response) value size equals: 64.
	app sessions beSecure.
	self assert: (((app handleRequest: (ZnRequest get: '/greet/Ann')) headers at: 'Set-Cookie') includesSubstring: 'secure')
]

{ #category : 'tests' }
HxCsrfTest >> testTokenAsFormField [
	"A plain form without htmx sends the token as the field csrf-token."

	| visit request |
	visit := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visit key.
	request entity: (ZnApplicationFormUrlEncodedEntity new
			 at: 'csrf-token' put: visit value;
			 yourself).
	self assert: (app handleRequest: request) isSuccess
]

{ #category : 'tests' }
HxCsrfTest >> testTokenOfAnotherSessionIsForbidden [
	"An attacker's own valid token is of no use with the visitor's cookie."

	| visitor attacker request |
	visitor := self visit.
	attacker := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visitor key.
	request headers at: 'X-CSRF-Token' put: attacker value.
	self assert: (app handleRequest: request) status equals: 403
]

{ #category : 'tests' }
HxCsrfTest >> testTokenWithoutCookieIsForbidden [

	| request |
	request := ZnRequest post: '/greet'.
	request headers at: 'X-CSRF-Token' put: self visit value.
	self assert: (app handleRequest: request) status equals: 403
]

{ #category : 'tests' }
HxCsrfTest >> testWrongTokenIsForbidden [

	| visit request |
	visit := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visit key.
	request headers at: 'X-CSRF-Token' put: HxSecureRandom token.
	self assert: (app handleRequest: request) status equals: 403
]

{ #category : 'helpers' }
HxCsrfTest >> visit [
	"Visit a page; answer the cookie and the CSRF token that a browser would hold afterwards."

	| response cookie request |
	response := app handleRequest: (ZnRequest get: '/greet/Ann').
	cookie := (self sessionCookieOf: response) nameValueString.
	request := HxRequest on: (self request: (ZnRequest get: '/greet/Ann') cookie: cookie) pathParameters: Dictionary new.
	request session: (app sessions sessionFor: request znRequest).
	^ cookie -> request csrfToken
]
