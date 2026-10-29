"
A to-do list: the form adds an item at the end of the list (hx-swap=""beforeend""), each item deletes itself.
"
Class {
	#name : 'HxSpikeTodoList',
	#superclass : 'HxComponent',
	#instVars : [
		'todos'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
HxSpikeTodoList class >> add: request [
	"Add a to-do item; answer the item to put at the end of the list."
	<post>

	| text |
	text := (request at: #text ifAbsent: [ '' ]) trimBoth.
	text ifEmpty: [ ^ '' ].
	^ HxSpikeTodoItem todo: (request app showcase addTodo: text)
]

{ #category : 'instance creation' }
HxSpikeTodoList class >> todos: aCollection [

	^ self new setTodos: aCollection
]

{ #category : 'rendering' }
HxSpikeTodoList >> render [
<form class="add" hx-post="{{ self path: #add }}" hx-target="#todo-list" hx-swap="beforeend" hx-on::after-request="this.reset()">
  <input name="text" placeholder="Something to do" required>
  <button type="submit">Add</button>
</form>
<ul id="todo-list" class="todos">
  @todos do: [ :todo |
    @self render: (HxSpikeTodoItem todo: todo)
  ]
</ul>
]

{ #category : 'initialization' }
HxSpikeTodoList >> setTodos: aCollection [

	todos := aCollection
]

{ #category : 'accessing' }
HxSpikeTodoList >> todos [

	^ todos
]
