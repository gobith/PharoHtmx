"
A text that the visitor edits in place. Edit swaps it for a form, Save stores the text and Cancel drops the change; each answers the note again, in the state to show.
"
Class {
	#name : 'GeoDemoNote',
	#superclass : 'GeoComponent',
	#instVars : [
		'text',
		'editing'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
GeoDemoNote class >> cancel: request [
	"Drop the change and show the text as it was."
	<get>

	^ self text: request app showcase note
]

{ #category : 'endpoints' }
GeoDemoNote class >> edit: request [
	"Swap the text for a form that edits it."
	<get>

	^ (self text: request app showcase note)
		  beEditing;
		  yourself
]

{ #category : 'endpoints' }
GeoDemoNote class >> save: request [
	"Store the text from the form and show it."
	<put>

	request app showcase note: (request at: #text ifAbsent: [ '' ]).
	^ self text: request app showcase note
]

{ #category : 'instance creation' }
GeoDemoNote class >> text: aString [

	^ self new setText: aString
]

{ #category : 'initialization' }
GeoDemoNote >> beEditing [
	"Show the form instead of the text."

	editing := true
]

{ #category : 'testing' }
GeoDemoNote >> isEditing [

	^ editing = true
]

{ #category : 'rendering' }
GeoDemoNote >> render [
<div id="note" class="box note" {{ self hx targetThis; swapOuter }}>
  @self isEditing
    ifTrue: [
      <form class="note-form" {{ self hx action: #save: }}>
        <input name="text" value="{{ text }}" autofocus>
        <button type="submit">Save</button>
        <button type="button" {{ self hx action: #cancel: }}>Cancel</button>
      </form>
    ]
    ifFalse: [
      <p>{{ text }}</p>
      <button {{ self hx action: #edit: }}>Edit</button>
    ]
</div>
]

{ #category : 'initialization' }
GeoDemoNote >> setText: aString [

	text := aString
]

{ #category : 'accessing' }
GeoDemoNote >> text [

	^ text
]
