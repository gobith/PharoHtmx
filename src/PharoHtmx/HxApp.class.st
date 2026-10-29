"
I am the superclass of a web app. I am the delegate of a ZnServer: for every request I find the visitor's session, find the endpoint (see HxRouter), check the CSRF token when the request changes something, and turn the answer into a ZnResponse.

Subclasses override #routes to list their pages, components and route classes. The list is read for every request, so a change to it works at once on a running server. #layoutFor: puts a page in a layout.

Sessions and CSRF: #sessions keeps the sessions (see HxSessionManager); a new session gets its cookie on the response. A POST, PUT, PATCH or DELETE must carry the CSRF token of its session, in the header X-CSRF-Token or the form field csrf-token, or I answer 403 (see #isAllowed:). A layout puts the token on the body with HxHtmxAttributes>>csrfToken:, so every htmx request of the page sends it. #checksCsrf answers false only for an app that no browser uses.

	MyApp new startOn: 8080.
	...
	app stop
"
Class {
	#name : 'HxApp',
	#superclass : 'Object',
	#instVars : [
		'server',
		'sessions'
	],
	#category : 'PharoHtmx-Core',
	#package : 'PharoHtmx',
	#tag : 'Core'
}

{ #category : 'security' }
HxApp >> checksCsrf [
	"Do I check the CSRF token? Override to answer false only for an app that no browser uses, such as an API for other programs."

	^ true
]

{ #category : 'routes' }
HxApp >> endpoints [
	"The endpoints of my routes: a route class or page is one endpoint, a component has one per endpoint method."

	^ self routes flatCollect: [ :each | each endpoints ]
]

{ #category : 'security' }
HxApp >> forbidden [
	"The answer to a request that changes something without the right CSRF token."

	^ (ZnResponse statusCode: 403)
		  entity: (ZnEntity text: 'Forbidden: this request needs the CSRF token of its page.');
		  yourself
]

{ #category : 'request handling' }
HxApp >> handleRequest: aZnRequest [
	"Called by the ZnServer for every request: find the visitor's session, find the endpoint, check the CSRF token when the request changes something, and answer. A new session gets its cookie on the response."

	| session match response |
	session := self sessions sessionFor: aZnRequest.
	match := self router match: aZnRequest.
	response := match
		            ifNil: [ ZnResponse notFound: aZnRequest url ]
		            ifNotNil: [
				            match value
					            app: self;
					            session: session.
				            (self isAllowed: match value)
					            ifTrue: [ self responseFor: (match key handle: match value in: self) request: aZnRequest ]
					            ifFalse: [ self forbidden ] ].
	(self sessions sessionIdFromRequest: aZnRequest) = session id ifFalse: [ self sessions setSession: session in: response ].
	^ response
]

{ #category : 'security' }
HxApp >> isAllowed: anHxRequest [
	"A request that only reads is always allowed. One that changes something (POST, PUT, PATCH, DELETE) must carry the CSRF token of its session, so that another site cannot make the visitor's browser send it."

	^ anHxRequest isSafe or: [ self checksCsrf not or: [ anHxRequest hasValidCsrfToken ] ]
]

{ #category : 'rendering' }
HxApp >> layoutFor: aPage [
	"The component that is the whole document around aPage. Override to put pages in a layout; by default a page is the whole document itself."

	^ aPage
]

{ #category : 'request handling' }
HxApp >> responseFor: anObject request: aZnRequest [
	"A route answers a ZnResponse, something that converts itself with #asZnResponse (a component, an HxHtmxResponse), or a String that becomes an HTML page. nil means no route matched."

	anObject ifNil: [ ^ ZnResponse notFound: aZnRequest url ].
	(anObject isKindOf: ZnResponse) ifTrue: [ ^ anObject ].
	(anObject respondsTo: #asZnResponse) ifTrue: [ ^ anObject asZnResponse ].
	^ ZnResponse ok: (ZnEntity html: anObject asString)
]

{ #category : 'routes' }
HxApp >> router [

	^ HxRouter routes: self endpoints
]

{ #category : 'routes' }
HxApp >> routes [
	"Override to answer the route classes of the app (see HxRoute), as in
		^ { BookList. BookDetail }"

	^ #(  )
]

{ #category : 'accessing' }
HxApp >> server [

	^ server
]

{ #category : 'accessing' }
HxApp >> sessions [
	"The sessions of my visitors; see HxSessionManager."

	^ sessions ifNil: [ sessions := HxSessionManager new ]
]

{ #category : 'server' }
HxApp >> startOn: aPort [

	self stop.
	server := (ZnServer on: aPort)
		          delegate: self;
		          start;
		          yourself
]

{ #category : 'server' }
HxApp >> stop [

	server ifNotNil: [
			server stop.
			server := nil ]
]
