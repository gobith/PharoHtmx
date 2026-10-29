"
The book list.
"
Class {
	#name : 'GeoTestBooksRoute',
	#superclass : 'GeoTestRoute',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestBooksRoute class >> pattern [

	^ '/books'
]

{ #category : 'handling' }
GeoTestBooksRoute >> handle [

	^ 'list'
]
