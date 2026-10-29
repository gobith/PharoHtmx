"
An app with an endpoint that changes something (HxTestGreeter class>>#whoAmI:, a POST), for HxCsrfTest.
"
Class {
	#name : 'HxTestCsrfApp',
	#superclass : 'HxApp',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routes' }
HxTestCsrfApp >> routes [

	^ { HxTestGreeter }
]
