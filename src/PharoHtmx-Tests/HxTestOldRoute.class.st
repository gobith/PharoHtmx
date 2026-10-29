"
A route that answers a ZnResponse.
"
Class {
	#name : 'HxTestOldRoute',
	#superclass : 'HxTestRoute',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestOldRoute class >> pattern [

	^ '/old'
]

{ #category : 'handling' }
HxTestOldRoute >> handle [

	^ ZnResponse redirect: '/new'
]
