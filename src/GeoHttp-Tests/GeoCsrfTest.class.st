"
I test the CSRF check of GeoApp: a request that changes something needs the token of its session, from the X-CSRF-Token header or the csrf-token form field. I also test the session cookie.
"
Class {
	#name : 'GeoCsrfTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'helpers' }
GeoCsrfTest >> request: aZnRequest cookie: aString [

	aZnRequest headers at: 'Cookie' put: aString.
	^ aZnRequest
]

{ #category : 'helpers' }
GeoCsrfTest >> sessionCookieOf: aResponse [

	^ aResponse cookies detect: [ :each | each name = app sessions cookieName ]
]

{ #category : 'running' }
GeoCsrfTest >> setUp [

	super setUp.
	app := GeoTestCsrfApp new
]

{ #category : 'tests' }
GeoCsrfTest >> testChangeWithTokenIsAllowed [

	| visit request |
	visit := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visit key.
	request headers at: 'X-CSRF-Token' put: visit value.
	self assert: (app handleRequest: request) contents equals: 'GeoTestCsrfApp'
]

{ #category : 'tests' }
GeoCsrfTest >> testChangeWithoutTokenIsForbidden [

	| visit response |
	visit := self visit.
	response := app handleRequest: (self request: (ZnRequest post: '/greet') cookie: visit key).
	self assert: response status equals: 403
]

{ #category : 'tests' }
GeoCsrfTest >> testCheckCanBeSwitchedOff [
	"An app that no browser uses, such as an API for other programs, may switch the check off."

	self assert: (GeoTestApiApp new handleRequest: (ZnRequest post: '/greet')) isSuccess
]

{ #category : 'tests' }
GeoCsrfTest >> testCookieOnlyForANewSession [

	| cookie response |
	cookie := (self sessionCookieOf: (app handleRequest: (ZnRequest get: '/greet/Ann'))) nameValueString.
	response := app handleRequest: (self request: (ZnRequest get: '/greet/Ann') cookie: cookie).
	self deny: (response headers includesKey: 'Set-Cookie')
]

{ #category : 'tests' }
GeoCsrfTest >> testSafeRequestNeedsNoToken [

	self assert: (app handleRequest: (ZnRequest get: '/greet/Ann')) isSuccess
]

{ #category : 'tests' }
GeoCsrfTest >> testSessionCookie [

	| response cookie |
	response := app handleRequest: (ZnRequest get: '/greet/Ann').
	cookie := response headers at: 'Set-Cookie'.
	self assert: (cookie beginsWith: 'geo-session=').
	self assert: (cookie includesSubstring: 'httponly').
	self assert: (cookie includesSubstring: 'samesite=Lax').
	self deny: (cookie includesSubstring: 'secure').
	self assert: (self sessionCookieOf: response) value size equals: 64.
	app sessions beSecure.
	self assert: (((app handleRequest: (ZnRequest get: '/greet/Ann')) headers at: 'Set-Cookie') includesSubstring: 'secure')
]

{ #category : 'tests' }
GeoCsrfTest >> testTokenAsFormField [
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
GeoCsrfTest >> testTokenOfAnotherSessionIsForbidden [
	"An attacker's own valid token is of no use with the visitor's cookie."

	| visitor attacker request |
	visitor := self visit.
	attacker := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visitor key.
	request headers at: 'X-CSRF-Token' put: attacker value.
	self assert: (app handleRequest: request) status equals: 403
]

{ #category : 'tests' }
GeoCsrfTest >> testTokenWithoutCookieIsForbidden [

	| request |
	request := ZnRequest post: '/greet'.
	request headers at: 'X-CSRF-Token' put: self visit value.
	self assert: (app handleRequest: request) status equals: 403
]

{ #category : 'tests' }
GeoCsrfTest >> testWrongTokenIsForbidden [

	| visit request |
	visit := self visit.
	request := self request: (ZnRequest post: '/greet') cookie: visit key.
	request headers at: 'X-CSRF-Token' put: GeoSecureRandom token.
	self assert: (app handleRequest: request) status equals: 403
]

{ #category : 'helpers' }
GeoCsrfTest >> visit [
	"Visit a page; answer the cookie and the CSRF token that a browser would hold afterwards."

	| response cookie request |
	response := app handleRequest: (ZnRequest get: '/greet/Ann').
	cookie := (self sessionCookieOf: response) nameValueString.
	request := GeoRequest on: (self request: (ZnRequest get: '/greet/Ann') cookie: cookie) pathParameters: Dictionary new.
	request session: (app sessions sessionFor: request znRequest).
	^ cookie -> request csrfToken
]
