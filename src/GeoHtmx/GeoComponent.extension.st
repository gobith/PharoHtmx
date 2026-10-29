Extension { #name : 'GeoComponent' }

{ #category : '*GeoHtmx' }
GeoComponent >> asZnResponse [
	"Answer me as an HTML response, so a route or page can answer a component."

	^ ZnResponse ok: (ZnEntity html: self toHtml)
]

{ #category : '*GeoHtmx' }
GeoComponent class >> endpoints [
	"The endpoints in my class-side methods; see GeoEndpoint."

	^ GeoEndpoint allIn: self
]

{ #category : '*GeoHtmx' }
GeoComponent >> hx [
	"New htmx attributes for an element of mine, to build with a cascade in a view; #action: names my endpoints. See GeoHtmxAttributes.
		<button {{ self hx
		             action: #edit:;
		             swapOuter }}>Edit</button>"

	^ GeoHtmxAttributes for: self class
]

{ #category : '*GeoHtmx' }
GeoComponent >> path: anAction [
	"The path of my endpoint anAction, as in self path: #edit: for the class-side method edit:."

	^ self class pathOf: anAction
]

{ #category : '*GeoHtmx' }
GeoComponent >> path: anAction with: anObject [
	"The path of my endpoint anAction with its parameters filled in, as in self path: #delete: with: todo id."

	^ self class pathOf: anAction with: anObject
]

{ #category : '*GeoHtmx' }
GeoComponent class >> pathOf: anAction [
	"The path of my endpoint anAction, as in GeoDemoClock pathOf: #tick:."

	^ (GeoEndpoint in: self selector: anAction) path
]

{ #category : '*GeoHtmx' }
GeoComponent class >> pathOf: anAction with: anObject [
	"The path of my endpoint anAction with its parameters filled in, as in GeoDemoTodoItem pathOf: #delete: with: todo id."

	^ (GeoEndpoint in: self selector: anAction) pathWith: anObject
]
