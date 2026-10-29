"
I describe how to load GeoHttp: a small web server layer on Zinc, with routing, endpoints, sessions and CSRF protection. It knows no HTML templates or htmx.

	Metacello new
		baseline: 'GeoHttp';
		repository: 'github://gobith/PharoHtmx:main/src';
		load

Groups: Core (GeoHttp), Tests (GeoHttp-Tests).
"
Class {
	#name : 'BaselineOfGeoHttp',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGeoHttp',
	#package : 'BaselineOfGeoHttp'
}

{ #category : 'baselines' }
BaselineOfGeoHttp >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'GeoHttp';
				package: 'GeoHttp-Tests' with: [ spec requires: #( 'GeoHttp' ) ].
			spec
				group: 'Core' with: #( 'GeoHttp' );
				group: 'Tests' with: #( 'GeoHttp-Tests' );
				group: 'default' with: #( 'Core' 'Tests' ) ]
]
