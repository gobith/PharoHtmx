"
The book list.
"
Class {
	#name : 'HxTestBooksRoute',
	#superclass : 'HxTestRoute',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestBooksRoute class >> pattern [

	^ '/books'
]

{ #category : 'handling' }
HxTestBooksRoute >> handle [

	^ 'list'
]
