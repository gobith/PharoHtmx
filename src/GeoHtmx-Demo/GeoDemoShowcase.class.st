"
The data behind the examples on the showcase page: the note to edit inline, the to-do list, the number of pings and the profile of the forms example. GeoDemoApp holds one, shared by everyone who visits.
"
Class {
	#name : 'GeoDemoShowcase',
	#superclass : 'Object',
	#instVars : [
		'note',
		'todos',
		'nextId',
		'pings',
		'profile'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'todos' }
GeoDemoShowcase >> addTodo: aString [
	"Add a to-do item and answer it."

	nextId := nextId + 1.
	^ todos add: (GeoDemoTodo id: nextId text: aString)
]

{ #category : 'initialization' }
GeoDemoShowcase >> initialize [

	super initialize.
	note := 'Click Edit to change this text.'.
	todos := OrderedCollection new.
	nextId := 0.
	pings := 0.
	self addTodo: 'Try the examples on this page'.
	self addTodo: 'Read the code under each of them'
]

{ #category : 'note' }
GeoDemoShowcase >> note [

	^ note
]

{ #category : 'note' }
GeoDemoShowcase >> note: aString [

	note := aString
]

{ #category : 'pings' }
GeoDemoShowcase >> ping [

	pings := pings + 1
]

{ #category : 'pings' }
GeoDemoShowcase >> pings [

	^ pings
]

{ #category : 'profile' }
GeoDemoShowcase >> profile [

	^ profile ifNil: [ profile := GeoDemoProfile new ]
]

{ #category : 'todos' }
GeoDemoShowcase >> removeTodo: anInteger [
	"Remove the to-do item with id anInteger; answer whether there was one."

	| size |
	size := todos size.
	todos removeAllSuchThat: [ :each | each id = anInteger ].
	^ todos size < size
]

{ #category : 'todos' }
GeoDemoShowcase >> todos [

	^ todos
]
