"
I test GeoSecureRandom: random bytes and tokens from the operating system, and the comparison of secrets.
"
Class {
	#name : 'GeoSecureRandomTest',
	#superclass : 'TestCase',
	#category : 'GeoHttp-Tests-Tests',
	#package : 'GeoHttp-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
GeoSecureRandomTest >> testBytes [

	self assert: (GeoSecureRandom bytes: 16) size equals: 16.
	self assert: (GeoSecureRandom bytes: 0) isEmpty.
	self deny: (GeoSecureRandom bytes: 32) equals: (GeoSecureRandom bytes: 32)
]

{ #category : 'tests' }
GeoSecureRandomTest >> testSecretMatches [

	self assert: (GeoSecureRandom secret: 'abc' matches: 'abc').
	self deny: (GeoSecureRandom secret: 'abc' matches: 'abd').
	self deny: (GeoSecureRandom secret: 'abc' matches: 'abcd').
	self deny: (GeoSecureRandom secret: nil matches: 'abc').
	self deny: (GeoSecureRandom secret: 'abc' matches: nil)
]

{ #category : 'tests' }
GeoSecureRandomTest >> testToken [

	| tokens |
	tokens := (1 to: 100) collect: [ :each | GeoSecureRandom token ].
	self assert:
		(tokens allSatisfy: [ :each | each size = 64 and: [ each allSatisfy: [ :char | '0123456789abcdef' includes: char ] ] ]).
	self assert: tokens asSet size equals: 100
]
