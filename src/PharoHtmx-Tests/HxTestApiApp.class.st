"
An app for other programs, not for browsers, which switches the CSRF check off; for HxCsrfTest.
"
Class {
	#name : 'HxTestApiApp',
	#superclass : 'HxTestCsrfApp',
	#category : 'PharoHtmx-Tests-Fixtures',
	#package : 'PharoHtmx-Tests',
	#tag : 'Fixtures'
}

{ #category : 'security' }
HxTestApiApp >> checksCsrf [

	^ false
]
