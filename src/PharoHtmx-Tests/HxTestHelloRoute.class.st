"
A greeting as an HTML fragment.
"
Class {
	#name : 'HxTestHelloRoute',
	#superclass : 'HxTestRoute',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routing' }
HxTestHelloRoute class >> pattern [

	^ '/hello/<name>'
]

{ #category : 'handling' }
HxTestHelloRoute >> handle [

	^ '<p>Hello ' , (self at: #name) , '</p>'
]
