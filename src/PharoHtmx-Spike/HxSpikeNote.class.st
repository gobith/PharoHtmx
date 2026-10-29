"
A text that the visitor edits in place. Edit swaps it for a form, Save stores the text and Cancel drops the change; each answers the note again, in the state to show.
"
Class {
	#name : 'HxSpikeNote',
	#superclass : 'HxComponent',
	#instVars : [
		'text',
		'editing'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
HxSpikeNote class >> cancel: request [
	"Drop the change and show the text as it was."
	<get>

	^ self text: request app showcase note
]

{ #category : 'endpoints' }
HxSpikeNote class >> edit: request [
	"Swap the text for a form that edits it."
	<get>

	^ (self text: request app showcase note)
		  beEditing;
		  yourself
]

{ #category : 'endpoints' }
HxSpikeNote class >> save: request [
	"Store the text from the form and show it."
	<put>

	request app showcase note: (request at: #text ifAbsent: [ '' ]).
	^ self text: request app showcase note
]

{ #category : 'instance creation' }
HxSpikeNote class >> text: aString [

	^ self new setText: aString
]

{ #category : 'initialization' }
HxSpikeNote >> beEditing [
	"Show the form instead of the text."

	editing := true
]

{ #category : 'testing' }
HxSpikeNote >> isEditing [

	^ editing = true
]

{ #category : 'rendering' }
HxSpikeNote >> render [
<div id="note" class="box note" {{ self hx targetThis; swapOuter }}>
  @self isEditing
    ifTrue: [
      <form class="note-form" {{ self hx action: #save }}>
        <input name="text" value="{{ text }}" autofocus>
        <button type="submit">Save</button>
        <button type="button" {{ self hx action: #cancel }}>Cancel</button>
      </form>
    ]
    ifFalse: [
      <p>{{ text }}</p>
      <button {{ self hx action: #edit }}>Edit</button>
    ]
</div>
]

{ #category : 'initialization' }
HxSpikeNote >> setText: aString [

	text := aString
]

{ #category : 'accessing' }
HxSpikeNote >> text [

	^ text
]
