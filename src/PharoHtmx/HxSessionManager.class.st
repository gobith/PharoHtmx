"
I keep the sessions of an app, as Zinc's session manager does, with two changes for safety:
- a session id is a secret from HxSecureRandom, not a UUID from Pharo's Random, so nobody can guess another visitor's id;
- the session cookie is HttpOnly, so scripts in the page cannot read it, and SameSite=Lax, so the browser does not send it along with a POST from another site. Behind HTTPS, #beSecure adds Secure, so the cookie never travels over plain HTTP.

HxApp asks me for the session of each request (#sessionFor:) and puts the cookie on the response when the session is new (#setSession:in:). A session ends after an hour without requests.
"
Class {
	#name : 'HxSessionManager',
	#superclass : 'ZnServerSessionManager',
	#instVars : [
		'secure'
	],
	#category : 'PharoHtmx-Security',
	#package : 'PharoHtmx',
	#tag : 'Security'
}

{ #category : 'initialization' }
HxSessionManager >> beSecure [
	"Send the session cookie over HTTPS only. Use it when the app runs behind HTTPS."

	secure := true
]

{ #category : 'accessing' }
HxSessionManager >> cookieName [

	^ 'hx-session'
]

{ #category : 'testing' }
HxSessionManager >> isSecure [

	^ secure = true
]

{ #category : 'private' }
HxSessionManager >> newSessionId [
	"A secret that nobody can guess."

	^ HxSecureRandom token
]

{ #category : 'public' }
HxSessionManager >> setSession: aSession in: aResponse [
	"Put the cookie of aSession on aResponse: HttpOnly, SameSite=Lax, and Secure when I am secure."

	aSession ifNil: [ ^ self ].
	aResponse addCookie: (ZnCookie fromString: (String streamContents: [ :stream |
			 stream
				 nextPutAll: self cookieName;
				 nextPut: $=;
				 nextPutAll: aSession id;
				 nextPutAll: '; path=/; httponly; samesite=Lax'.
			 self isSecure ifTrue: [ stream nextPutAll: '; secure' ] ]))
]
