"
I answer random bytes that are fit for secrets, such as session ids and CSRF tokens. They come from the operating system, which gathers entropy from hardware and events: /dev/urandom on Linux and macOS, BCryptGenRandom on Windows.

Pharo's own Random is fast and fine for simulations, but it is not unpredictable enough for secrets: someone who sees enough of its numbers can work out the next ones.

	GeoSecureRandom bytes: 16    ""a ByteArray of 16 random bytes""
	GeoSecureRandom token        ""32 random bytes as 64 hex digits, for a cookie or a header""
"
Class {
	#name : 'GeoSecureRandom',
	#superclass : 'Object',
	#category : 'GeoHttp-Security',
	#package : 'GeoHttp',
	#tag : 'Security'
}

{ #category : 'private' }
GeoSecureRandom class >> bcryptGenRandom: anAlgorithm into: aByteArray size: anInteger flags: aFlags [
	"NTSTATUS BCryptGenRandom(BCRYPT_ALG_HANDLE hAlgorithm, PUCHAR pbBuffer, ULONG cbBuffer, ULONG dwFlags) in bcrypt.dll. Answers 0 on success."

	^ self
		  ffiCall: #( long BCryptGenRandom #( void #* anAlgorithm #, ByteArray aByteArray #, ulong anInteger #, ulong aFlags ) )
		  library: 'bcrypt.dll'
]

{ #category : 'random' }
GeoSecureRandom class >> bytes: anInteger [
	"Answer anInteger random bytes from the operating system."

	^ OSPlatform current isWindows
		  ifTrue: [ self windowsBytes: anInteger ]
		  ifFalse: [ self unixBytes: anInteger ]
]

{ #category : 'comparing' }
GeoSecureRandom class >> secret: aString matches: anotherString [
	"Compare two secrets in a time that does not depend on where they differ, so the time of a failed guess tells nothing about the secret."

	| difference |
	(aString isString and: [ anotherString isString ]) ifFalse: [ ^ false ].
	aString size = anotherString size ifFalse: [ ^ false ].
	difference := 0.
	aString with: anotherString do: [ :a :b | difference := difference bitOr: (a asInteger bitXor: b asInteger) ].
	^ difference = 0
]

{ #category : 'random' }
GeoSecureRandom class >> token [
	"Answer 32 random bytes as 64 hex digits: a secret that nobody can guess, for a session id or a CSRF token."

	^ (self bytes: 32) hex
]

{ #category : 'private' }
GeoSecureRandom class >> unixBytes: anInteger [
	"Read anInteger bytes from /dev/urandom, the random source of Linux and macOS."

	| bytes |
	bytes := '/dev/urandom' asFileReference binaryReadStreamDo: [ :stream | stream next: anInteger ].
	bytes size = anInteger ifFalse: [ self error: 'Could not read ' , anInteger printString , ' bytes from /dev/urandom' ].
	^ bytes
]

{ #category : 'private' }
GeoSecureRandom class >> windowsBytes: anInteger [
	"Fill a ByteArray with anInteger bytes from BCryptGenRandom, the random source of Windows. Flag 2 is BCRYPT_USE_SYSTEM_PREFERRED_RNG, which needs no algorithm handle."

	| bytes status |
	bytes := ByteArray new: anInteger.
	status := self
		          bcryptGenRandom: ExternalAddress null
		          into: bytes
		          size: anInteger
		          flags: 2.
	status = 0 ifFalse: [ self error: 'BCryptGenRandom failed with status ' , status printString ].
	^ bytes
]
