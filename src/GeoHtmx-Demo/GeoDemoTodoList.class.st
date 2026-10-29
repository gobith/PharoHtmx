"
A to-do list: the form adds an item at the end of the list (hx-swap=""beforeend""), each item deletes itself.
"
Class {
	#name : 'GeoDemoTodoList',
	#superclass : 'GeoComponent',
	#instVars : [
		'todos'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
GeoDemoTodoList class >> add: request [
	"Add a to-do item; answer the item to put at the end of the list."
	<post>

	| text |
	text := (request at: #text ifAbsent: [ '' ]) trimBoth.
	text ifEmpty: [ ^ '' ].
	^ GeoDemoTodoItem todo: (request app showcase addTodo: text)
]

{ #category : 'instance creation' }
GeoDemoTodoList class >> todos: aCollection [

	^ self new setTodos: aCollection
]

{ #category : 'rendering' }
GeoDemoTodoList >> render [
<form class="add"
  {{ self hx
       action: #add:;
       target: '#todo-list';
       swapBeforeEnd;
       on: 'htmx:after-request' do: 'this.reset()' }}>
  <input name="text" placeholder="Something to do" required>
  <button type="submit">Add</button>
</form>
<ul id="todo-list" class="todos">
  @todos do: [ :todo |
    {{ GeoDemoTodoItem todo: todo }}
  ]
</ul>
]

{ #category : 'initialization' }
GeoDemoTodoList >> setTodos: aCollection [

	todos := aCollection
]

{ #category : 'accessing' }
GeoDemoTodoList >> todos [

	^ todos
]
