"
Update one book.
"
Class {
	#name : 'GeoTestUpdateBookRoute',
	#superclass : 'GeoTestRoute',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestUpdateBookRoute class >> httpMethod [

	^ #POST
]

{ #category : 'routing' }
GeoTestUpdateBookRoute class >> pattern [

	^ '/books/<id>'
]

{ #category : 'handling' }
GeoTestUpdateBookRoute >> handle [

	^ 'updated ' , (self at: #id)
]
