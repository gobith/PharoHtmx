"
A minimal book for the Razor spike. Prices are in euro cents.
"
Class {
	#name : 'GeoDemoBook',
	#superclass : 'Object',
	#instVars : [
		'id',
		'title',
		'available',
		'priceInCents'
	],
	#category : 'GeoHtmx-Demo-Model',
	#package : 'GeoHtmx-Demo',
	#tag : 'Model'
}

{ #category : 'formatting' }
GeoDemoBook class >> formatCents: anInteger [
	"Answer anInteger euro cents as money, as in '€12.99'."

	^ '€' , (anInteger // 100) printString , '.' , (anInteger \\ 100 printPaddedWith: $0 to: 2)
]

{ #category : 'instance creation' }
GeoDemoBook class >> id: anInteger title: aString price: cents available: aBoolean [

	^ self new
		  setId: anInteger
		  title: aString
		  price: cents
		  available: aBoolean
]

{ #category : 'accessing' }
GeoDemoBook >> available: aBoolean [

	available := aBoolean
]

{ #category : 'descriptions' }
GeoDemoBook >> descriptionAvailable [
	"Whether the book can be ordered."

	<magritteDescription>
	^ MABooleanDescription new
		  accessor: (MASelectorAccessor read: #isAvailable write: #available:);
		  label: 'Available';
		  priority: 30;
		  yourself
]

{ #category : 'descriptions' }
GeoDemoBook >> descriptionPrice [
	"The price in euro cents: required, from 0 to 1000 euro."

	<magritteDescription>
	^ MANumberDescription new
		  accessor: #priceInCents;
		  label: 'Price in cents';
		  priority: 20;
		  beRequired;
		  beInteger;
		  min: 0 max: 100000;
		  yourself
]

{ #category : 'descriptions' }
GeoDemoBook >> descriptionTitle [
	"The title: required, at most 100 characters."

	<magritteDescription>
	^ MAStringDescription new
		  accessor: #title;
		  label: 'Title';
		  priority: 10;
		  beRequired;
		  addCondition: [ :value | value size <= 100 ] labelled: 'At most 100 characters';
		  yourself
]

{ #category : 'accessing' }
GeoDemoBook >> id [

	^ id
]

{ #category : 'testing' }
GeoDemoBook >> isAvailable [

	^ available
]

{ #category : 'accessing' }
GeoDemoBook >> priceInCents [

	^ priceInCents
]

{ #category : 'accessing' }
GeoDemoBook >> priceInCents: anInteger [

	priceInCents := anInteger
]

{ #category : 'accessing' }
GeoDemoBook >> priceString [

	^ self class formatCents: priceInCents
]

{ #category : 'initialization' }
GeoDemoBook >> setId: anInteger title: aString price: cents available: aBoolean [

	id := anInteger.
	title := aString.
	priceInCents := cents.
	available := aBoolean
]

{ #category : 'accessing' }
GeoDemoBook >> title [

	^ title
]

{ #category : 'accessing' }
GeoDemoBook >> title: aString [

	title := aString
]
