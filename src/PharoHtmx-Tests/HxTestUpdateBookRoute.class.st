"
Update one book.
"
Class {
	#name : 'HxTestUpdateBookRoute',
	#superclass : 'HxTestRoute',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestUpdateBookRoute class >> httpMethod [

	^ #POST
]

{ #category : 'routing' }
HxTestUpdateBookRoute class >> pattern [

	^ '/books/<id>'
]

{ #category : 'handling' }
HxTestUpdateBookRoute >> handle [

	^ 'updated ' , (self at: #id)
]
