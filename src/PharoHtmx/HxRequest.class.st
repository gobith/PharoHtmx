"
I wrap a ZnRequest together with the path parameters of the endpoint that matched it, the app and the visitor's session.

#at: looks a name up in the path parameters, then the query, then the form fields of a POST. #htmx tells what htmx says about the request (see HxHtmxRequest). #session is the visitor's ZnServerSession; #csrfToken is its secret token, which a request that changes something must send back (see HxApp>>isAllowed:).
"
Class {
	#name : 'HxRequest',
	#superclass : 'Object',
	#instVars : [
		'znRequest',
		'pathParameters',
		'app',
		'session'
	],
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
HxRequest class >> on: aZnRequest pathParameters: aDictionary [

	^ self new setZnRequest: aZnRequest pathParameters: aDictionary
]

{ #category : 'accessing' }
HxRequest >> app [
	"The app that handles me."

	^ app
]

{ #category : 'initialization' }
HxRequest >> app: anApp [

	app := anApp
]

{ #category : 'accessing' }
HxRequest >> at: aName [

	^ self at: aName ifAbsent: [ KeyNotFound signalFor: aName ]
]

{ #category : 'accessing' }
HxRequest >> at: aName ifAbsent: aBlock [
	"Look aName up in the path parameters, then the query, then the form fields."

	| entity |
	pathParameters at: aName asSymbol ifPresent: [ :value | ^ value ].
	(znRequest url queryAt: aName asString ifAbsent: [ nil ]) ifNotNil: [ :value | ^ value ].
	entity := znRequest entity.
	(entity isKindOf: ZnApplicationFormUrlEncodedEntity) ifTrue: [ ^ entity at: aName asString ifAbsent: aBlock ].
	^ aBlock value
]

{ #category : 'security' }
HxRequest >> csrfToken [
	"The secret of this session that a page sends back with every request that changes something; see HxApp>>isAllowed:. Made at the first ask."

	^ session attributeAt: #csrfToken ifAbsentPut: [ HxSecureRandom token ]
]

{ #category : 'security' }
HxRequest >> hasValidCsrfToken [
	"Did the browser send the CSRF token of this session?"

	^ HxSecureRandom secret: self sentCsrfToken matches: self csrfToken
]

{ #category : 'accessing' }
HxRequest >> headerAt: aName [
	"Answer the value of the header aName, nil when it is absent."

	^ znRequest headers at: aName ifAbsent: [ nil ]
]

{ #category : 'accessing' }
HxRequest >> htmx [
	"What htmx tells about this request; see HxHtmxRequest."

	^ HxHtmxRequest on: znRequest
]

{ #category : 'testing' }
HxRequest >> isHtmx [
	"Did htmx send this request?"

	^ self htmx isHtmx
]

{ #category : 'security' }
HxRequest >> isSafe [
	"Does my HTTP method only read? GET, HEAD and OPTIONS must change nothing, so they need no CSRF token."

	^ #( #GET #HEAD #OPTIONS ) includes: znRequest method
]

{ #category : 'accessing' }
HxRequest >> pathParameters [

	^ pathParameters
]

{ #category : 'security' }
HxRequest >> sentCsrfToken [
	"The CSRF token the browser sent: the header X-CSRF-Token, which htmx sends (see HxHtmxAttributes>>csrfToken:), or else the form field csrf-token of a plain form. Never the query string, which ends up in logs."

	| entity |
	(self headerAt: 'X-CSRF-Token') ifNotNil: [ :token | ^ token ].
	entity := znRequest entity.
	(entity isKindOf: ZnApplicationFormUrlEncodedEntity) ifTrue: [ ^ entity at: 'csrf-token' ifAbsent: [ nil ] ].
	^ nil
]

{ #category : 'accessing' }
HxRequest >> session [
	"The session of the visitor (a ZnServerSession), nil outside an app."

	^ session
]

{ #category : 'initialization' }
HxRequest >> session: aSession [

	session := aSession
]

{ #category : 'initialization' }
HxRequest >> setZnRequest: aZnRequest pathParameters: aDictionary [

	znRequest := aZnRequest.
	pathParameters := aDictionary
]

{ #category : 'accessing' }
HxRequest >> znRequest [

	^ znRequest
]
