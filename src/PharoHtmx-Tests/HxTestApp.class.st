"
An app with the test routes, for HxAppTest.
"
Class {
	#name : 'HxTestApp',
	#superclass : 'HxApp',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'routes' }
HxTestApp >> routes [

	^ {
		  HxTestHelloRoute.
		  HxTestOldRoute }
]
