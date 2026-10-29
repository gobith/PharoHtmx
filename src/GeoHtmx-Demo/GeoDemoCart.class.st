"
A shopping cart: how many of each book, in the order they were first added.
"
Class {
	#name : 'GeoDemoCart',
	#superclass : 'Object',
	#instVars : [
		'quantities'
	],
	#category : 'GeoHtmx-Demo-Model',
	#package : 'GeoHtmx-Demo',
	#tag : 'Model'
}

{ #category : 'adding' }
GeoDemoCart >> add: aBook [

	quantities at: aBook put: (self quantityOf: aBook) + 1
]

{ #category : 'accessing' }
GeoDemoCart >> count [
	"Answer the number of books, counting each copy."

	^ quantities inject: 0 into: [ :sum :each | sum + each ]
]

{ #category : 'removing' }
GeoDemoCart >> decrement: aBook [
	"Take one aBook out; the last one removes its line."

	| quantity |
	quantity := (self quantityOf: aBook) - 1.
	quantity > 0
		ifTrue: [ quantities at: aBook put: quantity ]
		ifFalse: [ self remove: aBook ]
]

{ #category : 'initialization' }
GeoDemoCart >> initialize [

	super initialize.
	quantities := OrderedDictionary new
]

{ #category : 'testing' }
GeoDemoCart >> isEmpty [

	^ quantities isEmpty
]

{ #category : 'accessing' }
GeoDemoCart >> lines [

	^ quantities associations collect: [ :each | GeoDemoCartLine book: each key quantity: each value ]
]

{ #category : 'accessing' }
GeoDemoCart >> quantityOf: aBook [

	^ quantities at: aBook ifAbsent: [ 0 ]
]

{ #category : 'removing' }
GeoDemoCart >> remove: aBook [

	quantities removeKey: aBook ifAbsent: [ nil ]
]

{ #category : 'removing' }
GeoDemoCart >> removeAll [

	quantities removeAll
]

{ #category : 'accessing' }
GeoDemoCart >> totalString [

	^ GeoDemoBook formatCents: (self lines inject: 0 into: [ :sum :each | sum + each totalInCents ])
]
