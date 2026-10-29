"
I describe how to load GeoHtmx: htmx on top of GeoRazor and GeoHttp, with forms from Magritte and a demo.

	Metacello new
		baseline: 'GeoHtmx';
		repository: 'github://gobith/PharoHtmx:main/src';
		load

Groups:
- Core: GeoHtmx, with GeoRazor and GeoHttp.
- Magritte: GeoHtmx-Magritte, forms from Magritte descriptions. Needs Magritte Core and Grease.
- Demo: GeoHtmx-Demo, the bookshop and the showcase.
- Tests: the tests of all modules.
Magritte on Pharo 14 needs two steps before loading; see the README.
"
Class {
	#name : 'BaselineOfGeoHtmx',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGeoHtmx',
	#package : 'BaselineOfGeoHtmx'
}

{ #category : 'baselines' }
BaselineOfGeoHtmx >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec preLoadDoIt: #definePackageOrganizerAlias.
			spec
				baseline: 'GeoRazor' with: [ spec repository: 'github://gobith/PharoHtmx:main/src' ];
				baseline: 'GeoHttp' with: [ spec repository: 'github://gobith/PharoHtmx:main/src' ];
				baseline: 'Grease' with: [
						spec
							repository: 'github://SeasideSt/Grease:master/repository';
							loads: #( 'Core' ) ];
				baseline: 'Magritte' with: [
					spec
						repository: 'github://magritte-metamodel/magritte:master';
						loads: #( 'Core' ) ].
			spec
				package: 'GeoHtmx' with: [ spec requires: #( 'GeoRazor' 'GeoHttp' ) ];
				package: 'GeoHtmx-Tests' with: [ spec requires: #( 'GeoHtmx' ) ];
				package: 'GeoHtmx-Magritte' with: [ spec requires: #( 'GeoHtmx' 'Grease' 'Magritte' ) ];
				package: 'GeoHtmx-Demo' with: [ spec requires: #( 'GeoHtmx' 'GeoHtmx-Magritte' ) ].
			spec
				group: 'Core' with: #( 'GeoHtmx' );
				group: 'Magritte' with: #( 'GeoHtmx-Magritte' );
				group: 'Demo' with: #( 'GeoHtmx-Demo' );
				group: 'Tests' with: #( 'GeoHtmx-Tests' 'GeoHtmx-Demo' );
				group: 'default' with: #( 'Core' 'Magritte' 'Demo' 'Tests' ) ]
]

{ #category : 'doits' }
BaselineOfGeoHtmx >> definePackageOrganizerAlias [
	"Magritte's baseline still names RPackageOrganizer, which Pharo 12 renamed to PackageOrganizer."

	Smalltalk globals at: #RPackageOrganizer ifAbsent: [ Smalltalk globals at: #RPackageOrganizer put: PackageOrganizer ]
]
