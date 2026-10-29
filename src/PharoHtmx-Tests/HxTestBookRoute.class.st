"
One book.
"
Class {
	#name : 'HxTestBookRoute',
	#superclass : 'HxTestRoute',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestBookRoute class >> pattern [

	^ '/books/<id>'
]

{ #category : 'handling' }
HxTestBookRoute >> handle [

	^ 'book ' , (self at: #id)
]
