"
The data behind the examples on the showcase page: the note to edit inline, the to-do list and the number of pings. HxSpikeApp holds one, shared by everyone who visits.
"
Class {
	#name : 'HxSpikeShowcase',
	#superclass : 'Object',
	#instVars : [
		'note',
		'todos',
		'nextId',
		'pings'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'todos' }
HxSpikeShowcase >> addTodo: aString [
	"Add a to-do item and answer it."

	nextId := nextId + 1.
	^ todos add: (HxSpikeTodo id: nextId text: aString)
]

{ #category : 'initialization' }
HxSpikeShowcase >> initialize [

	super initialize.
	note := 'Click Edit to change this text.'.
	todos := OrderedCollection new.
	nextId := 0.
	pings := 0.
	self addTodo: 'Try the examples on this page'.
	self addTodo: 'Read the code under each of them'
]

{ #category : 'note' }
HxSpikeShowcase >> note [

	^ note
]

{ #category : 'note' }
HxSpikeShowcase >> note: aString [

	note := aString
]

{ #category : 'pings' }
HxSpikeShowcase >> ping [

	pings := pings + 1
]

{ #category : 'pings' }
HxSpikeShowcase >> pings [

	^ pings
]

{ #category : 'todos' }
HxSpikeShowcase >> removeTodo: anInteger [
	"Remove the to-do item with id anInteger; answer whether there was one."

	| size |
	size := todos size.
	todos removeAllSuchThat: [ :each | each id = anInteger ].
	^ todos size < size
]

{ #category : 'todos' }
HxSpikeShowcase >> todos [

	^ todos
]
