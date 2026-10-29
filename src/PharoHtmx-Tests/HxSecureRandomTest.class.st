"
I test HxSecureRandom: random bytes and tokens from the operating system, and the comparison of secrets.
"
Class {
	#name : 'HxSecureRandomTest',
	#superclass : 'TestCase',
	#category : 'PharoHtmx-Tests-Security',
	#package : 'PharoHtmx-Tests',
	#tag : 'Security'
}

{ #category : 'tests' }
HxSecureRandomTest >> testBytes [

	self assert: (HxSecureRandom bytes: 16) size equals: 16.
	self assert: (HxSecureRandom bytes: 0) isEmpty.
	self deny: (HxSecureRandom bytes: 32) equals: (HxSecureRandom bytes: 32)
]

{ #category : 'tests' }
HxSecureRandomTest >> testSecretMatches [

	self assert: (HxSecureRandom secret: 'abc' matches: 'abc').
	self deny: (HxSecureRandom secret: 'abc' matches: 'abd').
	self deny: (HxSecureRandom secret: 'abc' matches: 'abcd').
	self deny: (HxSecureRandom secret: nil matches: 'abc').
	self deny: (HxSecureRandom secret: 'abc' matches: nil)
]

{ #category : 'tests' }
HxSecureRandomTest >> testToken [

	| tokens |
	tokens := (1 to: 100) collect: [ :each | HxSecureRandom token ].
	self assert:
		(tokens allSatisfy: [ :each | each size = 64 and: [ each allSatisfy: [ :char | '0123456789abcdef' includes: char ] ] ]).
	self assert: tokens asSet size equals: 100
]
