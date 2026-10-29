"
The form for a new book; a literal segment that a parameter route also matches.
"
Class {
	#name : 'GeoTestNewBookRoute',
	#superclass : 'GeoTestRoute',
	#category : 'GeoHttp-Tests-Fixtures',
	#package : 'GeoHttp-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
GeoTestNewBookRoute class >> pattern [

	^ '/books/new'
]

{ #category : 'handling' }
GeoTestNewBookRoute >> handle [

	^ 'form'
]
