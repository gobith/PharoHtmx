"
I wrap a ZnRequest together with the path parameters of the endpoint that matched it, the app and the visitor's session.

#at: looks a name up in the path parameters, then the query, then the form fields of a POST. #htmx tells what htmx says about the request (see GeoHtmxRequest). #session is the visitor's ZnServerSession; #csrfToken is its secret token, which a request that changes something must send back (see GeoApp>>isAllowed:).
"
Class {
	#name : 'GeoRequest',
	#superclass : 'Object',
	#instVars : [
		'znRequest',
		'pathParameters',
		'app',
		'session'
	],
	#category : 'GeoHttp-Routing',
	#package : 'GeoHttp',
	#tag : 'Routing'
}

{ #category : 'instance creation' }
GeoRequest class >> on: aZnRequest pathParameters: aDictionary [

	^ self new setZnRequest: aZnRequest pathParameters: aDictionary
]

{ #category : 'accessing' }
GeoRequest >> app [
	"The app that handles me."

	^ app
]

{ #category : 'initialization' }
GeoRequest >> app: anApp [

	app := anApp
]

{ #category : 'accessing' }
GeoRequest >> at: aName [

	^ self at: aName ifAbsent: [ KeyNotFound signalFor: aName ]
]

{ #category : 'accessing' }
GeoRequest >> at: aName ifAbsent: aBlock [
	"Look aName up in the path parameters, then the query, then the form fields."

	| entity |
	pathParameters at: aName asSymbol ifPresent: [ :value | ^ value ].
	(znRequest url queryAt: aName asString ifAbsent: [ nil ]) ifNotNil: [ :value | ^ value ].
	entity := znRequest entity.
	(entity isKindOf: ZnApplicationFormUrlEncodedEntity) ifTrue: [ ^ entity at: aName asString ifAbsent: aBlock ].
	^ aBlock value
]

{ #category : 'security' }
GeoRequest >> csrfToken [
	"The secret of this session that a page sends back with every request that changes something; see GeoApp>>isAllowed:. Made at the first ask."

	^ session attributeAt: #csrfToken ifAbsentPut: [ GeoSecureRandom token ]
]

{ #category : 'security' }
GeoRequest >> hasValidCsrfToken [
	"Did the browser send the CSRF token of this session?"

	^ GeoSecureRandom secret: self sentCsrfToken matches: self csrfToken
]

{ #category : 'accessing' }
GeoRequest >> headerAt: aName [
	"Answer the value of the header aName, nil when it is absent."

	^ znRequest headers at: aName ifAbsent: [ nil ]
]

{ #category : 'security' }
GeoRequest >> isSafe [
	"Does my HTTP method only read? GET, HEAD and OPTIONS must change nothing, so they need no CSRF token."

	^ #( #GET #HEAD #OPTIONS ) includes: znRequest method
]

{ #category : 'accessing' }
GeoRequest >> pathParameters [

	^ pathParameters
]

{ #category : 'security' }
GeoRequest >> sentCsrfToken [
	"The CSRF token the browser sent: the header X-CSRF-Token, which htmx sends (see GeoHtmxAttributes>>csrfToken:), or else the form field csrf-token of a plain form. Never the query string, which ends up in logs."

	| entity |
	(self headerAt: 'X-CSRF-Token') ifNotNil: [ :token | ^ token ].
	entity := znRequest entity.
	(entity isKindOf: ZnApplicationFormUrlEncodedEntity) ifTrue: [ ^ entity at: 'csrf-token' ifAbsent: [ nil ] ].
	^ nil
]

{ #category : 'accessing' }
GeoRequest >> session [
	"The session of the visitor (a ZnServerSession), nil outside an app."

	^ session
]

{ #category : 'initialization' }
GeoRequest >> session: aSession [

	session := aSession
]

{ #category : 'initialization' }
GeoRequest >> setZnRequest: aZnRequest pathParameters: aDictionary [

	znRequest := aZnRequest.
	pathParameters := aDictionary
]

{ #category : 'accessing' }
GeoRequest >> znRequest [

	^ znRequest
]
