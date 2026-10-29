"
One to-do item, with a button that asks for confirmation and deletes it (hx-delete with hx-confirm).
"
Class {
	#name : 'GeoDemoTodoItem',
	#superclass : 'GeoComponent',
	#instVars : [
		'todo'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
GeoDemoTodoItem class >> delete: request [
	"Delete a to-do item; answer nothing, so htmx removes it."
	<delete: '/showcase/todos/<id>'>

	request app showcase removeTodo: (request at: #id) asInteger.
	^ ''
]

{ #category : 'instance creation' }
GeoDemoTodoItem class >> todo: aTodo [

	^ self new setTodo: aTodo
]

{ #category : 'rendering' }
GeoDemoTodoItem >> render [
<li>
  <span>{{ todo text }}</span>
  <button
    {{ self hx
         action: #delete: with: todo id;
         confirm: 'Delete this item?';
         targetClosest: 'li';
         swapOuter }}>
    Delete
  </button>
</li>
]

{ #category : 'initialization' }
GeoDemoTodoItem >> setTodo: aTodo [

	todo := aTodo
]

{ #category : 'accessing' }
GeoDemoTodoItem >> todo [

	^ todo
]
