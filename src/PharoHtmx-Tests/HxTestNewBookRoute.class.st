"
The form for a new book; a literal segment that a parameter route also matches.
"
Class {
	#name : 'HxTestNewBookRoute',
	#superclass : 'HxTestRoute',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestNewBookRoute class >> pattern [

	^ '/books/new'
]

{ #category : 'handling' }
HxTestNewBookRoute >> handle [

	^ 'form'
]
