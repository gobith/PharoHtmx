"
One to-do item, with a button that asks for confirmation and deletes it (hx-delete with hx-confirm).
"
Class {
	#name : 'HxSpikeTodoItem',
	#superclass : 'HxComponent',
	#instVars : [
		'todo'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
HxSpikeTodoItem class >> delete: request [
	"Delete a to-do item; answer nothing, so htmx removes it."
	<delete: '/showcase/todos/<id>'>

	request app showcase removeTodo: (request at: #id) asInteger.
	^ ''
]

{ #category : 'instance creation' }
HxSpikeTodoItem class >> todo: aTodo [

	^ self new setTodo: aTodo
]

{ #category : 'rendering' }
HxSpikeTodoItem >> render [
<li>
  <span>{{ todo text }}</span>
  <button hx-delete="{{ self path: #delete with: todo id }}" hx-confirm="Delete this item?" hx-target="closest li" hx-swap="outerHTML">Delete</button>
</li>
]

{ #category : 'initialization' }
HxSpikeTodoItem >> setTodo: aTodo [

	todo := aTodo
]

{ #category : 'accessing' }
HxSpikeTodoItem >> todo [

	^ todo
]
