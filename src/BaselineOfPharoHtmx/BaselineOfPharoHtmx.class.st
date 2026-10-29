"
I describe how to load PharoHtmx with Metacello.

	Metacello new
		baseline: 'PharoHtmx';
		repository: 'github://gobith/PharoHtmx:main/src';
		load

Groups:
- Core: the app and the routing (PharoHtmx).
- Razor: components and pages, whose render methods are HTML, with the Razor compiler and the editor and debugger support (PharoHtmx-Razor). Needs Core.
- Magritte: forms from Magritte descriptions (PharoHtmx-Magritte). Needs Razor, Magritte Core and Grease.
- Spike: the bookshop demo and the Razor tests (PharoHtmx-Spike).
- Tests: the router tests (PharoHtmx-Tests).

PharoHtmx-Razor needs Pharo 14 and overrides three Pharo methods; see the README.
"
Class {
	#name : 'BaselineOfPharoHtmx',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoHtmx',
	#package : 'BaselineOfPharoHtmx'
}

{ #category : 'baselines' }
BaselineOfPharoHtmx >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec preLoadDoIt: #definePackageOrganizerAlias.
		spec
			baseline: 'Grease' with: [
					spec
						repository: 'github://SeasideSt/Grease:master/repository';
						loads: #( 'Core' ) ];
			baseline: 'Magritte' with: [
					spec
						repository: 'github://magritte-metamodel/magritte:master';
						loads: #( 'Core' ) ].
		spec
			package: 'PharoHtmx';
			package: 'PharoHtmx-Razor' with: [ spec requires: #( 'PharoHtmx' ) ];
			package: 'PharoHtmx-Tests' with: [ spec requires: #( 'PharoHtmx' ) ];
			package: 'PharoHtmx-Magritte' with: [ spec requires: #( 'PharoHtmx-Razor' 'Grease' 'Magritte' ) ];
			package: 'PharoHtmx-Spike' with: [ spec requires: #( 'PharoHtmx' 'PharoHtmx-Razor' 'PharoHtmx-Magritte' ) ].
		spec
			group: 'Core' with: #( 'PharoHtmx' );
			group: 'Razor' with: #( 'PharoHtmx-Razor' );
			group: 'Magritte' with: #( 'PharoHtmx-Magritte' );
			group: 'Spike' with: #( 'PharoHtmx-Spike' );
			group: 'Tests' with: #( 'PharoHtmx-Tests' 'PharoHtmx-Spike' );
			group: 'default' with: #( 'Core' 'Razor' 'Magritte' 'Spike' 'Tests' ) ]
]

{ #category : 'doits' }
BaselineOfPharoHtmx >> definePackageOrganizerAlias [
	"Magritte's baseline still names RPackageOrganizer, which Pharo 12 renamed to PackageOrganizer."

	Smalltalk globals at: #RPackageOrganizer ifAbsent: [ Smalltalk globals at: #RPackageOrganizer put: PackageOrganizer ]
]
