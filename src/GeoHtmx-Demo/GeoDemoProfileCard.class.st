"
A card that shows a profile and edits it in place, both from the profile's Magritte descriptions: the values are listed with the labels of the descriptions, and Edit swaps them for an GeoMagritteForm. Like the note, it is one component in two states; target and swap sit once on the outer element.
"
Class {
	#name : 'GeoDemoProfileCard',
	#superclass : 'GeoComponent',
	#instVars : [
		'profile',
		'editing',
		'form'
	],
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'endpoints' }
GeoDemoProfileCard class >> cancel: request [
	"Drop the changes and show the values as they were."

	<get>
	^ self profile: request app showcase profile
]

{ #category : 'endpoints' }
GeoDemoProfileCard class >> edit: request [
	"Swap the values for a form that edits them."

	<get>
	^ (self profile: request app showcase profile)
		  beEditing;
		  yourself
]

{ #category : 'instance creation' }
GeoDemoProfileCard class >> profile: aProfile [

	^ self new setProfile: aProfile
]

{ #category : 'endpoints' }
GeoDemoProfileCard class >> save: request [
	"Store the values of the form when they are valid and show them; otherwise show the form with its errors."

	<put>
	| card |
	card := (self profile: request app showcase profile)
		        beEditing;
		        yourself.
	^ (card form saveFrom: request)
		  ifTrue: [ self profile: request app showcase profile ]
		  ifFalse: [ card ]
]

{ #category : 'accessing' }
GeoDemoProfileCard >> beEditing [
	"Show the form instead of the values."

	editing := true
]

{ #category : 'accessing' }
GeoDemoProfileCard >> descriptions [
	"The descriptions of the profile, in the order of their priority."

	^ profile magritteDescription children
]

{ #category : 'accessing' }
GeoDemoProfileCard >> form [
	"The form of the profile: Save sends a PUT, Cancel asks for the values again."

	^ form ifNil: [
			  form := (GeoMagritteForm on: profile)
				          submit: (self hx action: #save:);
				          cancel: (self hx action: #cancel:);
				          yourself ]
]

{ #category : 'accessing' }
GeoDemoProfileCard >> isEditing [

	^ editing = true
]

{ #category : 'accessing' }
GeoDemoProfileCard >> profile [

	^ profile
]

{ #category : 'rendering' }
GeoDemoProfileCard >> render [
<div id="profile" class="box" {{ self hx targetThis; swapOuter }}>
  @self isEditing
    ifTrue: [
      {{ self form }}
    ]
    ifFalse: [
      <dl class="stats">
        @self descriptions do: [ :description |
          <dt>{{ description label }}</dt>
          <dd>{{ self textOf: description }}</dd>
        ]
      </dl>
      <button {{ self hx action: #edit: }}>Edit</button>
    ]
</div>
]

{ #category : 'accessing' }
GeoDemoProfileCard >> setProfile: aProfile [

	profile := aProfile
]

{ #category : 'accessing' }
GeoDemoProfileCard >> textOf: aDescription [
	"The value of aDescription as text, as the description writes it; a dash when there is none."

	^ (aDescription read: profile) ifNil: [ '-' ] ifNotNil: [ :value | aDescription toString: value ]
]
