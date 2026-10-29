"
A profile for the forms example on the showcase page. Its Magritte descriptions say once what each field is and which rules it has; HxSpikeProfileCard shows the profile and edits it from those descriptions alone.
"
Class {
	#name : 'HxSpikeProfile',
	#superclass : 'Object',
	#instVars : [
		'name',
		'email',
		'age',
		'newsletter',
		'bio'
	],
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'accessing' }
HxSpikeProfile >> age [

	^ age
]

{ #category : 'accessing' }
HxSpikeProfile >> age: anInteger [

	age := anInteger
]

{ #category : 'accessing' }
HxSpikeProfile >> bio [

	^ bio
]

{ #category : 'accessing' }
HxSpikeProfile >> bio: aString [

	bio := aString
]

{ #category : 'descriptions' }
HxSpikeProfile >> descriptionAge [
	"The age in years: a whole number from 0 to 130, not required."

	<magritteDescription>
	^ MANumberDescription new
		  accessor: #age;
		  label: 'Age';
		  priority: 30;
		  beInteger;
		  min: 0 max: 130;
		  yourself
]

{ #category : 'descriptions' }
HxSpikeProfile >> descriptionBio [
	"A few lines about the person: at most 280 characters."

	<magritteDescription>
	^ MAMemoDescription new
		  accessor: #bio;
		  label: 'About';
		  priority: 50;
		  addCondition: [ :value | value size <= 280 ] labelled: 'At most 280 characters';
		  yourself
]

{ #category : 'descriptions' }
HxSpikeProfile >> descriptionEmail [
	"The e-mail address: required, with an @ and a dot."

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #email;
		  label: 'E-mail';
		  priority: 20;
		  beRequired;
		  addCondition: [ :value | (value includes: $@) and: [ value includes: $. ] ] labelled: 'An e-mail address has an @ and a dot';
		  yourself
]

{ #category : 'descriptions' }
HxSpikeProfile >> descriptionName [
	"The name: required."

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #name;
		  label: 'Name';
		  priority: 10;
		  beRequired;
		  yourself
]

{ #category : 'descriptions' }
HxSpikeProfile >> descriptionNewsletter [
	"Whether the profile gets the newsletter, shown as Yes or No."

	<magritteDescription>
	^ MABooleanDescription new
		  accessor: #newsletter;
		  label: 'Newsletter';
		  priority: 40;
		  trueString: 'Yes';
		  falseString: 'No';
		  yourself
]

{ #category : 'accessing' }
HxSpikeProfile >> email [

	^ email
]

{ #category : 'accessing' }
HxSpikeProfile >> email: aString [

	email := aString
]

{ #category : 'initialization' }
HxSpikeProfile >> initialize [

	super initialize.
	name := 'Ada Lovelace'.
	email := 'ada@example.org'.
	age := 36.
	newsletter := true.
	bio := 'Wrote the first program, for a machine that was never built.'
]

{ #category : 'accessing' }
HxSpikeProfile >> name [

	^ name
]

{ #category : 'accessing' }
HxSpikeProfile >> name: aString [

	name := aString
]

{ #category : 'accessing' }
HxSpikeProfile >> newsletter [

	^ newsletter
]

{ #category : 'accessing' }
HxSpikeProfile >> newsletter: aBoolean [

	newsletter := aBoolean
]
