"
I describe how to load PharoHtmx with Metacello.

	Metacello new
		baseline: 'PharoHtmx';
		repository: 'github://gobith/PharoHtmx:main/src';
		load

Groups:
- Core: the app and the routing (PharoHtmx).
- Razor: components and pages, whose render methods are HTML, with the Razor compiler and the editor and debugger support (PharoHtmx-Razor). Needs Core.
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
		spec
			package: 'PharoHtmx';
			package: 'PharoHtmx-Razor' with: [ spec requires: #( 'PharoHtmx' ) ];
			package: 'PharoHtmx-Tests' with: [ spec requires: #( 'PharoHtmx' ) ];
			package: 'PharoHtmx-Spike' with: [ spec requires: #( 'PharoHtmx' 'PharoHtmx-Razor' ) ].
		spec
			group: 'Core' with: #( 'PharoHtmx' );
			group: 'Razor' with: #( 'PharoHtmx-Razor' );
			group: 'Spike' with: #( 'PharoHtmx-Spike' );
			group: 'Tests' with: #( 'PharoHtmx-Tests' 'PharoHtmx-Spike' );
			group: 'default' with: #( 'Core' 'Razor' 'Spike' 'Tests' ) ]
]
