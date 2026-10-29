Extension { #name : 'GeoRequest' }

{ #category : '*GeoHtmx' }
GeoRequest >> htmx [
	"What htmx tells about this request; see GeoHtmxRequest."

	^ GeoHtmxRequest on: znRequest
]

{ #category : '*GeoHtmx' }
GeoRequest >> isHtmx [
	"Did htmx send this request?"

	^ self htmx isHtmx
]
