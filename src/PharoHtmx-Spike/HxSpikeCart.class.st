"
A shopping cart: how many of each book, in the order they were first added.
"
Class {
	#name : 'HxSpikeCart',
	#superclass : 'Object',
	#instVars : [
		'quantities'
	],
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'adding' }
HxSpikeCart >> add: aBook [

	quantities at: aBook put: (self quantityOf: aBook) + 1
]

{ #category : 'accessing' }
HxSpikeCart >> count [
	"Answer the number of books, counting each copy."

	^ quantities inject: 0 into: [ :sum :each | sum + each ]
]

{ #category : 'removing' }
HxSpikeCart >> decrement: aBook [
	"Take one aBook out; the last one removes its line."

	| quantity |
	quantity := (self quantityOf: aBook) - 1.
	quantity > 0
		ifTrue: [ quantities at: aBook put: quantity ]
		ifFalse: [ self remove: aBook ]
]

{ #category : 'initialization' }
HxSpikeCart >> initialize [

	super initialize.
	quantities := OrderedDictionary new
]

{ #category : 'testing' }
HxSpikeCart >> isEmpty [

	^ quantities isEmpty
]

{ #category : 'accessing' }
HxSpikeCart >> lines [

	^ quantities associations collect: [ :each | HxSpikeCartLine book: each key quantity: each value ]
]

{ #category : 'accessing' }
HxSpikeCart >> quantityOf: aBook [

	^ quantities at: aBook ifAbsent: [ 0 ]
]

{ #category : 'removing' }
HxSpikeCart >> remove: aBook [

	quantities removeKey: aBook ifAbsent: [ nil ]
]

{ #category : 'removing' }
HxSpikeCart >> removeAll [

	quantities removeAll
]

{ #category : 'accessing' }
HxSpikeCart >> totalString [

	^ HxSpikeBook formatCents: (self lines inject: 0 into: [ :sum :each | sum + each totalInCents ])
]
