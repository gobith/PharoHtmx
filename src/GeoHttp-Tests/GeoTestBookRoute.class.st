"
One book.
"
Class {
	#name : 'GeoTestBookRoute',
	#superclass : 'GeoTestRoute',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestBookRoute class >> pattern [

	^ '/books/<id>'
]

{ #category : 'handling' }
GeoTestBookRoute >> handle [

	^ 'book ' , (self at: #id)
]
