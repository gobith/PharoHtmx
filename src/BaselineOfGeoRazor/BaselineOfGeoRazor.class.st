"
I describe how to load GeoRazor: HTML templates in methods, with the Razor compiler, the editor and debugger support, and GeoComponent. It knows no web or htmx.

	Metacello new
		baseline: 'GeoRazor';
		repository: 'github://gobith/PharoHtmx:main/src';
		load

Groups: Core (GeoRazor), Tests (GeoRazor-Tests). GeoRazor needs Pharo 14 and overrides three Pharo methods; see the README.
"
Class {
	#name : 'BaselineOfGeoRazor',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGeoRazor',
	#package : 'BaselineOfGeoRazor'
}

{ #category : 'baselines' }
BaselineOfGeoRazor >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'GeoRazor';
				package: 'GeoRazor-Tests' with: [ spec requires: #( 'GeoRazor' ) ].
			spec
				group: 'Core' with: #( 'GeoRazor' );
				group: 'Tests' with: #( 'GeoRazor-Tests' );
				group: 'default' with: #( 'Core' 'Tests' ) ]
]
