"
A greeting as an HTML fragment.
"
Class {
	#name : 'GeoTestHelloRoute',
	#superclass : 'GeoTestRoute',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestHelloRoute class >> pattern [

	^ '/hello/<name>'
]

{ #category : 'handling' }
GeoTestHelloRoute >> handle [

	^ '<p>Hello ' , (self at: #name) , '</p>'
]
